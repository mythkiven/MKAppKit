

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

| 类型 | 方法 | 是否支持 | 备注 |
| --- | --- | --- | --- |--- |
| SEL(`unrecognized selector sent to instance`) | .h 定义但. m 没实现 | 是 | .m 没有实现的方法要删除掉 |
| SEL | delegate 回调前没有判空而是直接调用 | 是 | delegate 回调之前先做判空。block 回调没判空是野指针错误。 |
| SEL | id 类型没有判断类型,强行调用了真实类型不存在的方法 | 是 | id 类型调用方法前要判断类型 |
| SEL | copy 修饰的可变的字符串 \ 字典 \ 数组 \ 集合 \ Data,调用了可变的方法 | 是 | 写代码前要先搞清楚,各修饰词内存语义的区别 |
| SEL | 低版本调用高版本 api | 是 | 不同版本的方法发,或者,对于不确定的方法,调用前最好先判断下: respondsToSelector, |
| SEL | performSelector 访问不存在的方法 | 是 | 对于不确定的方法,调用前最好先判断下: respondsToSelector |
| Array | 数组越界、插入空对象 | 是 |  |
| Array | for 遍历的同时,移除元素 | 是 | 使用 enumerateObjectsUsingBlock 遍历 |
| String\Array\Dic 等 | 不可变对象调用可变对象的方法 | 是 |  |
| Dict | key、value 为空 | 是 |  |
| Dict | value 为 nil 时, setObject:ForKey: 会 crash,而 setValue:ForKey: 不会 | 是 | 少用 setValue:ForKey |
|   |   |   |   |
| --- | --- | --- | --- |
| 以下 crash, 正在添加的路上 |   |   |   |
| --- | --- | --- | --- |
| KVO  |  对同一 keypath 多次 removeObserver: 父类有一个 KVO,父类在 dealloc 中 remove 了一次,子类又 remove 了一次 |  否 | addObserver 和 removeObserver 一定要成对出现  |
| KVO  |  观察者或被观察者是局部变量、没有实现 observeValueForKeyPath: 方法 |  否 | 参考 FBKVOController |
| KVC  |  value 为 nil、key 不存在 |  否 | 重写相关方法  |
| 多线程 |  一个线程访问的对象被另一个线程修改了 \ 释放了 |  否 | 保证多线程中读写操作的原子性: 加锁,信号量,GCD 串行队列等 |
|  NSTimer |  没有 invalidate,直接销毁  |  否 | 先 invalidate 然后销毁  |
| 野指针 (`EXC_BAD_ACCESS`) | property:strong/weak 修饰误用成 assign | 否 | 写代码前要先搞清楚,各修饰词内存语义的区别 |
| 野指针 | objc_setAssociatedObject 属性修饰词误用成 ASSIGN | 否 | 同上 (ASSIGN 弱引用,其他修饰词强引用) |
| 野指针 | NSNotification\KVO 只 addObserver 并没有 removeObserver | 否 | addObserver 和 removeObserver 一定要成对出现 |
| 野指针 | delegate\block 回调前没有判空而是直接调用 | 否 | delegate\block 回调之前先做判空  |
| 野指针 | CoreFoundation 对象到 Foundation 中,已用__bridge_transfer 转移了对象的所有权之后,调用一次 CFRelease | 否 |`__bridge: bridge 时候不要任何事情 __bridge_retained:(ObjC 转 CF 的时候使用) 在 bridge 的时候 retain 对象,在 CF 一端负责释放对象 __bridge_transfer:(CF 转 ObjC 的时候使用) 转移 CF 对象的所有权,不再需要在 CF 一端负责释放对象 ` |

** 常用调试方式 **

 1、Debug 阶段开启僵尸模式,Release 时关闭僵尸模式
 2、Xcode 设置异常断点

### 3、设计原理
利用 Objective-C 语言的动态特性,采用 AOP(Aspect Oriented Programming) 面向切面编程的设计思想,做到无痕植入。对业务代码的零侵入性地将原本会导致 app 崩溃的 crash 抓取住,消灭掉,保证 app 继续正常地运行,再将 crash 的具体信息提取出来,实时返回给用户。


- 可变的都继承自不可变的,所有可变的分类中,重复的方法就不用替换了。

