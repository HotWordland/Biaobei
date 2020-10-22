//
//  BBBanerCollectionViewCell.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBBanerCollectionViewCell.h"
#import "BBHomeBannerBeanModel.h"

@interface BBBanerCollectionViewCell()
@property(nonatomic,strong) UIView * underView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * summaryLabel;
@end

@implementation BBBanerCollectionViewCell
-(void)prepareUI {
    _underView = [UIView new];
    _underView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_underView];
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.textColor = [UIColor blackColor];
    [_underView addSubview:_titleLabel];
    _summaryLabel = [UILabel new];
    _summaryLabel.font = [UIFont systemFontOfSize:14];
    _summaryLabel.textColor = [UIColor blackColor];
    [_underView addSubview:_summaryLabel];
}

-(void)layoutUI {
    [_underView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];

    [_summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(14);
    }];
}

-(void)updateUI {
    BBHomeBannerBeanModel * model = (BBHomeBannerBeanModel *)self.beanModel;
    _titleLabel.text = model.title;
    _summaryLabel.text = model.summary;
}
@end
