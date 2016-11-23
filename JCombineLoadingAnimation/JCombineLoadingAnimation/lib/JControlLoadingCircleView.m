//
//  JControlLoadingCircleView.m
//  JCombineLoadingAnimation
//
//  Created by https://github.com/mythkiven/ on 15/01/14.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import "JControlLoadingCircleView.h"
#import "JControlLoadingCircleLayer.h"

@implementation JControlLoadingCircleView

#pragma mark - 初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit {
    CGFloat minRadius = MIN(self.bounds.size.width, self.bounds.size.height);
    
    self.outerRadius = MIN(minRadius, 221) / 2;
    self.innerRadius = MAX(self.outerRadius - 12, 0);
    self.beginAngle = 145;
    
    self.gapAngle = 2;
    self.progressColor = [UIColor greenColor];
    self.trackColor = [UIColor grayColor];
    
    self.dotCount = 26;
    self.minValue = 0;
    self.maxValue = 100;
    self.currentValue = 50;
    
    self.layer.contentsScale=[[UIScreen mainScreen] scale];
   
}
    
#pragma mark 重设默认层
+ (Class)layerClass {
    return [JControlLoadingCircleLayer class];
}
    
#pragma mark 重新布局视图
- (void)layoutSubviews {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    [layer setNeedsDisplay];
}
    
#pragma mark - 属性
    
- (CGFloat)outerRadius {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    return layer.outerRadius;
}
    
- (void)setOuterRadius:(CGFloat)outerRadius {
    if (self.outerRadius != outerRadius) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.outerRadius = outerRadius;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)innerRadius {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    return layer.innerRadius;
}
- (void)setInnerRadius:(CGFloat)innerRadius {
    if (self.innerRadius != innerRadius) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.innerRadius = innerRadius;
        [layer setNeedsDisplay];
    }
}
    
-(void)setClockwise:(BOOL)clockwise {
    if (self.clockwise != clockwise) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.clockwise = clockwise;
        [layer setNeedsDisplay];
    }
}
    
- (CGFloat)beginAngle {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    return RADIANS_TO_DEGREES(layer.beginAngle);
}
    
- (void)setBeginAngle:(CGFloat)beginAngle {
    CGFloat radians = DEGREES_TO_RADIANS(beginAngle);
    if (self.beginAngle != radians) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.beginAngle = radians;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)gapAngle {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    return RADIANS_TO_DEGREES(layer.gapAngle);
}
    
- (void)setGapAngle:(CGFloat)gapAngle {
    CGFloat radians = DEGREES_TO_RADIANS(gapAngle);
    if (self.gapAngle != radians) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.gapAngle = radians;
        [layer setNeedsDisplay];
    }
}

- (UIColor *)progressColor {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    return layer.progressColor;
}
    
- (void)setProgressColor:(UIColor *)progressColor {
    if (![self.progressColor isEqual:progressColor]) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.progressColor = progressColor;
        [layer setNeedsDisplay];
    }
}

- (UIColor *)trackColor {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    return layer.trackColor;
}
    
- (void)setTrackColor:(UIColor *)trackColor {
    if (![self.trackColor isEqual:trackColor]) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.trackColor = trackColor;
        [layer setNeedsDisplay];
    }
}

- (NSUInteger)dotCount {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    return layer.dotCount;
}
    
- (void)setDotCount:(NSUInteger)dotCount {
    if (self.dotCount != dotCount) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.dotCount = dotCount;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)minValue {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    return layer.minValue;
}
    
- (void)setMinValue:(CGFloat)minValue {
    if (self.minValue != minValue) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.minValue = minValue;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)maxValue {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    return layer.maxValue;
}
    
- (void)setMaxValue:(CGFloat)maxValue {
    if (self.maxValue != maxValue) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.maxValue = maxValue;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)currentValue {
    JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
    return layer.currentValue;
}
    
- (void)setCurrentValue:(CGFloat)currentValue {
    if (self.currentValue != currentValue) {
        JControlLoadingCircleLayer *layer = (JControlLoadingCircleLayer *)self.layer;
        layer.currentValue = currentValue;
        [layer setNeedsDisplay];
    }
}


@end
