//
//  BBMineUsualCollectionViewCell.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineUsualCollectionViewCell.h"
#import "BBMineUsualBeanModel.h"

@interface BBMineUsualCollectionViewCell()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * summaryLabel;
@property (nonatomic, strong) UIImageView * direcInageView;
@end

@implementation BBMineUsualCollectionViewCell

-(void)prepareUI {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    _summaryLabel = [UILabel new];
    _summaryLabel.font = [UIFont systemFontOfSize:16];
    _summaryLabel.textColor = [UIColor grayColor];
    _summaryLabel.textAlignment = NSTextAlignmentRight;
    _summaryLabel.hidden = YES;
    [self.contentView addSubview:_summaryLabel];
    _direcInageView = [UIImageView new];
    _direcInageView.image = [UIImage imageNamed:@"Mine_Right_direct"];
    [self.contentView addSubview:_direcInageView];
}

-(void)layoutUI {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(80);
    }];

    [_summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];

    [_direcInageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(-30);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
}

-(void)updateUI {
    BBMineUsualBeanModel * model = (BBMineUsualBeanModel *)self.beanModel;
    _titleLabel.text = model.title;
    if (model.summary.length > 0) {
        _summaryLabel.text = model.summary;
        _summaryLabel.hidden = NO;
    } else {
        _summaryLabel.text = @"";
        _summaryLabel.hidden = YES;
    }
}
@end
