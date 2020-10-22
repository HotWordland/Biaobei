//
//  ToastView.h
//  Biaobei
//
//  Created by 王家辉 on 2019/11/26.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToastView : UIView
@property (nonatomic, copy) void(^cancelBlock)(void);
@end

NS_ASSUME_NONNULL_END
