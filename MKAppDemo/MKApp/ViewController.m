//
//  ViewController.m
//  MKApp
//
//  Created by https://github.com/mythkiven/ on 2019/4/28.
//  Copyright © 2019 MythKiven. All rights reserved.
//

#import "ViewController.h" 
#import "CombineLoadingAnimationVC.h"
#import "DropdownMailTFVC.h"
#import "MKApp-Swift.h"

#import "UTest.h"
#import "MKPointWatch.h"

#import "MKCrashGuardManager.h"
#import "CrashTest.h"
 
#import "MKRenderCounter.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,MKExceptionHandle >
@property (strong,nonatomic) UITableView *tableview;
@property (copy,nonatomic) NSArray* dataSource;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}
- (UITableView*)tableview {
    if(!_tableview){
        _tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
    }
    return _tableview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MKPointWatch pointWatch] pointWithDescription:@"viewDidLoad"];
    
    _dataSource = @[@"MKCombineLoadingAnimation",@"MKDropdownMailTF",@"MKDiffuseMenu"];
    self.title = @"MKAppKit";
    [self.view addSubview:self.tableview];
    
    
//    //    crash 防护测试
//    [self execTest];
//    //    crash 抓取测试
//    [self crashCaught];
    //    //    render test
    //    [self renderTest];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[MKPointWatch pointWatch] pointWithDescription:@"viewDidAppear"];
    
//    [[MKLaunchMonitor sharedMonitor] logAllCallStack];
    
}

#pragma mark -

#pragma mark crash抓取测试
- (void)crashCaught {
    [CrashCaughtTest testExceptionCrashCaught];
    [CrashCaughtTest testSigCrashCaught];
}
#pragma mark 帧率测试
- (void)renderTest {
    [[RenderTest new] renderTest];
}
#pragma mark crash 防护测试
- (void)execTest {
    // 启用 crash 防护
    [MKCrashGuardManager executeAppGuard];
    [MKCrashGuardManager printLog:NO];
    [MKCrashGuardManager registerCrashHandle:self];
    
    // crash test
    [[CrashTest new] executeAllTest];
    BOOL testUI = NO;
    if(testUI){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            dispatch_async(dispatch_get_main_queue(),  ^{
                testViewController *test = [testViewController new];
                [self.navigationController pushViewController:test animated:YES];
            });
        });
    }
}
#pragma mark crash 防护日志
- (void)handleCrashException:(nonnull NSString *)exceptionMessage extraInfo:(nullable NSDictionary*)extraInfo {
    // 通过 MKCrashMonitor 写入文件
    NSLog(@"APP log  %@ \n %@",exceptionMessage, extraInfo);
}

#pragma mark   -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKAppDemoCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKAppDemoCell"];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    switch (indexPath.row) {
            case 0:
                vc = [CombineLoadingAnimationVC new];
                break;
            case 1:
                vc = [DropdownMailTFVC new];
                break;
            case 2:
                vc = [DiffuseMenuVC new];
                break;
        default:
            break;
    }
    if(vc){
        [self.navigationController pushViewController:vc animated:YES];
    } 
}




@end