###### 3.1 NSTimer 防护原理
```
主要解决: NSTimer 与 target  相互强引用时,内存泄漏的问题.

防护措施: hook scheduledTimerWithTimeInterval:target:selector:userInfo:repeats,在执行时,当 repeats 为 NO 走原始方法,当 repeats 为 YES,创建一个中间对象弱引用 target 和 NSTimer,当中间对象的 target 为空时,清理 NSTimer。从而解决了循环引用的问题。
```

###### 3.2 NSNotification 防护原理
```
主要解决: 添加通知后,没有移除导致 Crash 的问题。
iOS9 之后专门针对于这种情况做了处理,所以在 iOS9 之后,即使开发者没有移除 observer,Notification crash 也不会再产生了

防护措施: hook addObserver:selector:name:object: 和 delloc 方法, 添加通知时,给 observer 设置 kvo 属性,当调用 delloc 方法时,检查有 kvo 属性则移除 observer 即可。
不过Swizzle dealloc影响面相对偏广，慎用。
```

###### 3.3 KVO 防护原理
```
主要解决: 添加监听后没有清除、清除不存在的key、添加重复的key 导致的crash

防护措施: hook addObserver:forKeyPath:options:context: \ removeObserver:forKeyPath: \ removeObserver:forKeyPath:context:
在注册监听后,中间对象需要维护注册的数据集合,当宿主释放时,清除还在集合中的监听者,从而保护key不存在的情况和保护重复添加的情况
```


### 4、crash 解读 :  线程回溯

