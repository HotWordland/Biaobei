//
//  BBJoinGroupSearchCollectionViewCell.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBJoinGroupSearchCollectionViewCell.h"
#import "BBMineJoinGropSearchBeanModel.h"

@interface BBJoinGroupSearchCollectionViewCell()
@property (nonatomic, strong) UIView * underView;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIImageView * searchImageView;

@end

@implementation BBJoinGroupSearchCollectionViewCell

-(void)prepareUI {
    self.underView = [UIView new];
    self.underView.backgroundColor = [UIColor whiteColor];
    self.underView.layer.masksToBounds = YES;
    self.underView.layer.cornerRadius = 10;
    [self.contentView addSubview: self.underView];

    self.textField = [UITextField new];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.font = kFontMediumSize(17);
    self.textField.placeholder = @"输入团队名称";
    [self.contentView addSubview:self.textField];

    self.searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mine_search"]];
    self.searchImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.searchImageView];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self
action:@selector(tapSearch)];
    [self.searchImageView addGestureRecognizer:tap];
}

-(void)layoutUI {
    [self.underView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
    }];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(24);
        make.centerY.mas_equalTo(self.underView.mas_centerY);
    }];

    [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.centerY.mas_equalTo(self.underView.mas_centerY);
        make.width.height.mas_equalTo(24);
    }];
}

-(void)updateUI {
    BBMineJoinGropSearchBeanModel * beanModel =(BBMineJoinGropSearchBeanModel*)self.beanModel;
    self.textField.text = beanModel.title;
}

-(void)tapSearch {
    self.textField.text = [self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.textField.text = [self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.textField resignFirstResponder];
    if (self.textField.text.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchGroup" object:self.textField.text];
    }
}

@end
