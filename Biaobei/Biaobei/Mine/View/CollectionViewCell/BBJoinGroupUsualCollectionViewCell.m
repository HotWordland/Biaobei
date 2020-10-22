//
//  BBJoinGroupUsualCollectionViewCell.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBJoinGroupUsualCollectionViewCell.h"
#import "BBMineDetailListBeanModel.h"
#import "BBMineDetailView.h"

@interface BBJoinGroupUsualCollectionViewCell()
@property (nonatomic, strong) UILabel * applyJoinLabel;
@property (nonatomic, strong) UIView * underView;
@end

@implementation BBJoinGroupUsualCollectionViewCell

-(void)prepareUI {
    self.underView = [UIView new];
    self.underView.backgroundColor = [UIColor whiteColor];
    self.underView.layer.masksToBounds = YES;
    self.underView.layer.cornerRadius = 10;
    [self.contentView addSubview:self.underView];

    self.applyJoinLabel = [UILabel new];
    self.applyJoinLabel.text = @"申请加入";
    self.applyJoinLabel.textAlignment = NSTextAlignmentCenter;
    self.applyJoinLabel.textColor = rgba(37, 194, 155, 1);
    self.applyJoinLabel.backgroundColor = rgba(251, 251, 255, 1);
    [self.underView addSubview:self.applyJoinLabel];
}

-(void)layoutUI {
    [self.underView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-12);
    }];

    [self.applyJoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(53);
    }];
}

-(void)updateUI {
    for (UIView * view in self.underView.subviews) {
        if (![view isEqual:self.applyJoinLabel]) {
            [view removeFromSuperview];
        }
    }

    BBMineDetailListBeanModel * beanModel = (BBMineDetailListBeanModel *)self.beanModel;
    BBMineDetailView * detailview = nil;
    for (int i =0; i< beanModel.detailArray.count; i++) {
        BBMineDetailView * view = [[BBMineDetailView alloc]init];
        view.model = beanModel.detailArray[i];
        [_underView addSubview:view];
        if (detailview) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.equalTo(detailview.mas_bottom);
                make.height.equalTo(detailview.mas_height);
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(44);
                make.top.mas_equalTo(17);
            }];
        }
        detailview = view;
    }

}

@end
