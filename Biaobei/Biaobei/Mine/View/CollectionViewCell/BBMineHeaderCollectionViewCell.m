//
//  BBMineHeaderCollectionViewCell.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineHeaderCollectionViewCell.h"
#import "BBMineHeaderBeanModel.h"

@interface BBMineHeaderCollectionViewCell ()
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * groupLabel;
@property (nonatomic, strong) UIImageView * directionImageView;
@end

@implementation BBMineHeaderCollectionViewCell

-(void)prepareUI {
    _headerImageView = [UIImageView new];
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = 30;
    [self.contentView addSubview:_headerImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:24];
    [self.contentView addSubview:_nameLabel];
    
    _groupLabel = [UILabel new];
    _groupLabel.layer.borderWidth = 1;
    _groupLabel.layer.borderColor = GreenColor.CGColor;
    _groupLabel.textColor = GreenColor;
    _groupLabel.font = [UIFont systemFontOfSize:12];
    _groupLabel.textAlignment = NSTextAlignmentCenter;
    _groupLabel.layer.cornerRadius = 2;
    _groupLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSingle)];
    [_groupLabel addGestureRecognizer:tap];
    [self.contentView addSubview:_groupLabel];
    
    _directionImageView = [UIImageView new];
    _directionImageView.image = [UIImage imageNamed:@"Mine_Right_direct"];
    [self.contentView addSubview:_directionImageView];
}

-(void)layoutUI {
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(24);
        make.width.height.mas_equalTo(60);
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_top).offset(7);
        make.left.equalTo(self.headerImageView.mas_right).offset(16);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(24);
    }];

    [_groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.headerImageView.mas_bottom).offset(-3);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(44);
    }];

    [_directionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.centerY.equalTo(self.headerImageView.mas_centerY);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
}

//更新用户信息
-(void)updateUI {
    BBMineHeaderBeanModel * model = (BBMineHeaderBeanModel *)self.beanModel;
    
    _headerImageView.image = [UIImage imageNamed:model.headerUrl];
    _nameLabel.text = model.name;
    
    if (model.type == single) {
        self.groupLabel.text = @"个人";
    }else if (model.type == applying){
        self.groupLabel.text = @"申请中";
    }else if (model.type == noPass){
        self.groupLabel.text = @"未通过";
    }else if (model.type == forbidden){
        self.groupLabel.text = @"禁用";
    }else {
        self.groupLabel.text = @"团队";
    }
}

-(void)tapSingle {
    if ( [self.groupLabel.text isEqualToString: @"个人"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMineTag" object:@{@"group":@"single"}];
    } else if ( [self.groupLabel.text isEqualToString: @"团队"]) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMineTag" object:@{@"group":@"group"}];
    }else if ( [self.groupLabel.text isEqualToString: @"申请中"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMineTag" object:@{@"group":@"applying"}];
    }else if ( [self.groupLabel.text isEqualToString: @"未通过"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapMineTag" object:@{@"group":@"noPass"}];
    }
}
@end
