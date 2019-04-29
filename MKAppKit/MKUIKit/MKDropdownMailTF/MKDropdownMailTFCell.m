//
//
//  Created by https://github.com/mythkiven/ on 15/11/12.
//  Copyright © 2015年 3code. All rights reserved.
//
#import "MKDropdownMailTFCell.h"

@implementation MKDropdownMailTFCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.leftEdge, 0, self.frame.size.width-self.leftEdge, self.frame.size.height)];
    self.emailLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.emailLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
