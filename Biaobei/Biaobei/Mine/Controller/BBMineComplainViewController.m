//
//  BBMineComplainViewController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineComplainViewController.h"

#define GetHeight(number) number/812.0 * [UIScreen mainScreen].bounds.size.height
@interface BBMineComplainViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) UILabel * placeHoldLabel;
@property (nonatomic, strong) UILabel * tipNumerLabel;
@property (nonatomic, strong) UILabel * tipFrontNumberLabel;
@property (nonatomic, strong) UIView * phoneUnderView;
@property (nonatomic, strong) UITextField * phoneTextField;
@property (nonatomic, strong) UILabel * tipLabel;
@property (nonatomic, strong) UIButton * referButton;
@end

@implementation BBMineComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
    [self resgisterEnditing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)prepareUI {
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"意见反馈";
    self.titleLabel.font = [UIFont systemFontOfSize:GetHeight(36)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.titleLabel];

    UIView * textViewUnderView = [UIView new];
    textViewUnderView.backgroundColor = [UIColor whiteColor];
    textViewUnderView.layer.masksToBounds = YES;
    textViewUnderView.layer.cornerRadius = 9;
    [self.view addSubview:textViewUnderView];

    self.textView = [UITextView new];
    self.textView.editable = YES;
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.backgroundColor = [UIColor clearColor];
    [textViewUnderView addSubview:self.textView];

    self.placeHoldLabel = [UILabel new];
    self.placeHoldLabel.textColor = [UIColor colorWithRed:143.0/255 green:153.0/255 blue:161.0/255 alpha:1];
    self.placeHoldLabel.numberOfLines = 2;
    self.placeHoldLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.placeHoldLabel.text = @"请输入你在使用中遇到的问题或者对“数据工场“APP的优化建议";
    self.placeHoldLabel.font = [UIFont systemFontOfSize:16];
    [textViewUnderView addSubview:self.placeHoldLabel];

    self.tipNumerLabel = [UILabel new];
    self.tipNumerLabel.font = [UIFont systemFontOfSize:14];
    self.tipNumerLabel.textColor = [UIColor colorWithRed:148/255.0 green:153.0/255 blue:161.0/255 alpha:1];
    self.tipNumerLabel.text = @"/200";
    [textViewUnderView addSubview:self.tipNumerLabel];

    self.tipFrontNumberLabel= [UILabel new];
    self.tipFrontNumberLabel.font = [UIFont systemFontOfSize:14];
    self.tipFrontNumberLabel.text = @"0";
    self.tipFrontNumberLabel.textColor = [UIColor colorWithRed:148/255.0 green:153.0/255 blue:161.0/255 alpha:1];
    self.tipFrontNumberLabel.textAlignment = NSTextAlignmentRight;
    [textViewUnderView addSubview:self.tipFrontNumberLabel];

    self.phoneUnderView = [UIView new];
    self.phoneUnderView.backgroundColor = [UIColor whiteColor];
    self.phoneUnderView.layer.masksToBounds = YES;
    self.phoneUnderView.layer.cornerRadius = 9;
    self.phoneUnderView.userInteractionEnabled = YES;
    UITapGestureRecognizer * phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startEditPhoneNumber)];
    [self.phoneUnderView addGestureRecognizer:phoneTap];
    [self.view addSubview:self.phoneUnderView];

    self.phoneTextField = [UITextField new];
    self.phoneTextField.placeholder = @"请留下你的手机号";
    self.phoneTextField.delegate = self;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.font = [UIFont systemFontOfSize:16];
    [self.phoneUnderView addSubview:self.phoneTextField];
    [self.phoneTextField addTarget:self action:@selector(checkButton) forControlEvents:UIControlEventEditingChanged];

    self.tipLabel = [UILabel new];
    self.tipLabel.font = [UIFont systemFontOfSize:14];
    self.tipLabel.numberOfLines = 2;
    self.tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.tipLabel.textColor = [UIColor colorWithRed:195.0/255 green:196.0/255 blue:201.0/255 alpha:1];
    self.tipLabel.text = @"你的手机号有助于我们尽快沟通和解决问题，仅工作人员可见";
    [self.view addSubview:self.tipLabel];

    self.referButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.referButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.referButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.referButton.backgroundColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    self.referButton.layer.masksToBounds = YES;
    self.referButton.layer.cornerRadius = 27;
    self.referButton.userInteractionEnabled = false;
    [self.view addSubview:self.referButton];
    [self.referButton addTarget:self action:@selector(referButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(GetHeight(20));
        make.height.mas_equalTo(GetHeight(36));
    }];;

    [textViewUnderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(GetHeight(354));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GetHeight(24));
    }];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(14);
        make.bottom.mas_equalTo(-56);
    }];

    [self.placeHoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(22);
        make.right.mas_equalTo(-20);
    }];

    [self.tipNumerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(12);
        make.bottom.mas_equalTo(-20);
    }];

    [self.tipFrontNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipNumerLabel.mas_left);
        make.height.mas_equalTo(12);
        make.bottom.mas_equalTo(-20);
    }];

    [self.phoneUnderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textViewUnderView.mas_left);
        make.right.equalTo(textViewUnderView.mas_right);
        make.height.mas_equalTo(66);
        make.top.equalTo(textViewUnderView.mas_bottom).offset(13);
    }];

    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.phoneUnderView.mas_centerY);
    }];

    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.top.equalTo(self.phoneUnderView.mas_bottom).offset(15);
    }];

    [self.referButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(54);
        make.bottom.mas_equalTo(-32);
    }];

}

