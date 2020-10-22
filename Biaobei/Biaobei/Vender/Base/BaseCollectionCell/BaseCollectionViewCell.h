//
//  BaseCollectionViewCell.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/25.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) BaseCellModel * cellModel;
@property (nonatomic, strong) BaseBeanModel * beanModel;

/*
 下面三个方法是为了布局统一
 */
//加载UI
-(void)prepareUI;

//UI布局
-(void)layoutUI;

//获得model后只刷新，不做添加
//刷新UI
-(void)updateUI;

//设置数据
-(void)giveCellModel:(BaseCellModel *)model;

@end

NS_ASSUME_NONNULL_END
