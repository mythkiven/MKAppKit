#  MKDropdownMailTF
具有邮箱下拉提示 textField，类似新浪微博邮箱登录的效果，输入 “@” 后自动关联邮箱后缀。自动匹配输入的字符。

![](https://github.com/mythkiven/MKAppKit/blob/master/source/MKDropdownMailTF.gif)

###  使用：

    JPullEmailTF *textField = [[JPullEmailTF alloc] initWithFrame:self.holderView.frame InView:self.view];

###  使用自定义样式：
    // 自定义下拉列表的颜色，字体，frame 等信息
    textField.mailCellHeight  = 40;
    textField.mailFont        = [UIFont  systemFontOfSize:16];
    textField.MailFontColor   = [UIColor redColor];
    textField.mailCellColor   = [UIColor lightGrayColor];
    textField.mailBgColor     = [UIColor yellowColor];

    // 传入后缀数据源：
    textField.mailsuffixData  = @[@"live.com", @"126.com", @"gmail.com",@"qq.com"];
