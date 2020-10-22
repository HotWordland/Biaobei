//
//  UIView+Factory_hzj.h
//  FitnessCoachCenter
//
//  Created by zhrt on 2019/7/5.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Factory_hzj)

+(UILabel *)LableText:(NSString *)str textColor:(UIColor *)color textFont:(UIFont*)textFont;
+ (UIButton *)ButtonText:(NSString *)text textColor:(UIColor *)textColor textFont:(UIFont *)font backGroundColor:(UIColor *)color trail:(id)trail action:(SEL)action tag:(NSInteger)tag ;
+ (UITextField *)TextFieldPlaceholder:(NSString *)placeholder textColor:(UIColor *)color textFont:(UIFont *)font;
+ (UIImageView *)ImageViewImageName:(NSString *)imageStr;
+ (UIView *)ViewView;

@end

NS_ASSUME_NONNULL_END
