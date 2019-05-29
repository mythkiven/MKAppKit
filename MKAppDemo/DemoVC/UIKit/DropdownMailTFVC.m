//
//  DropdownMailTFVC.m
//  MKApp
//
//  Created by https://github.com/mythkiven/ on 2019/4/28.
//  Copyright © 2019 MrthKiven. All rights reserved.
//

#import "DropdownMailTFVC.h"
#import "MKDropdownMailTF.h"
@interface DropdownMailTFVC ()
@property (weak, nonatomic) IBOutlet UITextField *holderView;
@end

@implementation DropdownMailTFVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.holderView.hidden = YES;
    MKDropdownMailTF *textField = [[MKDropdownMailTF alloc] initWithFrame:self.holderView.frame super:self.view];
    textField.placeholder = @"用户邮箱";
    textField.backgroundColor = [UIColor whiteColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    //自定义
    textField.mailCellHeight = 40;
    textField.mailListHeight = 40*4;
    textField.mailFont = [UIFont systemFontOfSize:16];
    textField.MailFontColor = [UIColor redColor];
    textField.mailCellColor = [UIColor lightGrayColor];
    textField.mailBgColor =[UIColor yellowColor];
    textField.mailsuffixData = @[@"live.com", @"126.com", @"gmail.com",@"qq.com"];
    
    [self.view addSubview:textField];
}


@end
