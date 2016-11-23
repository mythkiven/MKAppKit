//
//  JLoadingManagerView.h
//  JCombineLoadingAnimation
//
//  Created by https://github.com/mythkiven/ on 15/01/18.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  Width [UIScreen mainScreen].bounds.size.width


@interface JLoadingManagerView : UIView

/*
    启动动画
 */
-(void)startAnimationWithPercent:(CGFloat) end duration:(CGFloat)duration;

/*
    动画的控制
 */
-(void)startAnimationWithPercent:(CGFloat)begin endPercent:(CGFloat)end duration:(CGFloat)duration ;

/*
  结束动画
 */
-(void)endAnimation;



@end
