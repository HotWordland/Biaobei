//
//  UIView+Factory_hzj.m
//  FitnessCoachCenter
//
//  Created by zhrt on 2019/7/5.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import "UIView+Factory_hzj.h"

@implementation UIView (Factory_hzj)
+ (UILabel *)LableText:(NSString *)str textColor:(UIColor *)color textFont:(UIFont *)textFont {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = str;
    label.textColor = color;
    label.font = textFont;
    return label;
}
+ (UIButton *)ButtonText:(NSString *)text textColor:(UIColor *)textColor textFont:(UIFont *)font backGroundColor:(UIColor *)color trail:(id)trail action:(SEL)action tag:(NSInteger)tag{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.backgroundColor = color;
    [btn addTarget:trail action:action forControlEvents:UIControlEventTouchUpInside];
    if (tag) {
          btn.tag = tag;
    }
  
    return btn;
}
+ (UIImageView *)ImageViewImageName:(NSString *)imageStr{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = kImageName(imageStr);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}
+ (UIView *)ViewView{
    return [[UIView alloc] initWithFrame:CGRectZero];
}
+ (UITextField *)TextFieldPlaceholder:(NSString *)placeholder textColor:(UIColor *)color textFont:(UIFont *)font {
    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectZero];
    tf.textColor = color;
    tf.font = font;
    tf.placeholder = placeholder;
//    kTextFieldPlaceholder(tf, placeholder, kFontRegularSize(14), kColor_153);
    return tf;
}
@end
