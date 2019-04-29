//
//  MKControlLoadingCircleLayer.m
//
//  Created by https://github.com/mythkiven/ on 15/01/14.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import "MKControlLoadingCircleLayer.h"

@interface MKControlLoadingCircleLayer ()
@property (nonatomic, assign) CGFloat blockAngle;
@end

@implementation MKControlLoadingCircleLayer

#pragma mark   初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
- (instancetype)initWithLayer:(id)layer {
    if (self = [super initWithLayer:layer]) {
        if ([layer isKindOfClass:[MKControlLoadingCircleLayer class]]) {
        }
    }
    return self;
}
+ (id)layer {
    MKControlLoadingCircleLayer *layer = [[MKControlLoadingCircleLayer alloc] init];
    return layer;
}
    
#pragma mark 指定属性改变时 layer刷新
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if  (   [key isEqualToString:@"clockwise"]
         || [key isEqualToString:@"outerRadius"]
         || [key isEqualToString:@"innerRadius"]
         || [key isEqualToString:@"beginAngle"]
         || [key isEqualToString:@"gapAngle"]
         || [key isEqualToString:@"progressColor"]
         || [key isEqualToString:@"trackColor"]
         || [key isEqualToString:@"dotCount"]
         || [key isEqualToString:@"minValue"]
         || [key isEqualToString:@"maxValue"]
         || [key isEqualToString:@"currentValue"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}
    
#pragma mark  绘制层 
- (void)drawInContext:(CGContextRef)ctx {
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    [self drawProgressionInContext:ctx atCenter:center];
}
    

#pragma mark 进度条
- (void)drawProgressionInContext:(CGContextRef)ctx
                        atCenter:(CGPoint)center {
    
    _blockAngle = (CGFloat)(2*M_PI-_dotCount*_gapAngle)/_dotCount;
    
    CGFloat blockValue = (_maxValue - _minValue) / _dotCount;
    NSUInteger currentBlock = (_currentValue - _minValue) / blockValue;
    
    CGFloat blockBeginAngle,blockEndAngle;
    blockBeginAngle = _beginAngle;
    blockEndAngle = _beginAngle + _blockAngle;
    
    BOOL isFill;
    for (NSUInteger i=1; i<=_dotCount; ++i) {
        if (i <= currentBlock)
            isFill = YES;
        else
            isFill = NO;
        [self drawBlockInContext:ctx center:center startAngle:blockBeginAngle endAngle:blockEndAngle isFill:isFill];
        
        if (_clockwise) {
            blockBeginAngle -= _blockAngle + _gapAngle;
            blockEndAngle -= _blockAngle + _gapAngle;
        } else {
            blockBeginAngle += _blockAngle + _gapAngle;
            blockEndAngle += _blockAngle + _gapAngle;
        }
    }
}

- (void)drawBlockInContext:(CGContextRef)ctx
                    center:(CGPoint)center
                startAngle:(CGFloat)startAngle
                  endAngle:(CGFloat)endAngle
                    isFill:(BOOL)isFill {
        
    CGFloat as = sin((CGFloat)(CGFloat)(2*M_PI-_gapAngle*_dotCount)/_dotCount)/2;
    CGFloat r =  _outerRadius*as/(as+1);
    CGFloat R = r+_innerRadius;
    CGFloat dsin =  startAngle +(endAngle - startAngle)/2;
    CGFloat x = center.x +  R*sin(dsin);
    CGFloat y = center.y +  R*cos(dsin);
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextAddArc(ctx, x, y, r, 0, 2* M_PI, 0);
    
    CGContextClosePath(ctx);
    
    UIColor *fillColor;
    if (isFill){
        fillColor = _progressColor;
    }else{
        
        fillColor = _trackColor;
    }
    CGContextSetLineWidth(ctx, 0.5);
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    
}
@end
