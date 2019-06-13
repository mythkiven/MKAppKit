

###  MKCrashGuard

> App 运行时 Crash 自动修复 + 捕获上传

### 1、使用

- 添加组件
```
pod 'MKAppKit/MKCrashGuard'
```
- crash 日志写入沙盒
```
支持将 crash 日志写入沙盒:
```

### 2、守护的情形

- unrecognized selector sent to instance
- KVO 添加观察者后没有清除、重复添加 \ 移除 观察者 \ keyPath 导致 Crash
- KVC
- NStimer 与 Target 强引用，内存泄漏
- NSNotification iOS9 之前添加通知后，没有移除会导致 Crash
- NSString,NSArray,NSDictonary,NSAttributedString,NSSet 以及对应的可变形式
- Zombie Pointer 暂未支持
- UINavigationController 重复跳转的问题


### 3、设计原理

- 利用 Objective-C 语言的动态特性, 采用 AOP(Aspect Oriented Programming) 面向切面编程的设计思想, 做到无痕植入。对业务代码的零侵入性地将原本会导致 app 崩溃的 crash 抓取住, 消灭掉, 保证 app 继续正常地运行, 再将 crash 的具体信息提取出来, 实时返回给用户。

- 为了避免冲突，一些 hook 操作前会判断对象的类型，比如 kvo 会判断 `NSStringFromClass(object_getClass(object)` 如果包含 AMap、RACKVOProxy，就不进行 kvo 的 hook 操作。

- 可变的都继承自不可变的, 所有可变的分类中, 重复的方法就不用替换了。

###### 3.1 监听实例 dealloc

销毁的步骤
```
> 销毁实例对象时，会调用 dealloc 方法，从子类往父类，依次调用各个的 dealloc，直到 NSObject.
> NSObject 的 dealloc 会调用 object_dispose() 函数，然后释放内存。
> object_dispose 会
    * 析构 C++ 的实例变量
    * 移除 objc_setAssociatedObject 方法关联的对象
    * ARC 下调用实例变量们 (iVars) 的 release 方法，移除 weak 引用
```
objc_setAssociatedObject 策略：
```
OBJC_ASSOCIATION_ASSIGN	没有内存管理; 简单地赋值。 == assign
OBJC_ASSOCIATION_RETAIN_NONATOMIC	非原子地保留对象。 ==  nonatomic retain
OBJC_ASSOCIATION_COPY_NONATOMIC	以非原子方式复制对象。 ==  nonatomic copy
OBJC_ASSOCIATION_RETAIN	原子地保留对象。  ==    retain
OBJC_ASSOCIATION_COPY	以原子方式复制对象。 ==    copy

AssociatedObject 原理：
关联对象的实现不复杂，保存的方式为一个全局的哈希表，存取都通过查询表找到关联来执行。哈希表的特点就是牺牲空间换取时间，所以执行速度也可以保证。
```

- 由于 dealloc 方法最后会移除 Associated Object，所以当一个对象（Host）释放后，其关联的对象（Associated Object）也会被释放。
- objc_setAssociatedObject(被添加对象，key,value,AssociationPolicy / 策略) 给当前对象添加一个关联的中间对象，策略用 OBJC_ASSOCIATION_RETAIN，在关联的中间对象的 dealloc 方法中执行一些销毁相关操作。
- 需要注意的是，调用中间对象的 dealloc 时，Host 对象已经释放了。

###### 3.2 NSTimer 防护原理
```
主要解决: NSTimer 与 target  相互强引用时, 内存泄漏的问题.

防护措施: hook scheduledTimerWithTimeInterval:target:selector:userInfo:repeats, 在执行时, 当 repeats 为 NO 走原始方法, 当 repeats 为 YES, 创建一个中间对象弱引用 target, 当中间对象的 target 为空时, 清理 NSTimer。从而解决了循环引用的问题。
```