![](https://github.com/mythkiven/tmp/raw/master/resource/img/oc/ios_crash_h94jn13h0oqw2b4tbj.png)

形如上图,是 crash 常见的形式。解读如下

```
1、2、3 略去。4 是线程回溯,基本可以帮助定位到 crash 点: 
    形如下列的线程信息: 
    2   ysklib  0x0347b488          0x83000 -[CrashTest executeAllTest] + 8740
    6   MKApp   0x000000010a07b46f   -[CrashTest executeAllTest]        + 47
    依次对应: 帧编号 - 二进制库名称 - 调用方法的起始地址 - (基本地址 (指向文件中的地址))+ 调用的函数名称 + 偏移地址 (在文件中的位置)

5 是线程状态,闪退时,寄存器的值。基本用不到。
6 是退出时,加载的二进制文件。
```

- 异常编码
```
Exception Codes: 不同的值,标识不同的 crash 类型,如下: 
0x8badf00d: ate bad food: 该编码表示应用是因为发生 watchdog 超时而被 iOS 终止的。  通常是应用花费太多时间而无法启动、终止或响应用系统事件。
0xbad22222: 该编码表示 VoIP 应用因为过于频繁重启而被终止。
0xdead10cc: 该代码表明应用因为在后台运行时占用系统资源,如通讯录数据库不释放而被终止 。
0xdeadfa11: dead fall: 该代码表示应用是被用户强制退出的。
0xc00010ff: cool off 因为太烫了被干掉
```

- 分析 demo

![](https://github.com/mythkiven/tmp/raw/master/resource/img/oc/ios_crash_jk9823hv83hv02s.png)
```
1、Exception Codes 对应是 0x000000008badf00d. crash 原因就是 watchdog 超时而被 iOS 终止的。
2、线程回溯: 
从最开始调用的第 25 帧,一帧帧的开始往上看（忽略系统库和框架）
应用执行到 第 8 帧时,出现 crash
```

![](https://github.com/mythkiven/tmp/raw/master/resource/img/oc/ios_crash_98357927572782.png)
```
解读后,错误出现的位置: 
-[AppDelegate application:didFinishLaunchingWithOptions:] + 116      MKApp 调用了 [CrashTest executeAllTest]
-[CrashTest executeAllTest] + 47                                     MKApp 调用了  [CrashTest testArray]
-[CrashTest testArray] + 216                                         MKApp 调用了  [NSArray arrayWithObjects:count:] 导致 crash
+[NSArray arrayWithObjects:count:] + 52  这个是实际报错的位置           CoreFoundation
-[__NSPlaceholderArray initWithObjects:count:] + 237 crash 原因       CoreFoundation
_CFThrowFormattedException + 194                                    CoreFoundation
objc_exception_throw + 48                                           libobjc.A.dylib
```


### 5、常见 crash

##### 5.1 野指针

![](https://github.com/mythkiven/tmp/raw/master/resource/img/oc/ios_crash_3f4ue2y631.png)

```
野指针访问已经释放的对象 crash 其实不是必现的,因为 dealloc 执行后只是告诉系统,这片内存我不用了,而系统并没有就让这片内存不能访问。
所以野指针的崩溃是比较随机的,你在测试的时候可能没发生 crash,但是用户在使用的时候就可能发生 crash 了。

- 对象释放后内存没被改动过, 内存完好,或者析构时删掉一些数据,那么可能会出现【随机 crash】。
- 对象释放后内存被改动过, 内存被写上不可访问的新数据,很可能 Crash 在 objc_msgSend 上面（必现 Crash,常见）
- 对象释放后内存被改动过, 内存被写上可访问的新数据,访问时访问到别的数据,可能【随机 crash】

self.delegate = myVC; 用 weak 修饰的
myVC 执行  Pop,之后就会被销毁
[self.delegate doSomething]; 而 self.delegate 仍然起作用,成了野指针

避免这种异常可以在调用之前检查一下代理是否为空,是否能够响应所给的 Selector
if(self.delegate != nil) {
    if([self.delegate respondsToSelector:@selector(doSomething)]) {
        [self.delegate doSomething];
    }
}
```
##### 5.2 多线程 crash
一般是操作数据 / 库所致
##### 5.3 EXC_BAD_ACCESS 是一个比较难处理的 crash 了

##### 5.4 NSDictionary

```
元素特性: 
    @{[NSNull null]:[NSNull null]}; 防止 nsnull 对象是 OK 的。但放置 nil NULL 就编译不通过
    @{@"":nil}
    @{@"":NULL}
```


###### 5.5 NSArray 概述: 

```
- 快速创建 实际调用方法: 
NSArray *array = @[@"chenfanfang", @"AvoidCrash"];
这种创建方式其实调用了:  arrayWithObjects: count:
对此防护即可

NSDictionary 的快速创建 则是调用:  dictionaryWithObjects:forKeys:count:


 iOS 8: 下都是__NSArrayI
 iOS11: 之后分 __NSArrayI、  __NSArray0、__NSSingleObjectArrayI

 iOS11 之前: arr@[]  调用的是 [__NSArrayI objectAtIndexed]
 iOS11 之后: arr@[]  调用的是 [__NSArrayI objectAtIndexedSubscript]

```

- (id)objectAtIndex:(NSUInteger)index
- (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range




addObject:nilStr]; // 其本质是调用 insertObject:


### Method Swizzling



参考
- [what-are-the-dangers-of-method-swizzling-in-objective-c)](https://stackoverflow.com/questions/5339276/what-are-the-dangers-of-method-swizzling-in-objective-c)
- [RSSwizzle](https://github.com/rabovik/RSSwizzle/tree/master/RSSwizzle)
- [Aspects](https://github.com/steipete/Aspects/blob/master/Aspects.m)



### 日志收集


Automatically take screenshot, add tags to describe the bug.
Automatically gather device details and app context data following reporting bugs.
Automatically detect crashes and symbolicate stack traces.
Automatically collect network reqeust data.
Powerful bug lifecycle management.


在自己的程序里集成多个 Crash 日志收集服务实在不是明智之举。通常情况下,第三方功能性 SDK 都会集成一个 Crash 收集服务,以及时发现自己 SDK 的问题。当各家的服务都以保证自己的 Crash 统计正确完整为目的时,难免出现时序手脚,强行覆盖等等的恶意竞争,总会有人默默被坑。

如果同时有多方通过 NSSetUncaughtExceptionHandler 注册异常处理程序,和平的作法是: 

后注册者通过 NSGetUncaughtExceptionHandler 将先前别人注册的 handler 取出并备份,在自己 handler 处理完后自觉把别人的 handler 注册回去,规规矩矩的传递。不传递强行覆盖的后果是,在其之前注册过的日志收集服务写出的 Crash 日志就会因为取不到 NSException 而丢失 Last Exception Backtrace 等信息。（P.S. iOS 系统自带的 Crash Reporter 不受影响）

在开发测试阶段,可以利用 fishhook 框架去 hookNSSetUncaughtExceptionHandler 方法,这样就可以清晰的看到 handler 的传递流程断在哪里,快速定位污染环境者。不推荐利用调试器添加符号断点来检查,原因是一些 Crash 收集框架在调试状态下是不工作的。
