//
//  MKCombineLoadingAnimationVC.m
//  MKApp
//
//  Created by https://github.com/mythkiven/ on 15/01/14.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import "MKCombineLoadingAnimationVC.h"
#import "MKLoadingManagerView.h" 
#import "MKControlLoadingCircleView.h"
#import "MKPushTableCellView.h"

@interface MKCombineLoadingAnimationVC ()
@property (weak, nonatomic) IBOutlet UIView *contain;
@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (strong, nonatomic) MKLoadingManagerView *controlView;
@property (strong, nonatomic) MKPushTableCellView  *mkPushTableCellView;
@property NSUInteger count;

@property (nonatomic,strong) NSTimer *timer;
@end

@implementation MKCombineLoadingAnimationVC
{
    NSTimer             *time;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor cyanColor]];
    
    _mkPushTableCellView = [[MKPushTableCellView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30*5)];
    _mkPushTableCellView.data = @[@"4",@"3",@"2",@"1",@"0",
                                 @"NULL",@"NULL",@"NULL",@"NULL",@"NULL"];
    NSInteger j =_mkPushTableCellView.data.count-1;
    [_mkPushTableCellView.tableCellView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [_tableView addSubview:_mkPushTableCellView];
    [self b6:nil];
    
}
- (IBAction)changeModel:(id)sender {
    self.controlView.loadingType=(self.controlView.loadingType == 10)?11:10;
}

- (IBAction)b1:(id)sender {
    if (!self.controlView) {
        self.controlView =  [[MKLoadingManagerView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.width)];
        self.controlView.loadingType = 11;
        [_contain addSubview:self.controlView];
    }
    [self.controlView startAnimationWithPercent:16 duration:4];
    _mkPushTableCellView.index = 4;
}


- (IBAction)b2:(id)sender {
    _mkPushTableCellView.index = 3;
    [self.controlView startAnimationWithPercent:16 endPercent:32 duration:8  ];
}
- (IBAction)b3:(id)sender {
    _mkPushTableCellView.index = 2;
    [self.controlView startAnimationWithPercent:32 endPercent:50 duration:4  ];
}
- (IBAction)b4:(id)sender {
    _mkPushTableCellView.index = 1;
    [self.controlView startAnimationWithPercent:50 endPercent:90 duration:8  ];
}
- (IBAction)b5:(id)sender {
    _mkPushTableCellView.index = 0;
    [self.controlView startAnimationWithPercent:90 endPercent:100 duration:2 ];
}
- (IBAction)b6:(id)sender {
    [self.controlView stopAnimation];
    NSInteger j =_mkPushTableCellView.data.count-1;
    [_mkPushTableCellView.tableCellView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


@end
