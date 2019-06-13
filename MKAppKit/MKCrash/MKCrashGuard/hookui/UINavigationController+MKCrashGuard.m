/**
 *
 * Created by https://github.com/mythkiven/ on 19/06/11.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "UINavigationController+MKCrashGuard.h"
#import "MKException.h"
#import "NSObject+MKSwizzleHook.h"
#import <objc/runtime.h>


static const char mkNavigationControllerAssociatedKey;

@interface UINavigationController () <UINavigationControllerDelegate>

@property (readwrite,getter = isViewTransitionInProgress) BOOL viewTransitionInProgress;

@end

@implementation UINavigationController (MKCrashGuard)

+ (void)guardNavigationController {
    mk_swizzleInstanceMethod(self,@selector(pushViewController:animated:),@selector(guardPushViewController:animated:));
    mk_swizzleInstanceMethod(self,@selector(popViewControllerAnimated:),@selector(guardPopViewControllerAnimated:));
    mk_swizzleInstanceMethod(self,@selector(popToRootViewControllerAnimated:),@selector(guardPopToRootViewControllerAnimated:));
    mk_swizzleInstanceMethod(self,@selector(popToViewController:animated:),@selector(guardPopToViewController:animated:));
    
}

- (void)setViewTransitionInProgress:(BOOL)property {
    NSNumber *number = [NSNumber numberWithBool:property];
    objc_setAssociatedObject(self, &mkNavigationControllerAssociatedKey, number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isViewTransitionInProgress {
    NSNumber *number = objc_getAssociatedObject(self, &mkNavigationControllerAssociatedKey);
    return [number boolValue];
}

#pragma mark - Intercept Pop, Push, PopToRootVC
- (NSArray *)guardPopToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewTransitionInProgress) return nil;
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
    return [self guardPopToRootViewControllerAnimated:animated];
}

- (NSArray *)guardPopToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewTransitionInProgress) return nil;
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
    return [self guardPopToViewController:viewController animated:animated];
}

- (UIViewController *)guardPopViewControllerAnimated:(BOOL)animated {
    if (self.viewTransitionInProgress) return nil;
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
    return [self guardPopViewControllerAnimated:animated];
}

- (void)guardPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.delegate = self;
    if (self.isViewTransitionInProgress == NO) {
        [self guardPushViewController:viewController animated:animated];
        if (animated) {
            self.viewTransitionInProgress = YES;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.viewTransitionInProgress = NO;
        self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)viewController;
        [self.interactivePopGestureRecognizer setEnabled:YES];
    }];
    if (navigationController.delegate != self) {
        [navigationController.delegate navigationController:navigationController
                                     willShowViewController:viewController
                                                   animated:animated];
    }
}



@end
