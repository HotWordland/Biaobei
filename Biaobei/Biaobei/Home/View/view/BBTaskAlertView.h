//
//  BBTaskAlertView.h
//  Biaobei
//
//  Created by 胡志军 on 2019/10/20.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 接受任务提示 
 */
@interface BBTaskAlertView : UIView
@property (nonatomic, copy)void(^aggreBtnDidClock)(void);
@property (nonatomic, copy)void(^procolBtnDidClock)(void);

@end

NS_ASSUME_NONNULL_END
