//
//  BaseViewController.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/25.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

-(void)resgisterEnditing;
-(void)setNavigationbackbar;
-(void)backButtonClick;

//获取当前根视图控制器
+ (BaseViewController*)topViewController;

//展示提示框
- (void)showMessage:(NSString *)message;

- (void)showMessage:(NSString *)message block:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
