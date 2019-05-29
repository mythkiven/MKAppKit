//
//  MKLoadingManagerView.h
//
//  Created by https://github.com/mythkiven/ on 15/01/18.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MKControlLoadingCircleView.h"
#import "MKPushTableCellView.h"


typedef NS_ENUM(NSInteger, MKLoadingManagerType) {
    MKLoadingManagerTypeImage = 10,
    MKLoadingManagerTypeColor,
    MKLoadingManagerTypeOther,
};

@interface MKLoadingManagerView : UIView

@property (nonatomic, assign) MKLoadingManagerType loadingType;

/**  启动动画
 */
-(void)startAnimationWithPercent:(CGFloat) end duration:(CGFloat)duration;

/** 动画控制
 */
-(void)startAnimationWithPercent:(CGFloat)begin endPercent:(CGFloat)end duration:(CGFloat)duration ;

/** 结束动画
 */
-(void)stopAnimation;



@end
