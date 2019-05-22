//
//  main.m
//  MKApp
//
//  Created by https://github.com/mythkiven/ on 2019/4/28.
//  Copyright © 2019 MrthKiven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//#import "MKLaunchMonitor.h"
#import "MKPointWatch.h"


int main(int argc, char * argv[]) {
    @autoreleasepool {
        [[MKPointWatch pointWatch] startWatching]; 
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
