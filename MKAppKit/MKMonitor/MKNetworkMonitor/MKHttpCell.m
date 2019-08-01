/**
 *
 * Created by https://github.com/mythkiven/ on 19/07/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */

#import "MKHttpCell.h"
#import "MKDebugTool.h"

@interface MKHttpCell()
{
    UILabel *lblTitle;
    UILabel *lblValue;
}
@end

@implementation MKHttpCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width - 40, 20)];
        lblTitle.textColor = [MKDebugTool shareInstance].mainColor;
        lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
        [self addSubview:lblTitle];
        
        lblValue = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, [UIScreen mainScreen].bounds.size.width - 40, 16)];
        lblValue.textColor = [UIColor lightGrayColor];
        lblValue.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblValue];
    }
    return self;
}

- (void)setTitle:(NSString*)title value:(NSString*)value {
    lblTitle.text = title;
    lblValue.text = value;
}

@end
