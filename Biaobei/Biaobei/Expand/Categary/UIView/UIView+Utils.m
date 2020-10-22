//
//  UIView+Utils.m
//  ZhanLuReader
//
//  Created by zlwh on 2019/5/22.
//  Copyright © 2019 ZLYD. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)


-(UIViewController *)getCurrentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
        
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

//获取当前View所在VC
- (UIViewController *)getCurrentViewInController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


@end
