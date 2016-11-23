//
//  JPushTableCellView.m
//  JCombineLoadingAnimation
//
//  Created by https://github.com/mythkiven/ on 15/01/17.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import "JPushTableCell.h"
#import "JPushTableCellView.h"
@interface JPushTableCellView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JPushTableCellView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self initDefaultWithFrame:frame];
    }
    return self;
}

-(void)initDefaultWithFrame:(CGRect)frame{
    
    self.tableCellView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.tableCellView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableCellView.showsVerticalScrollIndicator = NO;
    self.tableCellView.showsHorizontalScrollIndicator =NO;
    self.tableCellView.rowHeight =30;
    self.tableCellView.backgroundColor =[UIColor lightGrayColor];
    [self.tableCellView registerNib:[UINib nibWithNibName:@"JPushTableCell" bundle:nil] forCellReuseIdentifier:@"JPushTableCell"];
    
    self.tableCellView.delegate =self;
    self.tableCellView.dataSource =self;
    self.userInteractionEnabled =NO;
    [self addSubview:self.tableCellView];
    
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    [self.tableCellView reloadData];
    [self.tableCellView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JPushTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPushTableCell" forIndexPath:indexPath];
    if ([_data[indexPath.row] isEqualToString:@"NULL"]) {
        cell.index = 99999;
    }else{
        cell.index = [_data[indexPath.row] integerValue] ;
    }
    
    
    return cell;
}



@end
