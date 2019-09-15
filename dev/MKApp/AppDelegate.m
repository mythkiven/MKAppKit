//
//  AppDelegate.m
//  MKApp
//
//  Created by https://github.com/mythkiven/ on 2019/4/28.
//  Copyright © 2019 MythKiven. All rights reserved.
//



#import "AppDelegate.h"
#import "ViewController.h"
#import "MKPointWatch.h"
#import "NSObject+MKTTimeLoad.h" 
#import "MKDevice.h"
#import "MKMacro.h"
#import "MKDebug.h"

#import "MKMacro.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // debug
    [MKDebug debugRegister];
    // 打点
    [[MKPointWatch pointWatch] pointWithDescription:@"didFinishLaunchingWithOptions"];
    
    return [self makeWindows];
}

- (BOOL)makeWindows { 
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *homeVc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application { 
    [[MKPointWatch pointWatch] pointWithDescription:@"applicationDidBecomeActive"];
    NSLog(@"des:%@ %@ %lf",[MKPointWatch pointWatch].printedPoints,[MKPointWatch pointWatch].points,[MKPointWatch pointWatch].lastWatchInterval);
    [[MKPointWatch pointWatch] stopWatchingAndAlertResult];
    [MKDebug enableDebug];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
