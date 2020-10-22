//
//  AppDelegate.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTabbarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) BBTabbarViewController *currentTabbarVC;

@property (nonatomic, assign) BOOL haveNetwork;

@end

