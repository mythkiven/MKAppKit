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
#import "testViewController.h"
#import "MKPointWatch.h"

#import "MKCrashGuardManager.h"
#import "CrashTest.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,MKExceptionHandle>
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
    
    BOOL test = YES;
    if(test){
        [self execTest];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[MKPointWatch pointWatch] pointWithDescription:@"viewDidAppear"];
//    [[MKLaunchMonitor sharedMonitor] logAllCallStack];
    
}
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


#pragma mark - test crash
- (void)execTest {
    // 启用 crash 防护
    [MKCrashGuardManager executeAppGuard]; 
    [MKCrashGuardManager printLog:NO];
    [MKCrashGuardManager registerCrashHandle:self];
    // test
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
- (void)handleCrashException:(nonnull NSString *)exceptionMessage extraInfo:(nullable NSDictionary*)extraInfo {
    NSLog(@"APP log  %@ \n %@",exceptionMessage, extraInfo);
}

@end
