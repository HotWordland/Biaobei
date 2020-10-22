//
//  BBSettingViewController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBSettingViewController.h"
#import "BBLoginViewController.h"
#import "BaseWebViewController.h"
#import "BBModifyViewController.h"

@interface BBSettingViewController ()
@property(nonatomic, strong) UILabel * titleLabel;
@property(nonatomic, strong) UIButton * exitButton;

@end

@implementation BBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
}

-(void)prepareUI {
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"账号设置";
    self.titleLabel.font = [UIFont systemFontOfSize:36];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.titleLabel];

    UIView * phoneView = [self getViewWithTitle:@"手机号"];
    [self.view addSubview:phoneView];
    UITapGestureRecognizer *phone_tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhone)];
    [phoneView addGestureRecognizer:phone_tapGes];
    
    UIView * protocolView = [self getViewWithTitle:@"用户协议"];
    [self.view addSubview:protocolView];
    UITapGestureRecognizer *protocol_tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapProtocol)];
    [protocolView addGestureRecognizer:protocol_tapGes];
    
    UIView * privacyView = [self getViewWithTitle:@"隐私政策"];
    [self.view addSubview:privacyView];
    UITapGestureRecognizer *privacy_tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPrivacy)];
    [privacyView addGestureRecognizer:privacy_tapGes];

    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitButton.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    self.exitButton.layer.masksToBounds = YES;
    self.exitButton.layer.cornerRadius = 27;
    self.exitButton.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.15].CGColor;
    self.exitButton.layer.shadowOffset = CGSizeMake(0,15);
    self.exitButton.layer.shadowOpacity = 1;
    self.exitButton.layer.shadowRadius = 15;
    [self.exitButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [self.exitButton setTitleColor:[UIColor colorWithRed:208/255.0 green:2/255.0 blue:27/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.exitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.exitButton];
    [self.exitButton addTarget:self action:@selector(exitButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(36);
    }];

    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(24);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(66);
    }];
    
    [protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneView.mas_bottom).offset(10);
        make.left.width.height.mas_equalTo(phoneView);
    }];
    
    [privacyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(protocolView.mas_bottom).offset(10);
        make.left.width.height.mas_equalTo(phoneView);
    }];

    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-32);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(54);
    }];
}

-(UIView *)getViewWithTitle:(NSString *)title {
    UIView *underView = [[UIView alloc] init];
    underView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    underView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    underView.layer.masksToBounds = YES;
    underView.layer.cornerRadius = 8;
    underView.layer.shadowOffset = CGSizeMake(0,0);
    underView.layer.shadowOpacity = 1;
    underView.layer.shadowRadius = 8;
    [self.view addSubview:underView];
    UILabel * titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [underView addSubview:titleLabel];
    UIImageView * directImageView =[UIImageView new];
    directImageView.image = [UIImage imageNamed:@"Mine_Right_direct"];
    [underView addSubview:directImageView];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.equalTo(underView.mas_centerY);
        make.height.mas_equalTo(16);
    }];

    [directImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
        make.centerY.equalTo(underView.mas_centerY);
    }];
    return underView;
}

-(void)exitButtonAction{
    [kAppCacheInfo clearSomeUserDefaultsData];
    
    BBLoginViewController *loginVC = [[BBLoginViewController alloc]init];
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;  //全屏
    [self presentViewController:loginVC animated:YES completion:nil];
}

//手机号点击
-(void)tapPhone {
    BBModifyViewController *modifyVC = [[BBModifyViewController alloc]init];
    [self.navigationController pushViewController:modifyVC animated:YES];
}

-(void)tapProtocol {
    BaseWebViewController *webViewVC = [[BaseWebViewController alloc]init];
    webViewVC.urlStr = UserProtocol;
    webViewVC.webTitle = @"数据工场用户协议";
    [self.navigationController pushViewController:webViewVC animated:YES];
}

-(void)tapPrivacy {
    BaseWebViewController *webViewVC = [[BaseWebViewController alloc]init];
    webViewVC.urlStr = PrivacyProtocol;
    webViewVC.webTitle = @"数据工场隐私政策";
    [self.navigationController pushViewController:webViewVC animated:YES];
}



@end
