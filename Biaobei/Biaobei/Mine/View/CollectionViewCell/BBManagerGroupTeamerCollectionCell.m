//
//  BBManagerGroupTeamerCollectionCell.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBManagerGroupTeamerCollectionCell.h"
#import "BBManagerGroupteamerCellModel.h"
#import "BBManagerGroupteamerBeanModel.h"

@interface BBManagerGroupTeamerCollectionCell ()
@property (nonatomic, strong) UIView * underView;
@property (nonatomic, strong) UIView * removeUnderView;
@property (nonatomic, strong) UILabel * removeLabel;
@property (nonatomic, strong) UIView * slideView;
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * phoneLabel;
@property (nonatomic, strong) UIButton * refuseButton;
@property (nonatomic, strong) UIButton * accessButton;
@property (nonatomic, strong) UIPanGestureRecognizer * pangest;
@property (nonatomic, strong) UITapGestureRecognizer * removeTap;
@end

@implementation BBManagerGroupTeamerCollectionCell

-(void)prepareUI {
    self.underView = [UIView new];
    self.underView.backgroundColor = [UIColor whiteColor];
    self.underView.layer.masksToBounds = YES;
    self.underView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.underView];

    self.removeUnderView = [UIView new];
    self.removeUnderView.backgroundColor = rgba(208, 2, 27, 1);
    self.removeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeButtonClick)];
    [self.underView addSubview:self.removeUnderView];

    self.removeLabel = [UILabel new];
    self.removeLabel.text = @"移出团队";  //移除改为移出
    self.removeLabel.textColor = [UIColor whiteColor];
    [self.removeUnderView addSubview:self.removeLabel];


    self.slideView = [UIView new];
    self.slideView.backgroundColor = [UIColor whiteColor];
    self.pangest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.underView addSubview:self.slideView];

    self.headerImageView = [UIImageView new];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 17;
    self.headerImageView.image = [UIImage imageNamed:@"男头"];
    [self.slideView addSubview:self.headerImageView];

    self.nameLabel = [UILabel new];
    self.nameLabel.font = kFontMediumSize(17);
    self.nameLabel.textColor = rgba(51, 57, 76, 1);
    [self.slideView addSubview:self.nameLabel];

    self.phoneLabel = [UILabel new];
    self.phoneLabel.font = kFontRegularSize(12);
    self.phoneLabel.textColor = rgba(148, 153, 161, 1);
    [self.slideView addSubview:self.phoneLabel];

    self.refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [self.refuseButton addTarget:self action:@selector(refusedButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.refuseButton setTitleColor:rgba(148, 153, 161, 1) forState:UIControlStateNormal];
    [self.slideView addSubview: self.refuseButton];

    self.accessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.accessButton setTitle:@"通过" forState:UIControlStateNormal];
    [self.accessButton addTarget:self action:@selector(accessButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.accessButton.layer.masksToBounds = YES;
    self.accessButton.layer.cornerRadius = 16;
    self.accessButton.layer.borderWidth = 1;
    self.accessButton.layer.borderColor = rgba(37, 194, 155, 1).CGColor;
    [self.accessButton setTitleColor:rgba(37, 194, 155, 1) forState:UIControlStateNormal];
    [self.slideView addSubview: self.accessButton];
}

-(void)layoutUI {
    [self.underView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(66);
    }];

    [self.removeUnderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(130);
    }];

    [self.removeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.centerY.equalTo(self.removeUnderView.mas_centerY);
        make.height.mas_equalTo(18);
    }];

    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];

    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.equalTo(self.slideView.mas_centerY);
        make.width.height.mas_equalTo(34);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_top);
        make.height.mas_equalTo(17);
        make.left.equalTo(self.headerImageView.mas_right).offset(12);
    }];

    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.left.equalTo(self.nameLabel.mas_left);
        make.height.mas_equalTo(12);
    }];

    [self.accessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.equalTo(self.headerImageView.mas_centerY);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(64);
    }];

    [self.refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accessButton.mas_left).offset(-9);
        make.centerY.equalTo(self.headerImageView.mas_centerY);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(64);
    }];
}

-(void)updateUI {
    BBManagerGroupteamerBeanModel * beanModel = (BBManagerGroupteamerBeanModel *)self.beanModel;
    self.nameLabel.text = beanModel.name;
    self.phoneLabel.text = beanModel.phonoNumer;
    [self.slideView removeGestureRecognizer:self.pangest];
    [self.removeUnderView removeGestureRecognizer:self.removeTap];
    if (beanModel.isMember) {
        self.refuseButton.hidden = YES;
        self.accessButton.hidden = YES;
        
        [self.slideView addGestureRecognizer:self.pangest];
        [self.removeUnderView addGestureRecognizer:self.removeTap];
    } else {
        self.refuseButton.hidden = NO;
        self.accessButton.hidden = NO;

    }
    
    if ([beanModel.sex isEqualToString:@"1"]) {
        self.headerImageView.image = [UIImage imageNamed:@"男头"];
    }else{
        self.headerImageView.image = [UIImage imageNamed:@"女头"];
    }
    
}

-(void)pan:(UIPanGestureRecognizer *)pan {
//    self.removeUnderView.hidden = NO;  //显示删除

    CGPoint transp = [pan translationInView:self.slideView];
    transp.y = 0;
    if (self.slideView.frame.origin.x + transp.x > 0) {
        transp.x = 0;
    } else if (self.slideView.frame.origin.x + transp.x < - 121) {
        transp.x = -121 - self.slideView.frame.origin.x;
    }

    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.slideView.frame.origin.x + transp.x <= -60) {
            transp.x = -121 - self.slideView.frame.origin.x;
        } else {
            transp.x = 0 - self.slideView.frame.origin.x;
        }
    }
    self.slideView.transform = CGAffineTransformTranslate(self.slideView.transform, transp.x, transp.y);
    [pan setTranslation:CGPointZero inView:pan.view];
    

}

//实际开发要等请求完成再发通知
-(void)refusedButtonClick {
    NSLog(@"refusedButtonClick");
    BBManagerGroupteamerBeanModel * beanModel = (BBManagerGroupteamerBeanModel *)self.beanModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refused" object:beanModel];
}

/* 同意加入团队 */
-(void)accessButtonClick {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(accessAction) object:nil];
    [self performSelector:@selector(accessAction) withObject:nil afterDelay:0.3];
}
/* 发出通过通知 */
-(void)accessAction {
    NSLog(@"accessButtonClick");
    BBManagerGroupteamerBeanModel * beanModel = (BBManagerGroupteamerBeanModel *)self.beanModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"access" object:beanModel];
}

-(void)removeButtonClick {
    NSLog(@"removeButtonClick");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要移出团队吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //Fix:不需要切换主线程
        BBManagerGroupteamerBeanModel * beanModel = (BBManagerGroupteamerBeanModel *)self.beanModel;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:beanModel];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    UIViewController *currentVC = [self getCurrentViewInController];
    currentVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [currentVC presentViewController:alert animated:YES completion:nil];
}

@end
