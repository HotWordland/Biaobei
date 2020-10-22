//
//  AudioToastView.h
//  Biaobei
//
//  Created by 王家辉 on 2019/12/10.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OkBlock)(NSInteger index);

@interface AudioToastView : UIView
@property (nonatomic, copy) OkBlock okBlock;
-(instancetype)initWithWhiteFrame:(CGRect)frame
                       alertImage:(UIImage *)image
                       alertTitle:(NSString *)title
                     highLightStr:(NSString *)highLightStr
                     leftBtnTitle:(NSString *)leftBtnTitle
                    rightBtnTitle:(NSString *)rightBtnTitle;

@end

NS_ASSUME_NONNULL_END
