//
//  BBTaskSuccessView.m
//  Biaobei
//
//  Created by 胡志军 on 2019/10/20.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "BBTaskSuccessView.h"
#import "UIView+Factory_hzj.h"
#import "AppDelegate.h"
@interface BBTaskSuccessView ()
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * lineLab;
@property (nonatomic, strong) UIButton * downBtn;
@property (nonatomic, strong) UIImageView * showImage;
@end
@implementation BBTaskSuccessView

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
    self.backView.backgroundColor = [UIColor whiteColor];
    kViewRadius(self.backView, 10);
    
    self.showImage = [UIImageView ImageViewImageName:@"success"];
    [self.backView addSubview:self.showImage];
    
    self.titleLab = [UILabel LableText:@"任务提交成功\n可在个人中心查看审核进度" textColor:rgba(51, 57, 76, 1) textFont:kFontRegularSize(16)];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.titleLab];
    self.titleLab.numberOfLines = 2;
    
    self.lineLab = [UILabel new];
    self.lineLab.backgroundColor = rgba(238, 238, 238, 1);
    [self.backView addSubview:self.lineLab];
    
    self.downBtn = [UIButton ButtonText:@"我知道了" textColor:rgba(37, 194, 155, 1) textFont:kFontMediumSize(18) backGroundColor:[UIColor clearColor] trail:self action:@selector(btnDidClick:) tag:10];
    [self.backView addSubview:self.downBtn];
    
}
- (void)setLayout {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.offset = 271;
        make.height.offset = 238;
    }];
    [self.showImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 34;
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.offset = 84/2;
        make.height.offset = 94/2;
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.showImage.mas_bottom).offset = 14;
        make.left.right.offset = 0;
    }];
    [self.lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.bottom.offset = -56;
        make.height.offset = 1;
    }];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset = 56;
        make.bottom.left.right.offset = 0;
    }];
}

- (void)btnDidClick:(UIButton *)button {
    [self removeFromSuperview];
    if (self.TaskSuccessBlock) {
        self.TaskSuccessBlock();
    }
}

@end
