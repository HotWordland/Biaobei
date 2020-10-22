//
//  UIFactory.m
//  FitnessCoachCenter
//
//  Created by zhrt on 2019/7/5.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import "UIFactory.h"
#import "UIButton+Extension_hzj.h"
@implementation UIFactory
+(UITextField *)createTF:(CGRect)frame hint:(NSString *)hintStr textColor:(UIColor *)color textFont:(UIFont *)font left:(NSString *)picStr  {
    UITextField * tf = [[UITextField alloc] initWithFrame:frame];
    tf.font = font;
    tf.textColor = color;
//    kTextFieldPlaceholder(tf, hintStr, kFontRegularSize(14), kColor_153);
    tf.placeholder = hintStr;

    
    if (picStr) {
        
        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , 45 , frame.size.height )];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, frame.size.height/2 - 25 * (16 / 21.0) /2, 16, 25 * (16 / 21.0))];
        imageView.image = [UIImage imageNamed:picStr];
        [leftView addSubview:imageView];
        tf.leftView = leftView;
        tf.leftViewMode = UITextFieldViewModeAlways;
    }else{
        //        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10 )];
        //        tf.leftView = leftView;
        //        tf.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return tf;
}
+ (UIButton *)createBtn:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textFont:(UIFont *)font backGroundColor:(UIColor *)color trail:(id)trail action:(SEL)action tag:(NSInteger)tag isRaduis:(BOOL)isRaduis{
    UIButton * btn =[[UIButton alloc] initWithFrame:frame];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    btn.titleLabel.font = font;

    if (trail) {
        [btn addTarget:trail action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (isRaduis) {
        kViewRadius(btn, frame.size.height/2);//设置圆角按钮
    }
    if (tag) {
        btn.tag = tag;
    }
    return btn;
}
+ (UILabel *)createLab:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColot textFont:(UIFont *)textFont textAlignment:(NSTextAlignment )textAlignment{
    UILabel * lab = [[UILabel alloc] initWithFrame:frame];
    lab.textColor = textColot;
    lab.text = text;
    if (textAlignment ) {
        lab.textAlignment = textAlignment;
        
    }
    lab.font = textFont;
    
    return lab;
}
+ (UIImageView *)createImageView:(CGRect)frame image:(NSString *)imageStr isRaduis:(BOOL)isRaduis {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    if (imageStr) {
        imageView.image = kImageName(imageStr);
        
    }
    if (isRaduis) {
        kViewRadius(imageView, frame.size.height/2);
    }
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    return imageView;
}
+ (UIView *)createView:(CGRect)frame{
    UIView * view = [[UIView alloc] initWithFrame:frame];
    return view;
}
+ (UIBarButtonItem *)createItemPicStr:(NSString *)picStr isPic:(BOOL)isPic titleColor:(UIColor *)color block:(MHButtonActionCallBack)block{
    if (!isPic) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 17)];
        [btn setTitle:picStr forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:color forState:UIControlStateNormal];
        btn.hitTestEdgeInsets =  UIEdgeInsetsMake(-10, -10, -10, -10);

        [btn addMHClickAction:block];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView: btn];
        
        return item;
        
    }else{
        
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [btn setImage:[UIImage imageNamed:picStr] forState:UIControlStateNormal];
        btn.hitTestEdgeInsets =  UIEdgeInsetsMake(-10, -10, -10, -10);
  
        [btn addMHClickAction:block];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView: btn];
        return item;
    }
    
}
@end
