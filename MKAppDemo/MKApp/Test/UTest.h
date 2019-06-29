//
//  UTest.h
//  MKApp
//
//  Created by apple on 2019/6/28.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UTest : NSObject

@end



@interface RenderTest : NSObject
- (void)renderTest;
@end



@interface CaseTest : NSObject
- (void)test;
@end





@interface CrashCaughtTest : NSObject
+ (void)testCrashCaught;
@end



@interface testViewController : UIViewController
@end
NS_ASSUME_NONNULL_END
