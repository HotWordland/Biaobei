//
//  BBModifyViewController.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/10/15.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBModifyViewController.h"
#import "BBLoginViewController.h"

@interface BBModifyViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * titlLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *cPhoneLabel;
@property (nonatomic, strong) UIView * undeView;
@property (nonatomic, strong) UILabel * photoHeaderLabel;
@property (nonatomic, strong) UIImageView * directionImageView;
@property (nonatomic, strong) UITextField * phoneTextField;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UITextField * checkCodeTextField;
@property (nonatomic, strong) UIButton * codeButton;
@property (nonatomic, strong) UIButton * loginButton;

@end

@implementation BBModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    [self layoutUI];
    [self resgisterEnditing];
}

-(void)prepareUI {
    self.titlLabel = [UILabel new];
    self.titlLabel.text = @"修改手机号";
    self.titlLabel.font = kFontRegularSize(36);
    [self.view addSubview:self.titlLabel];
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.text = @"修改手机号后，下次可使用新手机号登录。";
    self.tipLabel.textColor = NineColor;
    self.tipLabel.font = kFontRegularSize(14);
    [self.view addSubview:self.tipLabel];
    
    self.cPhoneLabel = [[UILabel alloc]init];
    self.cPhoneLabel.text = [NSString stringWithFormat:@"当前手机号：%@",kAppCacheInfo.phoneNum];
    self.cPhoneLabel.textColor = NineColor;
    self.cPhoneLabel.font = kFontRegularSize(14);
    [self.view addSubview:self.cPhoneLabel];
    
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
    //    self.phoneTextField.delegate = self;
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
    [self.loginButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.backgroundColor = rgba(153, 153, 153, 1);
    self.loginButton.userInteractionEnabled = NO;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 27;
    [self.loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    
}

-(void)layoutUI {
    [self.titlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(36);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.titlLabel.mas_bottom).offset(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.cPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(2);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    [self.undeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(132);
        make.top.equalTo(self.cPhoneLabel.mas_bottom).offset(13);
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


-(void)loginButtonClick {
    if (!_checkCodeTextField.text.length) {
        [self showMessage:@"请填写验证码"];
        return;
    }
    NSDictionary *params = @{
                             @"mobile":_phoneTextField.text,
                             @"smsCode":_checkCodeTextField.text
                             };
    
    [[BBRequestManager sharedInstance] updateUserMobileWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [self showMessage:@"修改成功" block:^{
            kAppCacheInfo.phoneNum = _phoneTextField.text;
            
            _phoneTextField.text = @"";
            _checkCodeTextField.text = @"";
            self.cPhoneLabel.text = [NSString stringWithFormat:@"当前手机号：%@",kAppCacheInfo.phoneNum];
            
            [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.codeButton setTitleColor:rgba(148, 153, 161, 1) forState:UIControlStateNormal];
            self.codeButton.userInteractionEnabled = YES;
            
            self.loginButton.backgroundColor = rgba(153, 153, 153, 1);
            self.loginButton.userInteractionEnabled = NO;
        }];
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];
    
    
}

@end
