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
static const char mkNavigationOriginalDelegateKey;

@interface UINavigationController () <UINavigationControllerDelegate>

@property (readwrite,getter = isViewTransitionInProgress) BOOL viewTransitionInProgress;

@end

@implementation UINavigationController (MKCrashGuard)

+ (void)guardNavigationController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mk_swizzleInstanceMethod(self,@selector(pushViewController:animated:),@selector(guardPushViewController:animated:));
        mk_swizzleInstanceMethod(self,@selector(popViewControllerAnimated:),@selector(guardPopViewControllerAnimated:));
        mk_swizzleInstanceMethod(self,@selector(popToRootViewControllerAnimated:),@selector(guardPopToRootViewControllerAnimated:));
        mk_swizzleInstanceMethod(self,@selector(popToViewController:animated:),@selector(guardPopToViewController:animated:));
    });
}

- (void)setViewTransitionInProgress:(BOOL)property {
    NSNumber *number = [NSNumber numberWithBool:property];
    objc_setAssociatedObject(self, &mkNavigationControllerAssociatedKey, number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isViewTransitionInProgress {
    NSNumber *number = objc_getAssociatedObject(self, &mkNavigationControllerAssociatedKey);
    return [number boolValue];
}

#pragma mark - Delegate forwarding

- (id<UINavigationControllerDelegate>)mk_originalNavigationDelegate {
    return objc_getAssociatedObject(self, &mkNavigationOriginalDelegateKey);
}

- (void)mk_installGuardDelegateIfNeeded {
    id<UINavigationControllerDelegate> delegate = self.delegate;
    if (delegate && delegate != (id)self) {
        objc_setAssociatedObject(self, &mkNavigationOriginalDelegateKey, delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UINavigationControllerDelegate>)self;
    }
}

- (void)mk_scheduleTransitionResetForViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!animated) {
        self.viewTransitionInProgress = NO;
        return;
    }
    id<UIViewControllerTransitionCoordinator> coordinator = viewController.transitionCoordinator;
    if (!coordinator) {
        self.viewTransitionInProgress = NO;
        return;
    }
    __weak typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (!context.isCancelled) {
            weakSelf.viewTransitionInProgress = NO;
        }
    }];
}

#pragma mark - Intercept Pop, Push, PopToRootVC

- (NSArray *)guardPopToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewTransitionInProgress) return nil;
    [self mk_installGuardDelegateIfNeeded];
    NSArray *viewControllers = [self guardPopToRootViewControllerAnimated:animated];
    if (animated && viewControllers.count > 0) {
        self.viewTransitionInProgress = YES;
    }
    return viewControllers;
}

- (NSArray *)guardPopToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewTransitionInProgress) return nil;
    [self mk_installGuardDelegateIfNeeded];
    NSArray *viewControllers = [self guardPopToViewController:viewController animated:animated];
    if (animated && viewControllers.count > 0) {
        self.viewTransitionInProgress = YES;
    }
    return viewControllers;
}

- (UIViewController *)guardPopViewControllerAnimated:(BOOL)animated {
    if (self.viewTransitionInProgress) return nil;
    [self mk_installGuardDelegateIfNeeded];
    UIViewController *viewController = [self guardPopViewControllerAnimated:animated];
    if (animated && viewController) {
        self.viewTransitionInProgress = YES;
    }
    return viewController;
}

- (void)guardPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewTransitionInProgress) return;
    [self mk_installGuardDelegateIfNeeded];
    [self guardPushViewController:viewController animated:animated];
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UINavigationControllerDelegate> originalDelegate = [self mk_originalNavigationDelegate];
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [originalDelegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
    [self mk_scheduleTransitionResetForViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UINavigationControllerDelegate> originalDelegate = [self mk_originalNavigationDelegate];
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [originalDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
    self.viewTransitionInProgress = NO;
    if (navigationController.interactivePopGestureRecognizer) {
        navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)viewController;
        [navigationController.interactivePopGestureRecognizer setEnabled:navigationController.viewControllers.count > 1];
    }
}

@end
