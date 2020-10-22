//
//  BBTaskAlertView.m
//  Biaobei
//
//  Created by 胡志军 on 2019/10/20.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "BBTaskAlertView.h"
#import "AppDelegate.h"
#import "UIView+Factory_hzj.h"
#import "NSString+AttributedString.h"
#import "BBAggreProtocolViewController.h"


@interface BBTaskAlertView ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel*titleLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UILabel *line2;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *ageBtn;
@end
@implementation BBTaskAlertView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = rgba(0, 0, 0, 0.2);
        [self setUI];
        [self setLayout];
    }
    return self;
}
- (void)setUI {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.backView = [UIView ViewView];
    [self addSubview:self.backView];
    
    self.titleLab = [UILabel LableText:@"个人信息采集授权确认" textColor:rgba(51, 57, 76, 1) textFont:kFontMediumSize(18)];
    [self.backView addSubview:self.titleLab];
    
    self.detailLab = [UILabel LableText:@"" textColor:rgba(51, 57, 76, 1) textFont:kFontRegularSize(18)];
    self.detailLab.numberOfLines = 0;
    self.detailLab.attributedText = [@"为确保您的数据正常上传，请仔细阅读《数据工厂个人信息采集授权书》我们将严格按照您同意的各项条款使用您的采集数据，为您提供服务。如您同意，请点击“同意”即可开始录音" changeSubStirng:@"《数据工厂个人信息采集授权书》" font:kFontRegularSize(18) color:rgba(37, 194, 155, 1)];
    [self.backView addSubview:self.detailLab];
    
    self.line1 = [UILabel new];
    self.line1.backgroundColor = rgba(238, 238, 238, 1);
    [self.backView addSubview:self.line1];
    
    self.line2 = [UILabel new];
    self.line2.backgroundColor = rgba(238, 238, 238, 1);
    
    self.cancleBtn = [UIButton ButtonText:@"不同意" textColor:rgba(148, 153, 161, 1) textFont:kFontMediumSize(18) backGroundColor:[UIColor whiteColor] trail:self action:@selector(btnDidClick:) tag:10];
    [self.backView addSubview:self.cancleBtn];
    
    self.ageBtn = [UIButton ButtonText:@"同意" textColor:rgba(37, 194, 155, 1) textFont:kFontMediumSize(18) backGroundColor:[UIColor whiteColor] trail:self action:@selector(btnDidClick:) tag:11];
    [self.backView addSubview:self.ageBtn];
    self.backView.backgroundColor = [UIColor whiteColor];
    
    kAddTapRecognizer(@"tapDidClick", self, self.detailLab);
    
    kViewRadius(self.backView, 12);
    [self.backView addSubview:self.line2];

}
- (void)setLayout {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.offset = 12;
        make.right.offset = -12;
        make.height.offset = 300;
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backView.mas_centerX);
        make.top.offset = 24;
        make.height.offset = 26;
    }];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 30;
        make.right.offset = -30;
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset=16;
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset = 0;
        make.bottom.offset = -56;
        make.height.offset = 1;
    }];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.mas_equalTo(self.ageBtn.mas_left);
        make.height.offset = 56;
        make.bottom.offset = 0;
        make.width.mas_equalTo(self.ageBtn.mas_width);
    }];
    [self.ageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.bottom.offset = 0;
        make.height.offset = 56;
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cancleBtn.mas_right).offset = -0.5;
        make.height.offset = 56;
        make.width.offset = 1;
        make.bottom.offset = 0;
    }];
}
//协议别点击
- (void)tapDidClick{
    if (self.procolBtnDidClock) {
        self.procolBtnDidClock();
    }
    [self removeFromSuperview];

//    [[BaseViewController topViewController].navigationController pushViewController:[BBAggreProtocolViewController new] animated:YES];
}
- (void)btnDidClick:(UIButton *)btn {
    if (btn.tag == 10) {//不同意
        [self removeFromSuperview];
    }else {
        if (self.aggreBtnDidClock) {
            self.aggreBtnDidClock();
        }
        [self removeFromSuperview];

    }
}
@end
