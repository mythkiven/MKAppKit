
## 说明
实际效果如下图：

![](https://github.com/mythkiven/MKAppKit/blob/master/source/MKCombineLoadingAnimation.gif)


**MKCombineLoadingAnimation 是一个组合的动画效果，其中的各部分都可以单独拿出来使用 **

### 1、外层旋转动画

外层旋转动画有两种，可以使用绚丽的动画，或者简单的颜色渐变，参见 gif 演示。

1、颜色渐变的动画: 基于 Core Graphics 和 CAAnimation, 在类：JDradualLoadingView 中，使用 CGContextRef 和 CABasicAnimation 来实现的。

2、旋转的控制使用刷新频率精度较高的 CADisplayLink，颜色的渐变可根据具体需求使用图片或者代码实现。

### 2、内层的文字和转动的圆

因为要控制动画的启动、暂停，以及实际的加载速度，所以我也是基于 Core Graphics 使用 CGContextRef 来操作的。在类：JControlLoadingCircleLayer 中实现，因为是直接在 layer 中绘制，所以会有严重的锯齿现象。可以通过

     self.layer.contentsScale=[[UIScreen mainScreen] scale];

来解决在 layer 上绘制的锯齿现象。


### 3、下方加载 cell 提示
使用 scrollToRowAtIndexPath 实现:

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

这个组件写的挺早的，自从入坑区块链之后很少写 UI，本次整合到组件库，后续有时间会进一步优化。



