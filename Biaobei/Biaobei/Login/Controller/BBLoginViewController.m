//
//  BBLoginViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBLoginViewController.h"
#import "BBMineDetailViewController.h"
#import "BBTabbarViewController.h"
#import "BaseWebViewController.h"
#import "AppDelegate.h"
#import "UserProtocolAndPrivacyToast.h"
#import "BBAggreProtocolViewController.h"
#import "UILabel+LCLabelCategory.h"

@implementation BBLoginModel
@end

@interface BBLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel * titlLabel;
@property (nonatomic, strong) UIView * undeView;
@property (nonatomic, strong) UILabel * photoHeaderLabel;
@property (nonatomic, strong) UIImageView * directionImageView;
@property (nonatomic, strong) UITextField * phoneTextField;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UITextField * checkCodeTextField;
@property (nonatomic, strong) UIButton * codeButton;
@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, strong) UserProtocolAndPrivacyToast *toast;
@property (nonatomic, assign) BOOL agree;


@end

@implementation BBLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;

    if (_toast && _toast.hidden) {
        _toast.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    [self layoutUI];
    [self resgisterEnditing];
    
    self.agree = [[NSUserDefaults standardUserDefaults] boolForKey:@"agreeProtocol"];
    if (!self.agree) {
        _phoneTextField.enabled = NO;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showToast];
    });

}

//隐私与协议
- (void)showToast {
    if (!self.agree) {
        _toast = [[UserProtocolAndPrivacyToast alloc] init];
        kWeak_self
        _toast.agreeBlock = ^(BOOL agree) {
            if (agree) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"agreeProtocol"];  //同意后不再弹出提示
                weakSelf.toast = nil;  //销毁
                weakSelf.phoneTextField.enabled = YES;
            } else {
                [SVProgressHUD showInfoWithStatus:@"需要获得您的同意后才能继续使用我们提供的产品和服务"];
                [SVProgressHUD dismissWithDelay:2.0];
            }
        };
        _toast.procolBlock = ^(NSInteger index){
            weakSelf.toast.hidden = YES;
            [weakSelf readProtocol:index];
        };
    }
}

- (void)readProtocol:(NSInteger)index {
    __block NSString *webTitle = @"";
    __block NSString *protocol = @"";
    if (index == 1) {
        webTitle = @"数据工场用户协议";
        protocol = UserProtocol;
    } else if (index == 2) {
        webTitle = @"数据工场隐私政策";
        protocol = PrivacyProtocol;
    }
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.urlStr = protocol;
    webVC.webTitle = webTitle;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)prepareUI {
    self.titlLabel = [UILabel new];
    self.titlLabel.text = @"登录";
    self.titlLabel.font = kFontRegularSize(36);
    [self.view addSubview:self.titlLabel];

    self.undeView = [UIView new];
    self.undeView.backgroundColor = [UIColor whiteColor];
    self.undeView.layer.masksToBounds = YES;
    self.undeView.layer.cornerRadius = 8;
    [self.view addSubview:self.undeView];

    self.photoHeaderLabel = [UILabel new];
    self.photoHeaderLabel.text = @"+86";
    self.photoHeaderLabel.font = kFontRegularSize(17);
    [self.undeView addSubview:self.photoHeaderLabel];

    self.directionImageView = [UIImageView new];
    self.directionImageView.image = [UIImage imageNamed:@"Mine_Right_direct"];
    [self.undeView addSubview:self.directionImageView];

    self.phoneTextField = [UITextField new];
    self.phoneTextField.placeholder = @"请输入手机号";
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.font = kFontRegularSize(16);
    self.phoneTextField.delegate = self;
    [self.phoneTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.undeView addSubview:self.phoneTextField];

    self.lineView = [UIView new];
    self.lineView.backgroundColor = rgba(148, 153, 161, 1);
    self.lineView.alpha = 0.15;
    [self.undeView addSubview:self.lineView];

    self.checkCodeTextField = [UITextField new];
    self.checkCodeTextField.placeholder = @"验证码";
    self.checkCodeTextField.delegate = self;
    self.checkCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.checkCodeTextField.font = kFontRegularSize(16);
    [self.undeView addSubview:self.checkCodeTextField];

    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeButton setTitleColor:rgba(148, 153, 161, 1) forState:UIControlStateNormal];
