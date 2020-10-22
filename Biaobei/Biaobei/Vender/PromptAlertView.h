//
//  PromptAlertView.h
//  FitnessCoachCenter
//
//  Created by ZhijunHu on 2019/7/4.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 提示宽
 默认1.5s
 */
@interface PromptAlertView : UIView


- (instancetype)initWithMessage:(NSString *)message;

+ (instancetype)alertWithMessage:(NSString *)message;
+ (instancetype)alertWithMessage:(NSString *)message successBlock:(void(^)(void))block;

@end

