//
//  BBHomeListCollectionViewCell.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeListCollectionViewCell.h"
#import "BBHomeListBeanModel.h"
@interface BBHomeListCollectionViewCell()
@property (nonatomic, strong) UIView * undeView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * summaryLabel;
@property (nonatomic, strong) UILabel * tipLabel;
@property (nonatomic, strong) UIImageView * tipImageView;

@end

@implementation BBHomeListCollectionViewCell

- (void)prepareUI {
    self.contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248.0/255 blue:251.0/255 alpha:1];
    _undeView = [UIView new];
    _undeView.backgroundColor = [UIColor whiteColor];
    _undeView.layer.masksToBounds = YES;
    _undeView.layer.cornerRadius = 6;
    [self.contentView addSubview:_undeView];
    _tipImageView = [UIImageView new];
    [_undeView addSubview:_tipImageView];
    _titleLabel = [UILabel new];
    _titleLabel.font = kFontMediumSize(16);
    _titleLabel.textColor = rgba(51, 57, 76, 1);
    [_undeView addSubview:_titleLabel];
    _summaryLabel = [UILabel new];
    _summaryLabel.font = kFontRegularSize(13);
    _summaryLabel.textColor = rgba(148, 153, 161, 1);
    [_undeView addSubview:_summaryLabel];
    _tipLabel = [UILabel new];
    _tipLabel.font = kFontRegularSize(13);
    _tipLabel.textColor = rgba(148, 153, 161, 1);
    [_undeView addSubview:_tipLabel];
}

-(void)layoutUI {
    [_undeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(4);
        make.bottom.mas_equalTo(-4);
    }];

    [_tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.height.with.mas_equalTo(27);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(19);
    }];

    [_summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        make.height.mas_equalTo(13);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    }];

    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        make.height.mas_equalTo(13);
        make.top.equalTo(self.summaryLabel.mas_bottom).offset(12);
    }];
}

-(void)updateUI {
    BBHomeListBeanModel * model = (BBHomeListBeanModel *)self.beanModel;
    _titleLabel.text = model.title;
    _summaryLabel.text = model.summary;
    _tipLabel.attributedText = model.tipString;
    NSString * imageName= @"";
    switch (model.type) {
        case Urgent:
            imageName = @"Home_needQuickly_english";
            break;

        case Hot:
            imageName = @"Home_hotest_english";
            break;

        case New:
            imageName = @"Home_newest_english";
            break;

        case end:
            imageName = @"Home_end_english";
            break;

        default:
            break;
    }
    self.tipImageView.image = [UIImage imageNamed:imageName];
}

@end