//    [self.codeButton setTitleColor:rgba(37, 194, 155, 1) forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton.titleLabel.font = kFontRegularSize(16);
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.undeView addSubview:self.codeButton];

    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = rgba(153, 153, 153, 1);
    self.loginButton.userInteractionEnabled = NO;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 27;
    [self.loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    //文案
    UIView *greenDot = [[UIView alloc]initWithFrame:CGRectMake(24, SCREENHEIGHT-155, 6, 6)];
    greenDot.backgroundColor = GreenColor;
    greenDot.layer.cornerRadius = 3;
    [self.view addSubview:greenDot];
    
    UILabel *reLabel = [UIFactory createLab:CGRectMake(greenDot.right+8, greenDot.top-7, SCREENWIDTH-100, 20) text:@"新用户登录时将自动注册," textColor:BlackColor textFont:kFontRegularSize(14) textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:reLabel];
    
    NSString *string1 = @"《数据工场用户协议》";
    NSString *string2 = @"《数据工场隐私政策》";
    NSString *text = @"且代表你已同意《数据工场用户协议》和《数据工场隐私政策》";
    UILabel *agreeLabel = [UIFactory createLab:CGRectMake(reLabel.left, reLabel.bottom+1, reLabel.width, 40)
                                          text:text
                                     textColor:BlackColor
                                      textFont:kFontRegularSize(14)
                                 textAlignment:NSTextAlignmentLeft];
    agreeLabel.numberOfLines = 2;
    agreeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:agreeLabel];
    
    NSAttributedString *attrText = [self setAttributeString:text
                                                    string1:string1
                                                    string2:string2
                                                       font:kFontRegularSize(14)
                                                      color:rgba(37, 194, 155, 1)];
    agreeLabel.attributedText = attrText;
    
    NSRange range1 = [text rangeOfString:string1 options:NSBackwardsSearch];
    NSRange range2 = [text rangeOfString:string2 options:NSBackwardsSearch];
    kWeak_self
    [agreeLabel setLc_tapBlock:^(NSInteger index, NSAttributedString *charAttributedString) {
        NSInteger __index = 0;
        if (index >= range1.location && index <= range1.location + range1.length) {
            __index = 1;  //《数据工场用户协议》
            
        } else if (index >= range2.location && index <= range2.location + range2.length) {
            __index = 2;  //数据工场隐私政策
        } else {
            return;
        }
        
        [weakSelf readProtocol:__index];
    }];
}

-(void)layoutUI {
    [self.titlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(60);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(36);
    }];
    
    [self.undeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(132);
        make.top.equalTo(self.titlLabel.mas_bottom).offset(24);
    }];
    
    [self.photoHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(24);
        make.height.mas_equalTo(18);
        make.width.mas_lessThanOrEqualTo(38);
    }];
    
    [self.directionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoHeaderLabel.mas_right).offset(8);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(6);
        make.centerY.equalTo(self.photoHeaderLabel.mas_centerY);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.directionImageView.mas_right).offset(27);
        make.centerY.equalTo(self.photoHeaderLabel.mas_centerY);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(22);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(21);
        make.left.equalTo(self.phoneTextField.mas_left);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
    
    [self.checkCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(21);
        make.left.equalTo(self.phoneTextField.mas_left);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(80);
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(26);
        make.centerY.equalTo(self.checkCodeTextField.mas_centerY);
        make.width.mas_equalTo(91);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-32);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(54);
    }];
}


- (NSMutableAttributedString *)setAttributeString:(NSString *)string string1:(NSString *)string1 string2:(NSString *)string2 font:(UIFont *)font color:(UIColor *)color {
    NSRange range1 = [string rangeOfString:string1 options:NSBackwardsSearch];
    NSRange range2 = [string rangeOfString:string2 options:NSBackwardsSearch];
    NSMutableAttributedString * aStr1 = [[NSMutableAttributedString alloc] initWithString:string];
    
    [aStr1 setAttributes:@{ NSForegroundColorAttributeName:color, NSFontAttributeName:font } range:range1];
    [aStr1 setAttributes:@{ NSForegroundColorAttributeName:color, NSFontAttributeName:font } range:range2];
    return aStr1;
}

-(void)loginButtonClick {
    if (_checkCodeTextField.text.length == 0) {
        [self showMessage:@"请填写验证码"];
        return;
    } else if (_checkCodeTextField.text.length != 6) {
        [self showMessage:@"请检查验证码是否正确"];
        return;
    }
    NSDictionary *params = @{
                              @"mobile":_phoneTextField.text,
                              @"smsCode":_checkCodeTextField.text
                            };
    
    [[BBRequestManager sharedInstance] mobileLoginWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        BBLoginModel *loginModel = (BBLoginModel *)model;
        kAppCacheInfo.token = loginModel.access_token;
        kAppCacheInfo.userId = loginModel.userId;
        kAppCacheInfo.refresh_token = loginModel.refresh_token;
        kAppCacheInfo.phoneNum = self.phoneTextField.text;
        
        [self getUserInfo];
        
    } failure:^(NSString * _Nonnull error) {
        [self showMessage:error];
        [self showMessage:@"请检查验证码是否正确"];
    }];
    
}

