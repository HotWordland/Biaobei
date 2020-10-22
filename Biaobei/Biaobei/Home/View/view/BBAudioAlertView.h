//
//  BBAudioAlertView.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/17.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    AlertTypeSaveFail,
    AlertTypeSaveSuccess,
    AlertTypeUpLoading,
    AlertTypeUpLoadSuccess,
} AudioAlertType;

typedef void(^AlertBtnSelect)(NSInteger index);

@interface BBAudioAlertView : UIView

@property (nonatomic, copy) AlertBtnSelect btnSelect;
@property (nonatomic, strong) MLLabel *titleLabel;


-(instancetype)initWithWhiteFrame:(CGRect)frame AudioAlertType:(AudioAlertType)alertType alertTitle:(NSString *)title highLightStr:(NSString *)highLightStr;

-(instancetype)initWithWhiteFrame:(CGRect)frame alertImage:(UIImage *)image alertTitle:(NSString *)title highLightStr:(NSString *)highLightStr leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle;

@end

NS_ASSUME_NONNULL_END
