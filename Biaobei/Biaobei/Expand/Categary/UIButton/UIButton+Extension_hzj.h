//
//  UIButton+Extension_hzj.h
//  FitnessCoachCenter
//
//  Created by ZhijunHu on 2019/7/3.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ImagePosition) {
    ImagePositionLeft = 0,  // 图片在左，文字在右，默认
    ImagePositionRight,     // 图片在右，文字在左
    ImagePositionTop,       // 图片在上，文字在下
    ImagePositionBottom,    // 图片在下，文字在上
};

@interface UIButton (Extension_hzj)

@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

// 设置文字图片位置、文字与图片间距
//- (void)setImagePosition:(ImagePosition)postion spacing:(UIFont *)font;
// 热区修改，负值为扩大，正值为缩小


/**
 设置图片在左
 */
- (void)setImageLeftFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