-(void)getUserInfo{
    [[BBRequestManager sharedInstance] getMyInfoWithSuccess:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        BBUserInfoModel *userInfoModel = (BBUserInfoModel *)model;
        NSString *is_new = userInfoModel.is_new;
        if ([is_new isEqualToString:@"0"]) {
            //老用户
            kAppCacheInfo.userName = userInfoModel.realName;
//            kAppCacheInfo.headImage = userInfoModel.icon;  //icon返回为空
            
//            if ([userInfoModel.sex isEqualToString:@"0"]) {
//                kAppCacheInfo.headImage = @"ProfilePhoto_Female";
//
//            } else {
//                kAppCacheInfo.headImage = @"ProfilePhoto_Male";
//            }
            //---------------------------------------
            kAppCacheInfo.headImage = @"ProfilePhoto_Male";  //临时需求
            //---------------------------------------
            
            kAppCacheInfo.teamStatus = userInfoModel.teamStatus;
            kAppCacheInfo.teamId = userInfoModel.teamId;
            kAppCacheInfo.age = userInfoModel.age;
            kAppCacheInfo.sex = userInfoModel.sex;
            
            NSString *nativePlace = [[NSString alloc] initWithFormat:@"%@ %@ %@",
                                                          userInfoModel.province,
                                                              userInfoModel.city,
                                                             userInfoModel.town];
            kAppCacheInfo.nativePlace = nativePlace;  //籍贯

//            kAppCacheInfo.nativePlace = userInfoModel.province;
            
            BBTabbarViewController * tabbarController = [[BBTabbarViewController alloc]init];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.currentTabbarVC = tabbarController;
            tabbarController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:tabbarController animated:YES completion:nil];
            
       
            
        } else {
            BBMineDetailViewController * mineDetailController = [[BBMineDetailViewController alloc]init];
            mineDetailController.userInfoModel = userInfoModel;
            [mineDetailController isRegist];
            mineDetailController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:mineDetailController animated:YES completion:nil];
        }
        
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];
    
    
}


#pragma mark - 事件

-(void)getCode:(UIButton *)btn {
    
    NSDictionary * dic = @{@"mobile": self.phoneTextField.text};
    [[BBNetWorkManager shared] form_postWithUrl:@"/code/sms" withParameters:dic suceess:^(NSDictionary * _Nonnull information) {
        NSLog(@"%@",information);
    } failure:^(NSString * _Nonnull error) {

    }];
    
    __block int timeout=60;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitle:@"重新获取" forState:UIControlStateNormal];
                [btn setTitleColor:GreenColor forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [btn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                [btn setTitleColor:rgba(148, 153, 161, 1) forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    
}

-(void)checkNextButton {
    if (self.phoneTextField.text.length == 11 && [[self.phoneTextField.text substringToIndex:1] isEqualToString:@"1"]) {
        self.loginButton.backgroundColor = rgba(37, 194, 155, 1);
        self.loginButton.userInteractionEnabled = YES;
    } else {
        //请输入正确手机号
        self.loginButton.userInteractionEnabled = false;
        self.loginButton.backgroundColor = rgba(153, 153, 153, 1);
        self.loginButton.userInteractionEnabled = NO;
    }
}

-(void)textChange:(UITextField *)textField{
    if ([self.phoneTextField isEqual:textField]) {
        if (self.phoneTextField.text.length == 11 && [[self.phoneTextField.text substringToIndex:1] isEqualToString:@"1"]) {
            self.codeButton.userInteractionEnabled = YES;
            [self.codeButton setTitleColor:rgba(37, 194, 155, 1) forState:UIControlStateNormal];
//            self.codeButton.highlighted = YES;
        } else {
            self.codeButton.userInteractionEnabled = NO;
            [self.codeButton setTitleColor:rgba(148, 153, 161, 1) forState:UIControlStateNormal];
//            self.codeButton.highlighted = NO;
        }
        [self checkNextButton];
    } else if ([self.checkCodeTextField isEqual:textField]) {
        [self checkNextButton];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.phoneTextField isEqual:textField]) {
        if (self.phoneTextField.text.length == 11) {
            self.codeButton.userInteractionEnabled = YES;
            self.codeButton.highlighted = YES;
        } else {
            self.codeButton.userInteractionEnabled = NO;
            self.codeButton.highlighted = NO;
        }
        [self checkNextButton];
    } else if ([self.checkCodeTextField isEqual:textField]) {
        [self checkNextButton];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                                                       replacementString:(NSString *)string {
    //敲删除键
    if ([string length] == 0) {
        return YES;
    }
    if (textField == _phoneTextField) {
        if ([textField.text length] > 11)
            return NO;
        NSMutableString *fieldText = [NSMutableString stringWithString:textField.text];
        [fieldText replaceCharactersInRange:range withString:string];
        NSString *finalText = [fieldText copy];
        if ([finalText length] > 11) {
            textField.text = [finalText substringToIndex:11];
            return NO;
        }
        return YES;
    } else {
        if ([textField.text length] > 6)
            return NO;
        NSMutableString *fieldText = [NSMutableString stringWithString:textField.text];
        [fieldText replaceCharactersInRange:range withString:string];
        NSString *finalText = [fieldText copy];
        if ([finalText length] > 6) {
            textField.text = [finalText substringToIndex:6];
            return NO;
        }
        return YES;
    }
    return NO;
}

@end
