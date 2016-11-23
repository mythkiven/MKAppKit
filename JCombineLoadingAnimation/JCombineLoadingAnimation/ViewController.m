//
//  ViewController.m
//  JCombineLoadingAnimation
//
//  Created by https://github.com/mythkiven/ on 15/01/14.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import "ViewController.h"
#import "JLoadingManagerView.h"

#import "JControlLoadingCircleView.h"

#import "JPushTableCellView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *contain;
@property (weak, nonatomic) IBOutlet UIView *tableView;

@property (strong, nonatomic) JLoadingManagerView *controlView;
    

    
@property NSUInteger count;

@property (nonatomic,strong) NSTimer *timer;
@end

@implementation ViewController
{
   
    JPushTableCellView  *_jPushTableCellView;
    NSTimer             *time;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor cyanColor]];
    
    // 配置上方的加载数据
    _controlView =  [[JLoadingManagerView alloc]initWithFrame:CGRectMake(0, 0,width, width)];
    [_contain addSubview:_controlView];
 
    
    //配置下方的cell
    _jPushTableCellView = [[JPushTableCellView alloc]initWithFrame:CGRectMake(0, 0, width, 30*5)];
    _jPushTableCellView.data = @[@"4",@"3",@"2",@"1",@"0",
                                 @"NULL",@"NULL",@"NULL",@"NULL",@"NULL"];
    NSInteger j =_jPushTableCellView.data.count-1;
    [_jPushTableCellView.tableCellView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [_tableView addSubview:_jPushTableCellView];
    [self b6:nil];
    
}

- (IBAction)b1:(id)sender {
    if (!_controlView) {
        _controlView =  [[JLoadingManagerView alloc]initWithFrame:CGRectMake(0, 0,width, width)];
        [_contain addSubview:_controlView];
    }
    
    [_controlView startAnimationWithPercent:16 duration:4];
    
    _jPushTableCellView.index = 4;
}


- (IBAction)b2:(id)sender {
    _jPushTableCellView.index = 3;
    [_controlView startAnimationWithPercent:16 endPercent:32 duration:8  ];
}
- (IBAction)b3:(id)sender {
    _jPushTableCellView.index = 2;
    [_controlView startAnimationWithPercent:32 endPercent:50 duration:4  ];
}
- (IBAction)b4:(id)sender {
    _jPushTableCellView.index = 1;
    [_controlView startAnimationWithPercent:50 endPercent:90 duration:8  ];
}
- (IBAction)b5:(id)sender {
    _jPushTableCellView.index = 0;
    [_controlView startAnimationWithPercent:90 endPercent:100 duration:2 ];
}
 
- (IBAction)b6:(id)sender {
    [_controlView removeFromSuperview];
    _controlView = nil;
    
    NSInteger j =_jPushTableCellView.data.count-1;
    [_jPushTableCellView.tableCellView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
