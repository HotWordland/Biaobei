//
//  UIView+Utils.h
//  ZhanLuReader
//
//  Created by zlwh on 2019/5/22.
//  Copyright © 2019 ZLYD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Utils)

/* 获取当前屏幕显示的ViewController */
- (UIViewController *)getCurrentViewController;
/* 获取当前view所在的ViewController */
- (UIViewController *)getCurrentViewInController;


@end

NS_ASSUME_NONNULL_END
