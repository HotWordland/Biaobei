//
//  ToastView.m
//  Biaobei
//
//  Created by 王家辉 on 2019/11/26.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "ToastView.h"
#import "UIView+Factory_hzj.h"
#import "AppDelegate.h"
#import "CircleView.h"

@interface ToastView ()
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * lineLab;
@property (nonatomic, strong) UIButton * downBtn;
//@property (nonatomic, strong) UIImageView * showImage;
@property (nonatomic, strong) CircleView *circleView;
@end

@implementation ToastView

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
    self.backView.backgroundColor = [UIColor whiteColor];
    kViewRadius(self.backView, 10);
    [self addSubview:self.backView];

    self.circleView = [[CircleView alloc] initWithFrame:CGRectMake(114, 31, 44, 44)];
    self.circleView.strokelineWidth = 4;  //圆环内径
    [self.circleView circleWithProgress:100 andIsAnimate:YES];  //设置进度,是否有动画效果
    [self.backView addSubview:self.circleView];
    
    self.titleLab = [UILabel LableText:@"任务上传中\n请不要关闭页面或退出APP" textColor:rgba(51, 57, 76, 1) textFont:kFontRegularSize(16)];
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
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 31;
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.offset = 44;
        make.height.offset = 44;
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleView.mas_bottom).offset = 14;
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
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
