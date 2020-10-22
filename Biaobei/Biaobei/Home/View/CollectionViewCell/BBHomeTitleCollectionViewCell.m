//
//  BBHomeTitleCollectionViewCell.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeTitleCollectionViewCell.h"
#import "BBHomeTitleBeanModel.h"
@interface BBHomeTitleCollectionViewCell()
@property(nonatomic,strong) UILabel * titleLabel;

@end

@implementation BBHomeTitleCollectionViewCell

- (void)prepareUI {
    _titleLabel = [UILabel new];
    _titleLabel.textColor = BlackColor;
    _titleLabel.font = kFontRegularSize(16);
    [self.contentView addSubview:_titleLabel];
}

-(void)updateUI {
    BBHomeTitleBeanModel * model = (BBHomeTitleBeanModel *)self.beanModel;
    _titleLabel.text = model.title;
    _titleLabel.font = [UIFont systemFontOfSize:model.font];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(16);
        make.left.mas_equalTo(model.leftDistance);  //设计图
//        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(model.topDistance);
        make.height.mas_equalTo(model.font);
    }];
}


@end
