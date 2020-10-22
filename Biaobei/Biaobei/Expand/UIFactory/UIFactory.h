//
//  UIFactory.h
//  FitnessCoachCenter
//
//  Created by zhrt on 2019/7/5.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIButton+MHExtra.h"
/**UI工厂类*/
@interface UIFactory : NSObject

/**
 创建一个 UITextFIELD
 
 @param frame 位置
 @param hintStr 提示字符串
 @param color 背景颜色
 @param font 字体大小
 @param picStr 左边提示图片 可以为空
 @return UITextField
 */
+ (UITextField *)createTF:(CGRect)frame hint:(NSString *)hintStr textColor:(UIColor *)color textFont:(UIFont *)font left:(NSString *)picStr;

+ (UIView *)createView:(CGRect)frame;

+ (UIButton *)createBtn:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textFont:(UIFont *)font backGroundColor:(UIColor *)color trail:(id)trail action:(SEL)action tag:(NSInteger)tag isRaduis:(BOOL)isRaduis;

+ (UILabel *)createLab:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColot textFont:(UIFont *)textFont textAlignment:(NSTextAlignment)textAlignment;

+ (UIImageView *)createImageView:(CGRect)frame image:(NSString *)imageStr  isRaduis:(BOOL)isRaduis;

/**
 创建一个baritem
 
 @param picStr 图片名字 或者 字符串
 @param isPic 是否是图片字符串
 @param block 点击事件
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *)createItemPicStr:(NSString *)picStr isPic:(BOOL )isPic titleColor:(UIColor *)color block:(MHButtonActionCallBack)block;
@end


