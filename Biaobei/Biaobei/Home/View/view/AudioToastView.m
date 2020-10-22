//
//  AudioToastView.m
//  Biaobei
//
//  Created by 王家辉 on 2019/12/10.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "AudioToastView.h"

@implementation AudioToastView

-(instancetype)initWithWhiteFrame:(CGRect)frame alertImage:(UIImage *)image alertTitle:(NSString *)title highLightStr:(NSString *)highLightStr leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelView)];
        [self addGestureRecognizer:tapGes];
        
        UIView *whiteView = [[UIView alloc]initWithFrame:frame];
        whiteView.backgroundColor = WhiteColor;
        whiteView.layer.cornerRadius = 12;
        whiteView.clipsToBounds = YES;
        [self addSubview:whiteView];
        
        float width = frame.size.width;
        float heigt = frame.size.height;
        
        //1.
        UIImageView *alertImgView = [[UIImageView alloc]initWithFrame:CGRectMake((width-50)/2, 30, 50, 50)];
        alertImgView.contentMode = UIViewContentModeScaleAspectFit;
        alertImgView.image = image;
        [whiteView addSubview:alertImgView];
        
        //2.
        MLLabel *titleLabel = [[MLLabel alloc] initWithFrame:CGRectZero];
        
        titleLabel.lineSpacing = 5;
        titleLabel.font = kFontRegularSize(18);
        titleLabel.textColor = BlackColor;
        titleLabel.text = title;
        [whiteView addSubview:titleLabel];
        
        if (highLightStr || highLightStr.length) {
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:title];
            [att addAttributes:@{
                                 NSFontAttributeName:kFontRegularSize(18),
                                 NSForegroundColorAttributeName:BlackColor
                                 } range:NSMakeRange(0, att.length)];
            [att addAttribute:NSForegroundColorAttributeName value:GreenColor range:[title rangeOfString:highLightStr]];
            titleLabel.attributedText = att;
            titleLabel.numberOfLines = 0;
            [titleLabel sizeToFit];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(alertImgView.mas_bottom).offset = 14;
                make.left.right.offset = 0;
            }];
        }
        
        //3.
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, heigt-56, width/2, 56);
        [leftBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithHex:@"#9499A1"] forState:UIControlStateNormal];
        [whiteView addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(width/2, heigt-56, width/2, 56);
        [rightBtn setTitle:rightBtnTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        [whiteView addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        //分割线
        UIView *hLine = [[UIView alloc]initWithFrame:CGRectMake(0, heigt-57, width, 1.0)];
        hLine.backgroundColor = [UIColor colorWithHex:@"#EEEEEE"];
        [whiteView addSubview:hLine];
        
        UIView *vLine = [[UIView alloc]initWithFrame:CGRectMake(width/2-0.5, heigt-57, 1.0, 57.0)];
        vLine.backgroundColor = [UIColor colorWithHex:@"#EEEEEE"];
        [whiteView addSubview:vLine];
        
    }
    
    return self;
}


-(void)leftBtnAction{
    [self cancelView];
}

-(void)rightBtnAction{
    if (self.okBlock) {
        self.okBlock(1);
    }
    [self cancelView];
}


-(void)cancelView{
    [self removeFromSuperview];
}

@end
