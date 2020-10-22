//
//  UIButton+ImagePosition.h
//  zhanlu
//
//  Created by 王浩田 on 17/3/15.
//  Copyright © 2017年 江涛 齐. All rights reserved.
//

#import <UIKit/UIKit.h>
// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, ButtonImagePositionStyle) {
    ButtonImagePositionStyleTop, // image在上，label在下
    ButtonImagePositionStyleLeft, // image在左，label在右
    ButtonImagePositionStyleBottom, // image在下，label在上
    ButtonImagePositionStyleRight // image在右，label在左
};
//使用需设置button的宽高
@interface UIButton (ImagePosition)
/**
 * 设置button的titleLabel和imageView的布局样式，及间距
 *
 * @param style titleLabel和imageView的布局样式
 * @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithImagePositionStyle:(ButtonImagePositionStyle)style imageTitleSpace:(CGFloat)space;
@end
