//
//  JPushTableCell.m
//  JCombineLoadingAnimation
//
//  Created by https://github.com/mythkiven/ on 15/01/17.
//  Copyright © 2015年 mythkiven. All rights reserved.
//

#import "JPushTableCell.h"
@interface JPushTableCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
@implementation JPushTableCell

- (void)awakeFromNib {
    [super awakeFromNib]; 
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"JPushTableCell" owner:nil options:nil];
        self = [nibArray lastObject];
        
    }
    return self;
}

-(void)setIndex:(NSInteger)index{
    if (index ==99999) {
        self.title.hidden=YES;
        self.btn.hidden =YES;
    }else{
        self.title.hidden=NO;
        self.btn.hidden =NO;
        self.title.text = [NSString stringWithFormat:@"成功加载数据，这是第%ld阶段",index];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
