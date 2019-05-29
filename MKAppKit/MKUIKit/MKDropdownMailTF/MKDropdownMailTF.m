//
//
//  Created by https://github.com/mythkiven/ on 15/11/12.
//  Copyright © 2015年 mythkiven All rights reserved.
//

#import "MKDropdownMailTF.h"
#import "MKDropdownMailTFCell.h"

#define MK_cellH 44

@interface MKDropdownMailTF ()<UITableViewDataSource, UITableViewDelegate>

/** 邮箱下拉列表 */
@property (strong, nonatomic) UITableView *pullTableView;

/** 匹配输入的邮箱后缀数组(用来显示在列表中)dataSource*/
@property (strong, nonatomic) NSArray *matchedSuffixArray;


@end

@implementation MKDropdownMailTF

#pragma mark － 默认邮箱
- (void)setUpEmailSuffixArray {
    self.mailsuffixData = @[
                            @"gmail.com",
                            @"live.com",
                            @"qq.com",
                            @"sina.com",
                            @"126.com",
                            @"outlook.com",
                            @"foxmail.com",
                            @"hotmail.com",
                            @"tom.com",
                            @"icloud.com",
                            @"sohu.com",
                            @"msn.com",
                            @"138.com",
                            @"139.com"
                            ];
}

#pragma mark - UI创建
- (instancetype)initWithFrame:(CGRect)frame super:(UIView *)view {
    if (self = [super initWithFrame:frame]) {
        return [self setUpInView:view];
    }
    return nil;
}

- (instancetype)setUpInView:(UIView *)view {
    CGFloat textX = self.frame.origin.x;
    CGFloat textY = self.frame.origin.y;
    CGFloat textH = self.frame.size.height;
    CGFloat textW = self.frame.size.width;
    
    self.pullTableView = [[UITableView alloc] initWithFrame:CGRectMake(textX, textY+textH, textW, 4*MK_cellH) style:UITableViewStylePlain];
    self.pullTableView.dataSource = self;
    self.pullTableView.delegate = self;
    [self setUpEmailSuffixArray];
    [self.pullTableView registerNib:[UINib nibWithNibName:@"MKDropdownMailTFCell" bundle:nil]    forCellReuseIdentifier:@"MKDropdownMailTFCell"];
    self.pullTableView.userInteractionEnabled = YES;
    self.pullTableView.hidden = YES;
    [view addSubview:self.pullTableView];
    
    [self addTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    self.keyboardType = UIKeyboardTypeASCIICapable;
    
    return self;
}
#pragma mark － textFieldDidChanged
- (void)textFieldDidChanged {
    if ([self.text containsString:@"@"]) {
        self.pullTableView.hidden = NO;
        NSString *latterStr = [self.text substringFromIndex:[self.text rangeOfString:@"@"].location+1];
        if ([latterStr isEqualToString:@""]) {
            self.matchedSuffixArray = self.mailsuffixData;
        } else {
            self.matchedSuffixArray = [self.mailsuffixData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self beginswith %@", [self deleteSpacesInString:latterStr]]];
            if (self.matchedSuffixArray.count == 0) {
                self.pullTableView.hidden = YES;
            }
        }
        [self.pullTableView reloadData];
    } else {
        self.pullTableView.hidden = YES;
    }
}

#pragma mark 去掉空格
- (NSString *)deleteSpacesInString:(NSString *)string {
    if ([string containsString:@" "]) {
        return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else {
        return string;
    }
}

#pragma mark -
- (void)setMailCellHeight:(CGFloat)mailCellHeight{
    _mailCellHeight = mailCellHeight;
    [self.pullTableView reloadData];
}
-(void)setMailListHeight:(CGFloat)mailListHeight{
    _mailListHeight = mailListHeight;
    _pullTableView.frame = CGRectMake(_pullTableView.frame.origin.x,
                                      _pullTableView.frame.origin.y,
                                      _pullTableView.frame.size.width,
                                      _mailListHeight);
}

-(void)setMailListframe:(CGRect)mailListframe{ 
    _mailListframe = mailListframe;
    _pullTableView.frame = mailListframe;
}
-(void)setMailFont:(UIFont *)mailFont{
    _mailFont = mailFont;
    [self.pullTableView reloadData];
}
-(void)setMailFontColor:(UIColor *)MailFontColor{
    _MailFontColor=MailFontColor;
    [self.pullTableView reloadData];
}
-(void)setMailCellColor:(UIColor *)mailCellColor{
    _mailCellColor = mailCellColor;
    [self.pullTableView reloadData];
}
-(void)setMailBgColor:(UIColor *)mailBgColor{
    _mailBgColor = mailBgColor;
    self.pullTableView.backgroundColor =_mailBgColor;
}
- (void)setMLeftMargin:(CGFloat)margin {
    _mLeftMargin = margin;
    [self.pullTableView reloadData];
}
-(void)setMailsuffixData:(NSArray *)mailsuffixData{
    if (_mailsuffixData.count) {
        _mailsuffixData = nil;
    }
    _mailsuffixData = mailsuffixData;
    [self.pullTableView reloadData];
}
-(void)setSeparatorInsets:(NSArray *)separatorInsets{
    _separatorInsets = separatorInsets;
    [self.pullTableView reloadData];
}


- (void)hideEmailPrompt {
    self.pullTableView.hidden = YES;
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchedSuffixArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKDropdownMailTFCell *cell = [self.pullTableView dequeueReusableCellWithIdentifier:@"MKDropdownMailTFCell" forIndexPath:indexPath];
    NSString *formerStr = [self.text substringToIndex:[self.text rangeOfString:@"@"].location+1];
    cell.emailLabel.text = [formerStr stringByAppendingString:self.matchedSuffixArray[indexPath.row]]        ;
    CGRect rect = cell.emailLabel.frame;
    
    if (self.mailFont) cell.emailLabel.font = self.mailFont;
    if (self.MailFontColor) cell.emailLabel.textColor = self.MailFontColor;
    if (self.mailCellColor) cell.backgroundColor = self.mailCellColor;
    if (self.mailCellHeight) {
        rect.size.height = self.mailCellHeight;
        cell.emailLabel.frame = rect;
    } else {
        rect.size.height = MK_cellH;
        cell.emailLabel.frame = rect;
    } 
    
    rect.origin.x = self.mLeftMargin;
    cell.emailLabel.frame = rect;
    cell.touchButton.tag = indexPath.row;
    [cell.touchButton addTarget:self action:@selector(tapCell:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7 && self.separatorInsets) {
        cell.separatorInset = UIEdgeInsetsMake([self.separatorInsets[0] floatValue], [self.separatorInsets[1] floatValue], [self.separatorInsets[2] floatValue], [self.separatorInsets[3] floatValue]);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.mailCellHeight ? self.mailCellHeight : MK_cellH;
}

- (void)tapCell:(UIButton *)sender {
    NSString *formerStr = [self.text substringToIndex:[self.text rangeOfString:@"@"].location+1];
    self.text = [formerStr stringByAppendingString:self.matchedSuffixArray[sender.tag]];
    self.pullTableView.hidden = YES;
}


@end
