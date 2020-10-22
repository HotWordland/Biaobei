//
//  BaseViewController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/25.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"--->>>>> %@ <<<<<---", self.class);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248.0/255 blue:251.0/255 alpha:1];
    self.navigationController.navigationBar.translucent = false;
    [self resignFirstResponder];
    [self setNavigationbackbar];
    
    if (@available(iOS 11.0, *)) {   //解决滑动视图自动下移20 //避免滚动视图顶部出现20的空白以及push或者pop的时候页面有一个上移或者下移的异常动画的问题
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)setNavigationbackbar {
    if (self.navigationController.navigationBar.subviews.count > 0) {
        self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    }
    [self.navigationController.navigationBar setBarTintColor:rgba(248, 248, 251, 1)];
    UIButton * backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 84, 24);
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 10, 17)];
    imageview.image = [UIImage imageNamed:@"Navigation_Back"];
    [backButton addSubview:imageview];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 12, 40, 17)];
    titleLabel.font = UIFONT(17);
    titleLabel.text = @"返回";
    titleLabel.textColor = rgba(37, 194, 155, 1);
    [backButton addSubview:titleLabel];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

-(void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)resgisterEnditing {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

-(void)hideKeyBoard {
    [self.view endEditing:YES];
}

//右滑返回
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //防止navigationController主页右滑 卡住不动
    if (self.navigationController.viewControllers.count == 1) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --获取当前跟视图
+ (BaseViewController*)topViewController {
    return (BaseViewController *)[self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        if ([presentedViewController isKindOfClass:[UIAlertController class]]) {
            UIWindow *window =  [UIApplication sharedApplication].delegate.window;
            UIViewController *vc = window.rootViewController;
            return [self topViewControllerWithRootViewController:vc];
        }
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (void)showMessage:(NSString *)message {
    [PromptAlertView alertWithMessage:message];
}

- (void)showMessage:(NSString *)message block:(void (^)(void))block{
    [PromptAlertView alertWithMessage:message successBlock:block];
}

- (void)setTaskStyle:(UIView *)view text:(NSString *)text hidden:(BOOL)hidden {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)v;
            label.text = text;
            break;
        }
    }
    view.hidden = hidden;
}

- (void)setTaskStyle:(UIView *)view hidden:(BOOL)hidden {
    
}


- (void)initTaskStyle:(UIView *)view {
    //无任务后
    UIView *taskView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-150)/2, (SCREENHEIGHT-110)/2-50, 150, 110)];
    taskView.backgroundColor = [UIColor clearColor];
    taskView.hidden = YES;
    [view addSubview:taskView];
    
    UIImageView *noImgView = [[UIImageView alloc]initWithFrame:CGRectMake((150-47)/2, 2, 47, 52)];
    noImgView.image = [UIImage imageNamed:@"Combined Shape"];
    [taskView addSubview:noImgView];
    
    UILabel *noLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, noImgView.bottom+10, 150, 20)];
    noLabel.textColor = [UIColor colorWithHex:@"#8890A9"];
    noLabel.font = kFontRegularSize(14);
    //    noLabel.text = @"暂无任务\n你可以“回到首页”领取";
    noLabel.text = @"";
    noLabel.numberOfLines = 0;
    [noLabel sizeToFit];
    noLabel.textAlignment = NSTextAlignmentCenter;
    [taskView addSubview:noLabel];
}


@end
