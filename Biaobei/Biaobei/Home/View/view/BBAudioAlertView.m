//
//  BBAudioAlertView.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/17.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBAudioAlertView.h"

@implementation BBAudioAlertView

-(instancetype)initWithWhiteFrame:(CGRect)frame AudioAlertType:(AudioAlertType)alertType alertTitle:(NSString *)title highLightStr:(NSString *)highLightStr{
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
        [whiteView addSubview:alertImgView];
        
        //2.
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, alertImgView.bottom+15, width-10, 20)];
        [whiteView addSubview:topLabel];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:title];
        [att addAttributes:@{
                             NSFontAttributeName:kFontRegularSize(18),
                             NSForegroundColorAttributeName:BlackColor
                             } range:NSMakeRange(0, att.length)];
        [att addAttribute:NSForegroundColorAttributeName value:GreenColor range:[title rangeOfString:highLightStr]];
        topLabel.attributedText = att;
        topLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *botLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, topLabel.bottom+5, width-10, 20)];
        botLabel.textColor = BlackColor;
        botLabel.font = kFontRegularSize(18);
        botLabel.textAlignment = NSTextAlignmentCenter;
        [whiteView addSubview:botLabel];
        
        switch (alertType) {
            case AlertTypeSaveFail:  //保存失败
                alertImgView.image = [UIImage imageNamed:@"失败中断"];
                botLabel.text = @"请稍后再试";
                break;
                
            case AlertTypeSaveSuccess: //保存成功
                alertImgView.image = [UIImage imageNamed:@"成功"];
                botLabel.text = @"可在个人中心已录制查看";
                break;
                
            case AlertTypeUpLoading: //上传中
                
                break;
                
            case AlertTypeUpLoadSuccess: //上传成功
                alertImgView.image = [UIImage imageNamed:@"成功"];
                botLabel.text = @"可在个人中心查看审核进度";
                break;
                
            default:
                break;
        }
        
        
    }
    
    return self;
}

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
        MLLabel *titleLabel = [[MLLabel alloc]initWithFrame:CGRectMake(30, alertImgView.bottom+15, width-60, 40)];
        titleLabel.lineSpacing = 5;
        titleLabel.font = kFontRegularSize(18);
        titleLabel.textColor = BlackColor;
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
        [titleLabel sizeToFit];
        [whiteView addSubview:titleLabel];
        
        if (highLightStr || highLightStr.length > 0) {
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
    if (self.btnSelect) {
        self.btnSelect(1);  //
    }
    [self cancelView];
}


-(void)cancelView{
    [self removeFromSuperview];
}

@end
