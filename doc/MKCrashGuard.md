

###  MKCrashGuard

> App运行时Crash自动修复+捕获上传

### 使用

- 添加组件
```
pod 'MKAppKit/MKCrashGuard'
```
- crash 日志写入沙盒
```
支持将 crash 日志写入沙盒：
```

### 守护的情形

| 类型 | 方法 | 是否支持 | 备注 |
| --- | --- | --- | --- |--- |
| SEL(`unrecognized selector sent to instance`) | .h定义但.m没实现 | 是 | .m没有实现的方法要删除掉 |
| SEL | delegate 回调前没有判空而是直接调用 | 是 | delegate 回调之前先做判空。block回调没判空是野指针错误。 |
| SEL | id类型没有判断类型，强行调用了真实类型不存在的方法 | 是 | id类型调用方法前要判断类型 |
| SEL | copy 修饰的可变的字符串\字典\数组\集合\Data，调用了可变的方法 | 是 | 写代码前要先搞清楚，各修饰词内存语义的区别 |
| SEL | 低版本调用高版本api | 是 | 不同版本的方法发，或者，对于不确定的方法，调用前最好先判断下:respondsToSelector, |
| SEL | performSelector访问不存在的方法 | 是 | 对于不确定的方法，调用前最好先判断下:respondsToSelector |
| Array | 数组越界、插入空对象| 是 |  |
| Array | for遍历的同时，移除元素| 是 | 使用enumerateObjectsUsingBlock遍历 |
| String\Array\Dic等 | 不可变对象调用可变对象的方法 | 是 |  |
| Dict | key、value为空 | 是 |  |
| Dict | value为nil时， setObject:ForKey:会crash，而setValue:ForKey:不会| 是 | 少用 setValue:ForKey |
|   |   |   |   |
| --- | --- | --- | --- |
| 以下crash,正在添加的路上|   |   |   |
| --- | --- | --- | --- |
| KVO  |  对同一keypath多次removeObserver：父类有一个KVO，父类在dealloc中remove了一次，子类又remove了一次 |  否 | addObserver和removeObserver一定要成对出现  |
| KVO  |  观察者或被观察者是局部变量、没有实现observeValueForKeyPath:方法|  否 | 参考 FBKVOController |
| KVC  |  value为nil、key不存在 |  否 | 重写相关方法  |
| 多线程 |  一个线程访问的对象被另一个线程修改了\释放了 |  否 | 保证多线程中读写操作的原子性：加锁，信号量，GCD串行队列等 |
|  NSTimer |  没有invalidate，直接销毁  |  否 | 先invalidate然后销毁  |
| 野指针 (`EXC_BAD_ACCESS`) | property:strong/weak 修饰误用成 assign | 否 | 写代码前要先搞清楚，各修饰词内存语义的区别 |
| 野指针 | objc_setAssociatedObject 属性修饰词误用成 ASSIGN | 否 | 同上(ASSIGN弱引用，其他修饰词强引用) |
| 野指针 | NSNotification\KVO 只 addObserver 并没有 removeObserver | 否 | addObserver 和 removeObserver 一定要成对出现 |
| 野指针 | delegate\block 回调前没有判空而是直接调用 | 否 | delegate\block 回调之前先做判空  |
| 野指针 | CoreFoundation 对象到 Foundation 中，已用__bridge_transfer 转移了对象的所有权之后，调用一次 CFRelease | 否 |`__bridge：bridge 时候不要任何事情 __bridge_retained:(ObjC 转 CF 的时候使用) 在 bridge 的时候 retain 对象，在 CF 一端负责释放对象 __bridge_transfer:(CF 转 ObjC 的时候使用) 转移 CF 对象的所有权，不再需要在 CF 一端负责释放对象` |

**常用调试方式**

 1、Debug阶段开启僵尸模式，Release时关闭僵尸模式
 2、Xcode设置异常断点

### 设计原理
利用Objective-C语言的动态特性，采用AOP(Aspect Oriented Programming) 面向切面编程的设计思想，做到无痕植入。对业务代码的零侵入性地将原本会导致app崩溃的crash抓取住，消灭掉，保证app继续正常地运行，再将crash的具体信息提取出来，实时返回给用户。


- 可变的都继承自不可变的，所有可变的分类中，重复的方法就不用替换了。


##### NSArray 防护：
- 快速创建

```
NSArray *array = @[@"chenfanfang", @"AvoidCrash"];
这种创建方式其实调用了： arrayWithObjects: count:
对此防护即可

NSDictionary 的快速创建 则是调用： dictionaryWithObjects:forKeys:count:

```

- (id)objectAtIndex:(NSUInteger)index
- (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range




addObject:nilStr]; //其本质是调用insertObject: