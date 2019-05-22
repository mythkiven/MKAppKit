

参考：

- iOS 性能监控 SDK —— Wedjat（华狄特）开发过程的调研和整理  https://github.com/aozhimin/iOS-Monitor-Platform
- https://www.itslide.com/slide/275520/

### MKMonitor 性能监控包含如下几部分

- MKEnergyMonitor：电量监控
- MKNetworkMonitor：网络流量监控
- MKRenderMonitor：渲染帧率监控
- MKCPUMonitor：CPU 监控
- MKMemoryMonitor：内存监控
- MKLaunchMonitor：app 启动监控
- MKCrashMonitor：crash 监控


### 性能监控途径

- 1、Xcode 自带的 Instrument

Xcode 自带的 Instrument 工具包含了很多强大的检测 功能：CPU、内存、磁盘、网络、卡顿、耗电等等，开发过程中可以使用这些工具辅助调试 App。

- 2、使用三方 SDK。

一些三方 SDK，像听云，OneAPM，Bugly 等利用 swizzle 方法进行 AOP 处理，在关键函数之前和之后自动埋点记录上报。使用起来会比较方便，最大的缺点就是安全性，这些 SDK 统计到的数据可能就是商业机密，并且也不清楚有没有统计其他信息。所以最好的方式就是自己实现相关的监控功能。


### 启动监控
![](../source/appLaunch.png)

启动分冷启动和热启动，热启动是 App 从 Background 到 Active，这个我们不关心，冷启动才是需要测量的中重要数据。

冷启动分为两阶段: pre-main 阶段 (点击图标 ->main) 和 main 阶段 (main->applicationDidBecomeActive)。

###### pre-main 阶段

pre main() 这个时间，一般控制在 400ms 以内。iOS10 之后，可以在 Xcode 的 Edit Scheme->Run->Environment Variables 中增加 `DYLD_PRINT_STATISTICS` 环境变量, value=1 来测量这个时间。


###### main()->applicationDidBecomeActive()


计算启动时间从 main() 的第一行代码到 applicationDidBecomeActive() 最后一行代码。这之间就是我们要计算的启动时间。







主线程阻塞超过 400 毫秒就会让用户感知到卡顿

### 相关工具

- [检测项目中未使用的图片](https://github.com/tinymind/LSUnusedResources)
- [检测项目中未使用的类](https://github.com/dblock/fui)

** 参考 **
- [dyld 与 ObjC](https://blog.cnbluebox.com/blog/2017/06/20/dyldyu-objc/)
- [WWDC2016 Optimizing App Startup Time](https://developer.apple.com/videos/play/wwdc2016/406/)
- [WWDC2017 App Startup Time: Past, Present, and Future](https://developer.apple.com/videos/play/wwdc2017/413)