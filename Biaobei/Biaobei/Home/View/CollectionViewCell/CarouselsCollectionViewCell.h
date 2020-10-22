//
//  CarouselsCollectionViewCell.h
//  Biaobei
//
//  Created by 王家辉 on 2019/11/20.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarouselsCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;  //轮播图片
@property (nonatomic, strong) UIImageView *promptImageView;  //加急
@property (nonatomic, strong) UILabel *titleLabel;  //任务标题
@property (nonatomic, strong) UILabel *typeLabel;  //采集类型

@end

NS_ASSUME_NONNULL_END
