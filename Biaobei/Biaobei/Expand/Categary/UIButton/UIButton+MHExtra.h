//
//  UIButton+MHExtra.h
//  FitnessCoachCenter
//
//  Created by zhrt on 2019/7/6.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MHButtonActionCallBack)(UIButton *button);

@interface UIButton (MHExtra)
/**
 *  @brief replace the method 'addTarget:forControlEvents:'
 */
- (void)addMHCallBackAction:(MHButtonActionCallBack)callBack forControlEvents:(UIControlEvents)controlEvents;

/**
 *  @brief replace the method 'addTarget:forControlEvents:UIControlEventTouchUpInside'
 *  the property 'alpha' being 0.5 while 'UIControlEventTouchUpInside'
 */
- (void)addMHClickAction:(MHButtonActionCallBack)callBack;
@end

NS_ASSUME_NONNULL_END