###### 3.3 NSNotification 防护原理
```
主要解决: 添加通知后, 没有移除导致 Crash 的问题。
iOS9 之后专门针对于这种情况做了处理, 所以在 iOS9 之后, 即使开发者没有移除 observer,Notification crash 也不会再产生了

防护措施: hook addObserver:selector:name:object: 和 dealloc 方法, 添加通知时, 给 observer 设置标记, 当调用 dealloc 方法时, 检查有标记则移除 observer 即可。
不过 Swizzle dealloc 影响面相对偏广，一般不建议开启。
```

###### 3.4 KVO 防护原理
```
主要解决: 添加监听后没有清除、清除不存在的 key、添加重复的 key 导致的 crash

防护措施: hook addObserver:forKeyPath:options:context: \ removeObserver:forKeyPath: \ removeObserver:forKeyPath:context:
在注册监听后, 关联一个中间对象，来维护添加的观察者和 keypath 防止重复添加或移除, 当被观察者释放时, 清除还在集合中的观察者, 从而保护 key 不存在的情况和保护重复添加的情况

```

####### 3.5 Unrecognized Selector Sent to Instance 防护原理
![](https://github.com/mythkiven/tmp/raw/master/resource/img/oc/UnrecognizedSelectorSenttoInstance_706e67.png)

```
-1. 动态决议 resolveInstanceMethod:(SEL)sel;/ resolveClassMethod:(SEL)sel ;
Forward 最先执行的函数，首先会流转到这里来，返回值是 BOOL, 没有找到就是 NO, 找到就返回 YES. 在当前的实例中加入不存在的 Selector, 并绑定 IMP。return YES
    +(BOOL)resolveInstanceMethod:(SEL)sel {
        NSString *methodName = NSStringFromSelector(sel);
        if ([methodName isEqualToString:@"test"]) {
            class_addMethod([self class], sel, (IMP)myTest,"v@:");
            return YES;
        } // "v@:" 方法的签名，代表没有参数的方法。"v@:@" 有参数的方法
    return [super resolveInstanceMethod:sel];
    }
    void myMethod(id self, SEL _cmd) {
        NSLog(@"我被调用了");
    }

-2.Target 重定向 forwardingTargetForSelector:(SEL)aSelector
如果 resolveInstanceMethod 没有处理，将进行到 forwardingTargetForSelector 这步来，这时候可以返回 nil，也可以创建用一个对象来接收消息流程流，然后在你的对象中添加不存在的 Selector，这样就不会 crash 了

    -(id)forwardingTargetForSelector:(SEL)aSelector {
        NSString *selectorName = NSStringFromSelector(aSelector);
        if ([selectorName isEqualToString:@"testMyObject"]) {
            myObject *myobject = [[myObject alloc] init];
            return myobject;
        }
        return [super forwardingTargetForSelector:aSelector];
    }

    @interface myObject : NSObject
    -(void)testMyObject;
    @end
    @implementation myObject
    -(void)testMyObject {
        NSLog(@"测试成功");
    }
    @end

-3. 转发 methodSignatureForSelector:(SEL)aSelector + forwardInvocation:(NSInvocation *)anInvocation
先调用 methodSignatureForSelector 来请求一个签名，从而生成一个 NSInvocation，对消息进行完全转发。
    -(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
        NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
        if (!signature) {
            if([myObject instancesRespondToSelector:aSelector]) {
                signature = [myObject instanceMethodSignatureForSelector:aSelector];
            }
        }
        return signature;
    }

    -(void)forwardInvocation:(NSInvocation *)anInvocation {
        if ([myObject instancesRespondToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:[[myObject alloc] init]];
        }
    }

如果上述 3 步都没找到实现，便调用 doesNotRecognizeSelector 抛出异常。
```



### 4、crash 解读 :  线程回溯

![](https://github.com/mythkiven/tmp/raw/master/resource/img/oc/ios_crash_h94jn13h0oqw2b4tbj.png)

形如上图, 是 crash 常见的形式。解读如下

```
1、2、3 略去。4 是线程回溯, 基本可以帮助定位到 crash 点:
    形如下列的线程信息:
    2   ysklib  0x0347b488          0x83000 -[CrashTest executeAllTest] + 8740
    6   MKApp   0x000000010a07b46f   -[CrashTest executeAllTest]        + 47
    依次对应: 帧编号 - 二进制库名称 - 调用方法的起始地址 - (基本地址 (指向文件中的地址))+ 调用的函数名称 + 偏移地址 (在文件中的位置)

5 是线程状态, 闪退时, 寄存器的值。基本用不到。
6 是退出时, 加载的二进制文件。
```

- 异常编码
```
Exception Codes: 不同的值, 标识不同的 crash 类型, 如下:
0x8badf00d: ate bad food: 该编码表示应用是因为发生 watchdog 超时而被 iOS 终止的。  通常是应用花费太多时间而无法启动、终止或响应用系统事件。
0xbad22222: 该编码表示 VoIP 应用因为过于频繁重启而被终止。
0xdead10cc: 该代码表明应用因为在后台运行时占用系统资源, 如通讯录数据库不释放而被终止 。
0xdeadfa11: dead fall: 该代码表示应用是被用户强制退出的。
0xc00010ff: cool off 因为太烫了被干掉
```

- 分析 demo

![](https://github.com/mythkiven/tmp/raw/master/resource/img/oc/ios_crash_jk9823hv83hv02s.png)
```
1、Exception Codes 对应是 0x000000008badf00d. crash 原因就是 watchdog 超时而被 iOS 终止的。
2、线程回溯:
从最开始调用的第 25 帧, 一帧帧的开始往上看（忽略系统库和框架）
应用执行到 第 8 帧时, 出现 crash
```

![](https://github.com/mythkiven/tmp/raw/master/resource/img/oc/ios_crash_98357927572782.png)
```
解读后, 错误出现的位置:
-[AppDelegate application:didFinishLaunchingWithOptions:] + 116      MKApp 调用了 [CrashTest executeAllTest]
-[CrashTest executeAllTest] + 47                                     MKApp 调用了  [CrashTest testArray]
-[CrashTest testArray] + 216                                         MKApp 调用了  [NSArray arrayWithObjects:count:] 导致 crash
+[NSArray arrayWithObjects:count:] + 52  这个是实际报错的位置           CoreFoundation
-[__NSPlaceholderArray initWithObjects:count:] + 237 crash 原因       CoreFoundation
_CFThrowFormattedException + 194                                    CoreFoundation
objc_exception_throw + 48                                           libobjc.A.dylib
```


### 5、常见 crash

| 类型 | 方法 | 备注 |
| --- | --- | --- |
| SEL(`unrecognized selector sent to instance`) | .h 定义但. m 没实现 | - |
| SEL | delegate 回调前没有判空而是直接调用 | - |
| SEL | id 类型没有判断类型, 强行调用了真实类型不存在的方法 | - |
| SEL | copy 修饰的可变的字符串 \ 字典 \ 数组 \ 集合 \ Data, 调用了可变的方法 | - |
| SEL | 低版本调用高版本 api | 是 | - |
| SEL | performSelector 访问不存在的方法 | - |
| Array | 数组越界、插入空对象 | - |
| Array | for 遍历的同时, 移除元素 |  使用 enumerateObjectsUsingBlock 遍历 |
| String\Array\Dic 等 | 不可变对象调用可变对象的方法 | -|
| Dict | key、value 为空 | - |
| Dict | value 为 nil 时, setObject:ForKey: 会 crash, 而 setValue:ForKey: 不会 |- |
| KVO  |  添加了监听，没有移除；添加重复的 key; 对同一 keypath 多次 removeObserver: 父类有一个 KVO, 父类在 dealloc 中 remove 了一次, 子类又 remove 了一次 |    -  |
| KVO  |  观察者或被观察者是局部变量、没有实现 observeValueForKeyPath: 方法 | 参考 FBKVOController |
| KVC  |  value 为 nil、key 不存在 |  -  |
| 多线程 |  一个线程访问的对象被另一个线程修改了 \ 释放了 |  保证多线程中读写操作的原子性: 加锁, 信号量, GCD 串行队列等 |
|  NSTimer |  没有 invalidate, 直接销毁  |  - |
| 野指针 (`EXC_BAD_ACCESS`) | property:strong/weak 修饰误用成 assign | - |
| 野指针 | objc_setAssociatedObject 属性修饰词误用成 ASSIGN | - |
| 野指针 | NSNotification\KVO 只 addObserver 并没有 removeObserver |- |
| 野指针 | delegate\block 回调前没有判空而是直接调用 | -  |
| 野指针 | CoreFoundation 对象到 Foundation 中, 已用__bridge_transfer 转移了对象的所有权之后, 调用一次 CFRelease | `__bridge: bridge 时候不要任何事情 __bridge_retained:(ObjC 转 CF 的时候使用) 在 bridge 的时候 retain 对象, 在 CF 一端负责释放对象 __bridge_transfer:(CF 转 ObjC 的时候使用) 转移 CF 对象的所有权, 不再需要在 CF 一端负责释放对象 ` |

##### 5.1 野指针

![](https://github.com/mythkiven/tmp/raw/master/resource/img/oc/ios_crash_3f4ue2y631.png)

```
野指针访问已经释放的对象 crash 其实不是必现的, 因为 dealloc 执行后只是告诉系统, 这片内存我不用了, 而系统并没有就让这片内存不能访问。
所以野指针的崩溃是比较随机的, 你在测试的时候可能没发生 crash, 但是用户在使用的时候就可能发生 crash 了。

- 对象释放后内存没被改动过, 内存完好, 或者析构时删掉一些数据, 那么可能会出现【随机 crash】。
- 对象释放后内存被改动过, 内存被写上不可访问的新数据, 很可能 Crash 在 objc_msgSend 上面（必现 Crash, 常见）
- 对象释放后内存被改动过, 内存被写上可访问的新数据, 访问时访问到别的数据, 可能【随机 crash】

self.delegate = myVC; 用 weak 修饰的
myVC 执行  Pop, 之后就会被销毁
[self.delegate doSomething]; 而 self.delegate 仍然起作用, 成了野指针

避免这种异常可以在调用之前检查一下代理是否为空, 是否能够响应所给的 Selector
if(self.delegate != nil) {
    if([self.delegate respondsToSelector:@selector(doSomething)]) {
        [self.delegate doSomething];
    }
}
```

##### 5.2 多线程 crash

一般是操作数据 / 库所致

##### 5.3 EXC_BAD_ACCESS


参考
- [what-are-the-dangers-of-method-swizzling-in-objective-c)](https://stackoverflow.com/questions/5339276/what-are-the-dangers-of-method-swizzling-in-objective-c)
- [RSSwizzle](https://github.com/rabovik/RSSwizzle/tree/master/RSSwizzle)
- [Aspects](https://github.com/steipete/Aspects/blob/master/Aspects.m)
- [Getting notified when an object instance is deallocated](https://forums.macrumors.com/threads/getting-notified-when-an-object-instance-is-deallocated.976309/)
- [JJExceptionPrinciple](https://github.com/jezzmemo/JJException/blob/master/JJExceptionPrinciple.md)
- [Fun With the Objective-C Runtime: Run Code at Deallocation of Any Object](https://blog.slaunchaman.com/2011/04/11/fun-with-the-objective-c-runtime-run-code-at-deallocation-of-any-object/)
- [facebook/KVOController](https://github.com/facebook/KVOController)