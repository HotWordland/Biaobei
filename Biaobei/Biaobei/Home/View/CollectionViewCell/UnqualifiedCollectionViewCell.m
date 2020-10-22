//
//  UnqualifiedCollectionViewCell.m
//  Biaobei
//
//  Created by 王家辉 on 2019/11/14.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "UnqualifiedCollectionViewCell.h"

@interface UnqualifiedCollectionViewCell ()

@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIImageView *recordedImageView;
@property (nonatomic, strong) UILabel * audioTextLabel;
@end

@implementation UnqualifiedCollectionViewCell

-(void)prepareUI {
  
//    _selectImageView = [UIImageView new];
//    _selectImageView.layer.masksToBounds = YES;
//    _selectImageView.layer.cornerRadius = 30;
//    _selectImageView.image = [UIImage imageNamed:@""];
//    [self.contentView addSubview:_selectImageView];
//
//    _audioTextLabel = [UILabel new];
//    _audioTextLabel.font = [UIFont systemFontOfSize:17];
//    _audioTextLabel.textColor = [UIColor blackColor];
//    [self.contentView addSubview:_audioTextLabel];
//
//    _recordedImageView = [UIImageView new];
//    _recordedImageView.layer.masksToBounds = YES;
//    _recordedImageView.layer.cornerRadius = 30;
//    _recordedImageView.image = [UIImage imageNamed:@""];
//    [self.contentView addSubview:_recordedImageView];
}

-(void)layoutUI {
//    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(24);
//        make.top.mas_equalTo(24);
//        make.width.height.mas_equalTo(60);
//    }];
//
//    [_audioTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerX.equalTo(self.imageView.mas_centerX);
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(16);
////        make.top.equalTo(self.imageView.mas_bottom).offset(8);
//    }];
//
//    [_recordedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.headerImageView.mas_top).offset(7);
////        make.left.equalTo(self.headerImageView.mas_right).offset(16);
//        make.right.mas_equalTo(-40);
//        make.height.mas_equalTo(24);
//    }];
    
    
}

-(void)updateUI {
    //更新录制状态
}

-(void)giveCellModel:(BaseCellModel *)model withBeanModel:(BaseBeanModel *)beanModel {
//    self.cellModel = model;
//    self.beanModel = beanModel;
//    [self updateUI];
}

@end
