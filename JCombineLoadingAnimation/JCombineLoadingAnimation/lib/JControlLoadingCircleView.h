//
//  JControlLoadingCircleView.h
//  JCombineLoadingAnimation
//
//  Created by https://github.com/mythkiven/ on 15/01/14.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import <UIKit/UIKit.h>
// 角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
// 弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))


// 圆点进度条 外层包装
@interface JControlLoadingCircleView : UIView

    
/** 绘制的方向：默认顺时针，YES:逆时针 */
@property (nonatomic, assign) BOOL  clockwise;
/** 外切圆半径 */
@property (nonatomic, assign) CGFloat  outerRadius;
/** 内切圆半径 */
@property (nonatomic, assign) CGFloat  innerRadius;
/** 起始角度，单位:角度,3点钟方向为0度,顺时针旋转计数,默认值360度 */
@property (nonatomic, assign) CGFloat  beginAngle;
/** 两个圆间距的角度，单位是角度，默认值3度 */
@property (nonatomic, assign) CGFloat  gapAngle;

/** 圆点填充色，默认为绿色 */
@property (nonatomic, strong) UIColor *progressColor;
/** 圆点底色，  默认为无色 */
@property (nonatomic, strong) UIColor *trackColor;
/** 圆点的数量，默认为50 */
@property (nonatomic, assign) NSUInteger dotCount;
/** 进度最小数值，默认为0 */
@property (nonatomic, assign) CGFloat    minValue;
/** 进度最大数值，默认为100 */
@property (nonatomic, assign) CGFloat    maxValue;


/** 进度当前数值 */
@property (nonatomic, assign) CGFloat    currentValue;



@end
