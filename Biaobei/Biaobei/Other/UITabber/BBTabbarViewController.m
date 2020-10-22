//
//  BBTabbarViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBTabbarViewController.h"
#import "BBMineViewController.h"
#import "BBHomeViewController.h"
#import "BBLoginViewController.h"

@interface BBTabbarViewController ()

@end

@implementation BBTabbarViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareController];
    self.tabBar.translucent = false;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldLogin) name:@"shouldLogin" object:nil];
}

//token失效需要重新登录
-(void)shouldLogin{
//    [SVProgressHUD showWithStatus:@"登录失效,请重新登录"];
//    [SVProgressHUD dismissWithDelay:2.0];
    [PromptAlertView alertWithMessage:@"登录失效,请重新登录" successBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            BBLoginViewController * loginViewController = [[BBLoginViewController alloc]init];
            loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:loginViewController animated:YES completion:nil];
        });
    }];
    
}

-(void)prepareController {
    BBMineViewController * mineController =[[BBMineViewController alloc]init];
    UINavigationController * mineNavi = [[UINavigationController alloc]initWithRootViewController:mineController];
    mineNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[self getImage:@"mine"] selectedImage:[self getImage:@"mine_ico"]];
    
    BBHomeViewController * homeController = [[BBHomeViewController alloc]init];
    UINavigationController * homeNavi = [[UINavigationController alloc]initWithRootViewController:homeController];
    
    homeNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[self getImage:@"home_icon_normal"] selectedImage:[self getImage:@"home_icon_selected"]];
    self.viewControllers = @[homeNavi,mineNavi];
    
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:GreenColor forKey:NSForegroundColorAttributeName];
    [mineNavi.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
    [homeNavi.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
}

-(UIImage *)getImage:(NSString *)imageName {
    UIImage * image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
