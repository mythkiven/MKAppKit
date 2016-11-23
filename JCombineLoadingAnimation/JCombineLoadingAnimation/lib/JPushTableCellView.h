//
//  JPushTableCellView.h
//  JCombineLoadingAnimation
//
//  Created by https://github.com/mythkiven/ on 15/01/17.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPushTableCellView : UIView
@property (strong,nonatomic) UITableView    *tableCellView;
@property (strong,nonatomic) NSArray        *data;

// 控制cell的滚动
@property (assign,nonatomic) NSInteger      index;

@end
