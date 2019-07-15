/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/21.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MKRenderCounterPosition) {
    MKRenderCounterPositionLeft,
    MKRenderCounterPositionMiddle,
    MKRenderCounterPositionRight
};

typedef void(^RenderRecord)(NSDictionary *recordDic);

@interface MKRenderCounter : NSObject
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, assign) BOOL showLabel;
@property (nonatomic, assign) UIWindowLevel windowLevel;
@property (nonatomic, assign) MKRenderCounterPosition position;
@property (nonatomic, readonly, getter = isRunning) BOOL running;
@property (nonatomic, readonly) NSInteger droppedFrameCountInLastSecond;
@property (nonatomic, readonly) NSInteger drawnFrameCountInLastSecond;
@property (copy,nonatomic) RenderRecord recordRender ;

+ (instancetype)sharedRenderCounter;

@end


NS_ASSUME_NONNULL_END
