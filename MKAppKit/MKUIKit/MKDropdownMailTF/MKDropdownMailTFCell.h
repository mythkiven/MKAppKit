//
//
//  Created by https://github.com/mythkiven/ on 15/11/12.
//  Copyright © 2015年 3code. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKDropdownMailTFCell : UITableViewCell

/// label离tableView左边的距离
@property (assign, nonatomic) CGFloat leftEdge;

@property (strong, nonatomic) NSString *emailText;

@property (strong, nonatomic) UILabel *emailLabel;

/// 填充整个cell的button，用来响应点击事件(tableView的didSelect代理方法在自定义cell重用时不好用)
@property (weak, nonatomic) IBOutlet UIButton *touchButton;

@end
