//
//
//  Created by https://github.com/mythkiven/ on 15/11/12.
//  Copyright © 2015年 mythkiven All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKDropdownMailTF : UITextField

/** 下拉提示的字符离左边的距离*/
@property (assign, nonatomic) CGFloat mLeftMargin;
/** 下拉列表的frame,相对JPullEmailTF*/
@property (assign, nonatomic) CGRect mailListframe;
/** 下拉列表的高度,默认4行cell高度 */
@property (assign, nonatomic) CGFloat mailListHeight;
/** 下拉列表行高,默认44 */
@property (assign, nonatomic) CGFloat mailCellHeight;
/** cell背景色*/
@property (nonatomic, strong) UIColor *mailCellColor; 
/** 下拉list背景色*/
@property (nonatomic, strong) UIColor *mailBgColor;
/** 下拉list字体*/
@property (nonatomic, strong) UIFont *mailFont;
/** 下拉list字体颜色*/
@property (nonatomic, strong) UIColor *MailFontColor;
/** 下拉邮箱提示后缀数组, 如@[@"live.com", @"126.com", @"gmail.com"] */
@property (nonatomic, strong) NSArray *mailsuffixData;
/**  设置下拉列表分割线的缩进, 传入一个参数数组[top, left, bottom, right], 分别是上左下右的缩进. 例如@[@1, @2, @3, @4]代表上左下右分别缩进1、2、3、4的距离*/
@property (nonatomic, strong) NSArray *separatorInsets;

/** 隐藏下拉提示 */
- (void)hideEmailPrompt;

/** 初始化JPullEmailTF */
- (instancetype)initWithFrame:(CGRect)frame super:(UIView *)view;



@end
