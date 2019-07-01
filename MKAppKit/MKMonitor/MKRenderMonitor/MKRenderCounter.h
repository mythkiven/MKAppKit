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

@interface MKRenderCounter : NSObject

// Set [MKRenderCounter sharedGeigerCounter].enabled = YES from -application:didFinishLaunchingWithOptions:.
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

// The meter draws over the status bar. Set the window level manually if your own custom windows obscure it.
@property (nonatomic, assign) UIWindowLevel windowLevel;

// Position of the meter in the status bar. Takes effect on next enable.
@property (nonatomic, assign) MKRenderCounterPosition position;

@property (nonatomic, readonly, getter = isRunning) BOOL running;
@property (nonatomic, readonly) NSInteger droppedFrameCountInLastSecond;
@property (nonatomic, readonly) NSInteger drawnFrameCountInLastSecond; // -1 until one second of frames have been collected

+ (instancetype)sharedGeigerCounter;

@end


NS_ASSUME_NONNULL_END
