//
//  AppDelegate.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "AppDelegate.h"
#import "BBLoginViewController.h"
#import "BBGuideViewController.h"
#import <Bugly/Bugly.h>
#import "BBNetWorkManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [Bugly startWithAppId:@"4a78a3e813"];  //启动防崩溃 测试版本:4a78a3e813 生产版本:36fe01aebc 2019.11.4 
    [[BBNetWorkManager shared] networkStateMonitorStart];  //启动网络监控

    self.window.backgroundColor = [UIColor colorWithRed:248/255.0 green:248.0/255 blue:251.0/255 alpha:1];
    [self refreshToken]; //刷新token
    
    BOOL firstOpen = kAppCacheInfo.firstOpen;
    if (!firstOpen) {  //第一次打开
        kAppCacheInfo.firstOpen = YES;
        BBGuideViewController * viewController = [[BBGuideViewController alloc]init];
        UINavigationController * navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
        self.window.rootViewController = navigationController;
        [self.window makeKeyAndVisible];
        
    } else {
        if (String_IsEmpty(kAppCacheInfo.userName)) {//token为空，未登录  userName为空，可能资料都没填
            BBLoginViewController * loginViewController = [[BBLoginViewController alloc]init];
            UINavigationController * navigationController = [[UINavigationController alloc]initWithRootViewController:loginViewController];
            self.window.rootViewController = navigationController;
            [self.window makeKeyAndVisible];
        }else{
            BBTabbarViewController * tabbarController = [[BBTabbarViewController alloc]init];
            self.window.rootViewController = tabbarController;
            [self.window makeKeyAndVisible];
            
            _currentTabbarVC = tabbarController;
        }
    }
    
    return YES;
}

-(void)refreshToken{
    NSString *refresh_token = kAppCacheInfo.refresh_token;
    if (String_IsEmpty(refresh_token)) {
        return;
    }
    
    NSDictionary *params = @{
               @"type":@"refresh_token",
               @"refreshToken":refresh_token
               };
    [[BBRequestManager sharedInstance] refreshTokenWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        NSDictionary *dataDic = responseObject[@"data"];
        NSString *token = dataDic[@"access_token"];
        NSString *refresh_token = dataDic[@"refresh_token"];
        
        kAppCacheInfo.token = token;
        kAppCacheInfo.refresh_token = refresh_token;
        
    } failure:^(NSString * _Nonnull error) {
//        kAppCacheInfo.token = @"";
//        kAppCacheInfo.refresh_token = @"";
//        [kAppCacheInfo clearSomeUserDefaultsData]; //清空存的一些数据
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"shouldLogin" object:nil];
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}


@end
