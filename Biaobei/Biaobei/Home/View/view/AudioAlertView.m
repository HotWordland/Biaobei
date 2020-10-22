//
//  AudioAlertView.m
//  Biaobei
//
//  Created by 王家辉 on 2019/12/11.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "AudioAlertView.h"
#import "CustomLabel.h"

@interface AudioAlertView ()
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString * message;

@property (nonatomic, strong) EdgeInsetsLabel * messageL;
@property (nonatomic, strong) UIView * HLine;
@property (nonatomic, strong) UIView * VLine;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIButton * okButton;
@end

@implementation AudioAlertView

-(instancetype)init:(NSString *)imageName alertMessage:(NSString *)message
                                    cancelTitle:(NSString *)cancelTitle
                                        okTitle:(NSString *)okTitle {
    self = [super init];
    if (self) {
        self.message = message;
        self.imageName = imageName;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
        [self addGestureRecognizer:tapGes];
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = WhiteColor;
        self.backgroundView.layer.cornerRadius = 12;
        self.backgroundView.clipsToBounds = YES;
        [self addSubview:self.backgroundView];
        
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.image = [UIImage imageNamed:imageName];
        [self.backgroundView addSubview:self.imageView];
        
       
        self.messageL = [[EdgeInsetsLabel alloc] initWithFrame:CGRectZero];
        self.messageL.edgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);  //top,left,bottom,right 设置左内边距
        self.messageL.font = kFontRegularSize(18);
        self.messageL.textColor = BlackColor;
        self.messageL.text = message;
        self.messageL.textAlignment = NSTextAlignmentCenter;
        self.messageL.numberOfLines = 0;
        [self.messageL sizeToFit];

//      [self.messageL setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

        [self.backgroundView addSubview:self.messageL];
      
        //水平分割线
        self.HLine = [[UIView alloc]initWithFrame:CGRectZero];
        self.HLine.backgroundColor = [UIColor colorWithHex:@"#EEEEEE"];
        [self.backgroundView addSubview:self.HLine];
        
        //垂直分割线
        self.VLine = [[UIView alloc]initWithFrame:CGRectZero];
        self.VLine.backgroundColor = [UIColor colorWithHex:@"#EEEEEE"];
        [self.backgroundView addSubview:self.VLine];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectZero;
        [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor colorWithHex:@"#9499A1"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.cancelButton];
        
        self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.okButton.frame = CGRectZero;
        [self.okButton setTitle:okTitle forState:UIControlStateNormal];
        [self.okButton setTitleColor:GreenColor forState:UIControlStateNormal];
        [self.okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.okButton];
        
        [self layout];  //自动布局
    }
    return self;
}

- (void)layout {

    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(50.0);
        make.right.mas_equalTo(-50.0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 26;
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.offset = 84/2;
        make.height.offset = 94/2;
    }];
    
    [self.messageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backgroundView).offset = 88;
        make.left.mas_equalTo(20.0);
        make.right.mas_equalTo(-20.0);
    }];
    
    [self.HLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageL.mas_bottom).offset = 25;
        make.left.right.offset = 0;
        make.height.offset = 1;
    }];
    
    [self.VLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.HLine.mas_top).offset(1);
        make.left.offset = 150;
        make.width.offset = 1;
        make.height.offset = 57;
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.HLine.mas_bottom).offset = 1;
        make.width.offset = 300 / 2;
        make.height.offset = 57;
        make.left.bottom.offset = 0;
    }];

    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.HLine.mas_bottom).offset = 1;
        make.left.offset = 300 / 2 ;
        make.width.offset = 300 / 2 ;
        make.height.offset = 57;
        make.right.bottom.offset = 0;
    }];
}

-(void)cancelAction{
    [self cancelView];
}

-(void)okAction{
    if (self.okBlock) {
        self.okBlock(1);
    }
    [self cancelView];
}


-(void)cancelView{
    [self removeFromSuperview];
}


@end
