//
//  BBMineTipCollectionViewCell.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineTipCollectionViewCell.h"
#import "BBMineTipBeanModel.h"

@interface BBMineTipCollectionViewCell ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * redView;
@end

@implementation BBMineTipCollectionViewCell

-(void)prepareUI {
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    _redView = [UIView new];
    _redView.backgroundColor = [UIColor redColor];
    _redView.layer.masksToBounds = YES;
    _redView.layer.cornerRadius = 4;
    _redView.hidden = NO;
    [self.contentView addSubview:_redView];
}

-(void)layoutUI {
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(43);
        make.top.mas_equalTo(19);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(24);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView.mas_centerX);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(16);
        make.top.equalTo(self.imageView.mas_bottom).offset(8);
    }];

    [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.equalTo(self.imageView.mas_right).offset(11);
        make.width.height.mas_equalTo(8);
    }];
}

-(void)updateUI {
    float usualWidth = (([UIScreen mainScreen].bounds.size.width - 64) - (4 * 42))/3.0;
    BBMineTipDetailBeanModel * model = (BBMineTipDetailBeanModel *)self.beanModel;
    if (model.first) {
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(43);
        }];
    } else {
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(usualWidth/2.0);
        }];
    }
    _titleLabel.text = model.title;
    _imageView.image = [UIImage imageNamed:model.imageName];
    if (model.tip) {
        _redView.hidden = NO;
    } else {
        _redView.hidden = YES;
    }
}

-(void)giveCellModel:(BaseCellModel *)model withBeanModel:(BaseBeanModel *)beanModel {
    self.cellModel = model;
    self.beanModel = beanModel;
    [self updateUI];
}

@end
