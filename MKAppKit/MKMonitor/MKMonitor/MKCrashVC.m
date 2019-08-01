/**
 *
 * Created by https://github.com/mythkiven/ on 19/07/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "MKCrashVC.h"
#import "MKCrashHelper.h"
#import "MKDebugTool.h"
#import "MKHttpCell.h"
#import "MKContentVC.h"

@interface MKCrashVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView  *tableView;
@property(nonatomic,strong)NSArray      *listData;
@end

@implementation MKCrashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Crash"];
    
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[MKDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    
    self.listData = [[MKCrashHelper sharedInstance] crashLogs];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"crashcell";
    MKHttpCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[MKHttpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSDictionary* dic = [self.listData objectAtIndex:indexPath.row];
    [cell setTitle:[dic objectForKey:@"date"] value:[dic objectForKey:@"type"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic = [self.listData objectAtIndex:indexPath.row];
    NSDictionary* dicinfo = [dic objectForKey:@"info"];
    NSString* name = [dicinfo objectForKey:@"name"];
    NSString* reason = [dicinfo objectForKey:@"reason"];
    NSArray* callStack = [dicinfo objectForKey:@"callStack"];
    NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"%@\n\n%@\n\n",name,reason];
    for (NSString* item in callStack) {
        [str appendString:item];
        [str appendString:@"\n\n"];
    }
    MKContentVC* vc = [[MKContentVC alloc] init];
    vc.content = @"Crash日志";
    vc.hidesBottomBarWhenPushed = YES;
    vc.content = str;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
