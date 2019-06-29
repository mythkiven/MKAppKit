//
//  MKPingThread.h
//  MKApp
//
//  Created by apple on 2019/6/24.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@protocol PMainThreadWatcherDelegate <NSObject>

- (void)onMainThreadSlowStackDetected:(NSArray*)slowStack;

@end

@interface MKPingThread : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<PMainThreadWatcherDelegate>     watchDelegate;


//must be called from main thread
- (void)startWatch;

@end


NS_ASSUME_NONNULL_END
