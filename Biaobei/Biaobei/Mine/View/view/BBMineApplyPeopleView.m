//
//  BBMineApplyPeopleView.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineApplyPeopleView.h"

@interface BBMineApplyPeopleView()

@property (nonatomic, strong) UIView * coverView;
@property (nonatomic, strong) UIView * underView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * changeButton;
@property (nonatomic, strong) UIButton * sureButton;

@end

@implementation BBMineApplyPeopleView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

-(void)prepareUI {
    self.backgroundColor = [UIColor clearColor];
    self.coverView = [[UIView alloc] initWithFrame:self.bounds];
    self.coverView.backgroundColor = rgba(0, 0, 0, 0.4);
    [self addSubview:self.coverView];

    self.underView = [UIView new];
    self.underView.backgroundColor = [UIColor whiteColor];
    self.underView.layer.masksToBounds = YES;
    self.underView.layer.cornerRadius = 12;
    [self addSubview:self.underView];

    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"确认申请人信息";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = kFontMediumSize(20);
    [self.underView addSubview:self.titleLabel];

    UIView * nameView = [self getView:@"姓名" withSummary:kAppCacheInfo.userName];
    [self.underView addSubview:nameView];

    NSString *sex = @"女";
    if ([kAppCacheInfo.sex isEqualToString:@"1"]) {
        sex = @"男";
    }
    UIView * sexView = [self getView:@"性别" withSummary:sex];
    [self.underView addSubview:sexView];

    UIView * ageView = [self getView:@"年龄" withSummary:kAppCacheInfo.age];
    [self.underView addSubview:ageView];

    UIView * locationView = [self getView:@"籍贯" withSummary:kAppCacheInfo.nativePlace];
    [self.underView addSubview:locationView];

    self.changeButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.changeButton.backgroundColor = [UIColor clearColor];
    [self.changeButton setTitle:@"修改" forState:UIControlStateNormal];
    self.changeButton.titleLabel.font = kFontMediumSize(18);
    [self.changeButton setTitleColor:rgba(148, 153, 161, 1) forState:UIControlStateNormal];
    self.changeButton.layer.borderWidth = 1;
    self.changeButton.layer.borderColor = rgba(148, 153, 161, 1).CGColor;
    [self.changeButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.underView addSubview:self.changeButton];

    self.sureButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.sureButton.backgroundColor = [UIColor clearColor];
    [self.sureButton setTitle:@"确认" forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = kFontMediumSize(18);
    [self.sureButton setTitleColor:rgba(37, 194, 155, 1) forState:UIControlStateNormal];
    self.sureButton.layer.borderWidth = 1;
    self.sureButton.layer.borderColor = rgba(148, 153, 161, 1).CGColor;
    [self.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.underView addSubview:self.sureButton];

    [self.underView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(289);
        make.centerY.equalTo(self.mas_centerY);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.centerX.equalTo(self.underView.mas_centerX);
        make.height.mas_equalTo(20);
    }];

    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(nameView.mas_height);
    }];

    [ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sexView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(nameView.mas_height);
    }];

    [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ageView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(nameView.mas_height);
    }];

    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-1);
        make.width.mas_equalTo((SCREENWIDTH - 24)/2.0 + 1);
        make.height.mas_equalTo(58);
        make.bottom.mas_equalTo(1);
    }];

    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.changeButton.mas_right).offset(-1);
        make.right.mas_equalTo(1);
        make.height.mas_equalTo(58);
        make.bottom.mas_equalTo(1);
    }];
}

-(UIView *)getView:(NSString *)title withSummary:(NSString *)summary {
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    UILabel * titleLabel = [UILabel new];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = kFontRegularSize(18);
    titleLabel.text = title;
    [view addSubview:titleLabel];

    UILabel * summaryLabel = [UILabel new];
    summaryLabel.backgroundColor = [UIColor clearColor];
    summaryLabel.font = kFontRegularSize(18);
    summaryLabel.textColor = rgba(148, 153, 161, 1);
    summaryLabel.text = summary;
    [view addSubview:summaryLabel];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(42);
        make.height.mas_equalTo(18);
        make.centerY.equalTo(view.mas_centerY);
    }];

    [summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(45);
        make.height.mas_equalTo(18);
        make.centerY.equalTo(view.mas_centerY);
    }];
    return view;
}

-(void)cancleButtonClick {
    if (self.change) {
        self.change();
    }
    [self removeFromSuperview];
}

-(void)sureButtonClick {
    if (self.sure) {
        self.sure();
    }
    [self removeFromSuperview];
}

@end
