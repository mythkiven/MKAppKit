/**
 *
 * Created by https://github.com/mythkiven/ on 19/07/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "MKDebugTool.h"
#import "MKHttpProtocol.h"
#import "MKDebugVC.h"
#import "MKCrashVC.h"
#import "MKHttpVC.h"
#import "MKLogVC.h"
#import "MKCrashHelper.h"
#import "MKMemoryHelper.h"

#define KB	(1024)
#define MB	(KB * 1024)
#define GB	(MB * 1024)

@interface MKDebugWindow : UIWindow

@end

@implementation MKDebugWindow

- (void)becomeKeyWindow {
    //uisheetview
    [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
}

@end

@interface MKDebugTool()
@property (nonatomic, strong) MKDebugVC        *debugVC;
@property (nonatomic, strong) MKDebugWindow    *debugWin;
@property (nonatomic, strong) UIButton          *debugBtn;
@property (nonatomic, strong) NSTimer           *debugTimer;
@end

@implementation MKDebugTool

+ (instancetype)shareInstance {
    static MKDebugTool* tool;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        tool = [[MKDebugTool alloc] init];
    });
    return tool;
}

- (id)init {
    self = [super init];
    if (self) {
        self.mainColor = [UIColor redColor];
        self.debugWin = [[MKDebugWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    }
    return self;
}

- (void)enableDebugMode {
    [NSURLProtocol registerClass:[MKHttpProtocol class]];
    [[MKCrashHelper sharedInstance] install];
    __weak typeof (self) wSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf showOnStatusBar];
    });
}

- (void)showOnStatusBar {
    self.debugWin.windowLevel = UIWindowLevelAlert+1;
    self.debugWin.hidden = NO;
    self.debugWin.alpha = 1.0;
    
    self.debugBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 91, 15)];
    self.debugBtn.backgroundColor = self.mainColor;
    self.debugBtn.layer.cornerRadius = 3;
    self.debugBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.debugBtn setTitle:@"Debug Starting" forState:UIControlStateNormal];
    [self.debugBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.debugBtn addTarget:self action:@selector(showDebug) forControlEvents:UIControlEventTouchUpInside];
    [self.debugWin addSubview:self.debugBtn];
    
    self.debugTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMonitor) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.debugTimer forMode:NSDefaultRunLoopMode];
}

- (void)showDebug {
    if (!self.debugVC) {
        self.debugVC = [[MKDebugVC alloc] init];

        UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:[MKHttpVC new]];
        UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:[MKCrashVC new]];
        UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:[MKLogVC new]];
        
        [nav1.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:self.mainColor}];
        [nav2.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:self.mainColor}];
        [nav3.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:self.mainColor}];
        
        nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Http" image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateNormal];
        [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:self.mainColor,NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateSelected];
        
        
        nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Crash" image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateNormal];
        [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:self.mainColor,NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateSelected];
        
        nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Log" image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateNormal];
        [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:self.mainColor,NSFontAttributeName:[UIFont systemFontOfSize:30]} forState:UIControlStateSelected];

        self.debugVC.viewControllers = @[nav1,nav2,nav3];
        UIViewController* vc = [[[UIApplication sharedApplication].delegate window] rootViewController];
        UIViewController* vc2 = vc.presentedViewController;
        [vc2?:vc presentViewController:self.debugVC animated:YES completion:nil];
    }
    else {
        [self.debugVC dismissViewControllerAnimated:YES completion:nil];
        self.debugVC = nil;
    }
}

- (void)timerMonitor {
    unsigned long long used = [MKMemoryHelper bytesOfUsedMemory];
    NSString* text = [self number2String:used];
    [self.debugBtn setTitle:[NSString stringWithFormat:@"Debug(%@)",text] forState:UIControlStateNormal];
}

- (NSString* )number2String:(int64_t)n {
    if(n<KB){
        return [NSString stringWithFormat:@"%lldB", n];
    }else if(n<MB){
        return [NSString stringWithFormat:@"%.1fK", (float)n / (float)KB];
    }else if(n<GB){
        return [NSString stringWithFormat:@"%.1fM", (float)n / (float)MB];
    }else{
        return [NSString stringWithFormat:@"%.1fG", (float)n / (float)GB];
    }
}
@end
