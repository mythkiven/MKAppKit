/**
 *
 * Created by https://github.com/mythkiven/ on 19/07/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "MKHttpDetailVC.h"
#import "MKHttpCell.h"
#import "MKContentVC.h"
#import "MKResponseVC.h"
#import "MKDebugTool.h"

#define detailTitles   @[@"Request Url",@"Method",@"Status Code",@"Mime Type",@"Start Time",@"Total Duration",@"Request Body",@"Response Body"]

@interface MKHttpDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView  *tableView;
@property(nonatomic,strong)NSArray      *listData;
@end

@implementation MKHttpDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclose setTitle:@"Back" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[MKDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
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
    static NSString *identifer = @"httpdetailcell";
    MKHttpCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[MKHttpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSString* value = @"";
    if (indexPath.row == 0) {
        value = self.detail.url.absoluteString;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1) {
        value = self.detail.method;
    }else if (indexPath.row == 2) {
        value = self.detail.statusCode;
    }else if (indexPath.row == 3) {
        value = self.detail.mineType;
    }else if (indexPath.row == 4) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        value = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.detail.startTime.doubleValue]];
    }else if (indexPath.row == 5) {
        value = self.detail.totalDuration;
    }else if (indexPath.row == 6) {
        if (self.detail.requestBody.length > 0) {
            value = @"Tap to view";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            value = @"Empty";
        }
    }else if (indexPath.row == 7) {
        NSInteger lenght = self.detail.responseData.length;
        if (lenght > 0) {
            if (lenght < 1024) {
                value = [NSString stringWithFormat:@"(%zdB) Tap to view",lenght];
            }else {
                value = [NSString stringWithFormat:@"(%.2fKB) Tap to view",1.0 * lenght / 1024];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            value = @"Empty";
        }
    }
    [cell setTitle:[detailTitles objectAtIndex:indexPath.row] value:value];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MKContentVC* vc = [[MKContentVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.content = self.detail.url.absoluteString;
        vc.title = @"接口地址";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 6 && self.detail.requestBody.length > 0) {
        MKContentVC* vc = [[MKContentVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.content = self.detail.requestBody;
        vc.title = @"请求数据";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 7 && self.detail.responseData.length > 0) {
        MKResponseVC* vc = [[MKResponseVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.data = self.detail.responseData;
        vc.isImage = self.detail.isImage;
        vc.title = @"返回数据";
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        return;
    }
}

@end