-(void)startEditPhoneNumber {
    [self.phoneTextField becomeFirstResponder];
}

-(void)checkButton {
    if (self.textView.text.length >0 && self.phoneTextField.text.length == 11) {
        self.referButton.userInteractionEnabled = YES;
        self.referButton.backgroundColor = [UIColor colorWithRed:37.0/255 green:194.0/255 blue:155.0/255 alpha:1];
    } else {
        self.referButton.userInteractionEnabled = false;
        self.referButton.backgroundColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    }
}

#pragma mark - 提交
-(void)referButtonAction{
    if (_textView.text.length>200) {
        [self showMessage:@"文字过长"];
        return;
    }
    
    NSDictionary *params = @{
                             @"comment":_textView.text,
                             @"mobile":_phoneTextField.text
                             };
    [[BBRequestManager sharedInstance] postUserCommentWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [self showMessage:@"提交成功" block:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];
}

-(void)textViewDidChange:(UITextView *)textView {
    self.tipFrontNumberLabel.text = [NSString stringWithFormat:@"%ld",textView.text.length];
    if (textView.text.length > 0 && textView.text.length <=200) {
        self.placeHoldLabel.hidden = YES;
        self.tipFrontNumberLabel.textColor = [UIColor colorWithRed:0/255 green:202.0/255 blue:160.0/255 alpha:1];
    } else if (textView.text.length > 200) {
        self.tipFrontNumberLabel.textColor = [UIColor colorWithRed:208/255.0 green:2.0/255 blue:7.0/255 alpha:1];
        self.placeHoldLabel.hidden = YES;
    } else {
        self.tipFrontNumberLabel.textColor = [UIColor colorWithRed:148/255.0 green:153.0/255 blue:161.0/255 alpha:1];
        self.placeHoldLabel.hidden = NO;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self checkButton];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        [self checkButton];
        return;
    }
    if (textField.text.length != 11 && [[textField.text substringToIndex:1] isEqualToString:@"1"]) {
        //提示 请输入正确手机号
    }
    [self checkButton];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyBoardShow:(NSNotification *)notif {
    CGRect frame = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (SCREENHEIGHT - frame.size.height < self.phoneUnderView.frame.size.height + self.phoneUnderView.frame.origin.y + StatusAndNaviHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, (self.phoneUnderView.frame.origin.y + self.phoneTextField.frame.size.height + StatusAndNaviHeight) - SCREENHEIGHT + frame.size.height, SCREENWIDTH, self.view.frame.size.height);
        }];
    }

}

-(void)keyBoardHidden:(NSNotification *)notif {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, StatusAndNaviHeight, SCREENWIDTH, self.view.frame.size.height);
    }];
}

@end
