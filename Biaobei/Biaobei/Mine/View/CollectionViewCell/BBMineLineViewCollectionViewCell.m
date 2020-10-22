//
//  BBMineLineViewCollectionViewCell.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineLineViewCollectionViewCell.h"

@interface BBMineLineViewCollectionViewCell()
@property(nonatomic,strong) UIView * lineView;

@end

@implementation BBMineLineViewCollectionViewCell

-(void)prepareUI {
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
    [self.contentView addSubview:_lineView];
}

-(void)layoutUI {
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

@end
