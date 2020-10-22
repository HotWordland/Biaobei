//
//  UserProtocolAndPrivacyToast.m
//  Biaobei
//
//  Created by yanming niu on 2019/11/27.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "UserProtocolAndPrivacyToast.h"
#import "AppDelegate.h"
#import "UIView+Factory_hzj.h"
#import "NSString+AttributedString.h"
#import "BBAggreProtocolViewController.h"
#import "FMLinkLabel.h"
#import "UILabel+LCLabelCategory.h"

#define AlertText @"欢迎使用“数据工场”！我们非常重视您的个人信息和隐私保护。在您使用“数据工场”之前，请仔细阅读《数据工场用户协议》和《数据工场隐私政策》，我们将严格按照经您同意的各项条款使用您的个人信息，为您提供服务。\n如您同意，请点击“同意”即可开始使用我们的产品和服务，我们尽全力保护您的个人信息安全。"

@interface UserProtocolAndPrivacyToast ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel*titleLab;

//@property (nonatomic, strong) UILabel *detailLab;

@property (nonatomic, strong) FMLinkLabel *detailLab;


@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UILabel *line2;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *ageBtn;
//@property (nonatomic, assign) NSInteger index;  //点击了协议或隐私

@end

@implementation UserProtocolAndPrivacyToast

- (instancetype)init {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = rgba(0, 0, 0, 0.2);
        [self setUI];
        [self setLayout];
    }
    return self;
}

- (NSMutableAttributedString *)setAttributeString:(NSString *)string string1:(NSString *)string1 string2:(NSString *)string2 font:(UIFont *)font color:(UIColor *)color {
    NSRange range1 = [string rangeOfString:string1 options:NSBackwardsSearch];
    NSRange range2 = [string rangeOfString:string2 options:NSBackwardsSearch];
    NSMutableAttributedString * aStr1 = [[NSMutableAttributedString alloc] initWithString:string];
    
    [aStr1 setAttributes:@{ NSForegroundColorAttributeName:color, NSFontAttributeName:font } range:range1];
    [aStr1 setAttributes:@{ NSForegroundColorAttributeName:color, NSFontAttributeName:font } range:range2];
    return aStr1;
}

- (void)setUI {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    self.backView = [UIView ViewView];
    [self addSubview:self.backView];
    
    self.titleLab = [UILabel LableText:@"用户协议与隐私政策" textColor:rgba(51, 57, 76, 1) textFont:kFontMediumSize(18)];
    [self.backView addSubview:self.titleLab];
    
//    self.detailLab = [UILabel LableText:@"" textColor:rgba(51, 57, 76, 1) textFont:kFontRegularSize(18)];
    
    NSString *string1 = @"《数据工场用户协议》";
    NSString *string2 = @"《数据工场隐私政策》";

    NSAttributedString *attrText = [self setAttributeString:AlertText
                                                    string1:string1
                                                    string2:string2
                                                       font:kFontRegularSize(18)
                                                      color:rgba(37, 194, 155, 1)];
    CGRect rect = CGRectMake(12, 202, 351, 351);
    self.detailLab = [[FMLinkLabel alloc] initWithFrame:rect];
    self.detailLab.textColor = rgba(51, 57, 76, 1);
    self.detailLab.font = kFontRegularSize(18);
    self.detailLab.numberOfLines = 0;
    self.detailLab.text = AlertText;
    self.detailLab.attributedText = attrText;
    [self.backView addSubview:self.detailLab];

    
    NSRange range1 = [AlertText rangeOfString:string1 options:NSBackwardsSearch];
    NSRange range2 = [AlertText rangeOfString:string2 options:NSBackwardsSearch];
    kWeak_self
    [ self.detailLab setLc_tapBlock:^(NSInteger index, NSAttributedString *charAttributedString) {
        NSInteger __index = 0;
        if (index >= range1.location && index <= range1.location + range1.length) {
            __index = 1;  //《数据工场用户协议》

        } else if (index >= range2.location && index <= range2.location + range2.length) {
            __index = 2;  //数据工场隐私政策
        } else {
            return;
        }
        if (weakSelf.procolBlock) {
            weakSelf.procolBlock(__index);
        }
        NSLog(@"%@,%@,%@",@(index),charAttributedString,charAttributedString.string);
    }];
    
  
    self.line1 = [UILabel new];
    self.line1.backgroundColor = rgba(238, 238, 238, 1);
    [self.backView addSubview:self.line1];
    
    self.line2 = [UILabel new];
    self.line2.backgroundColor = rgba(238, 238, 238, 1);
    
    self.cancleBtn = [UIButton ButtonText:@"不同意" textColor:rgba(148, 153, 161, 1) textFont:kFontMediumSize(18) backGroundColor:[UIColor whiteColor] trail:self action:@selector(targetAction:) tag:10];
    [self.backView addSubview:self.cancleBtn];
    
    self.ageBtn = [UIButton ButtonText:@"同意" textColor:rgba(37, 194, 155, 1) textFont:kFontMediumSize(18) backGroundColor:[UIColor whiteColor] trail:self action:@selector(targetAction:) tag:11];
    [self.backView addSubview:self.ageBtn];
    self.backView.backgroundColor = [UIColor whiteColor];
    kViewRadius(self.backView, 12);
    [self.backView addSubview:self.line2];
 }

- (void)setLayout {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.offset = 12;
        make.right.offset = -12;
        make.height.offset = 380;
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
//协议书
//- (void)tapDidClick {
//    if (self.procolBtnDidClock) {
//        self.procolBtnDidClock();
//    }
//    [self removeFromSuperview];
//}

- (void)targetAction:(UIButton *)btn {
    if (btn.tag == 10) {//不同意
        self.agreeBlock(NO);
//        [self removeFromSuperview];
    } else {
        if (self.agreeBlock) {
            self.agreeBlock(YES );
        }
        [self removeFromSuperview];
    }
}

@end
