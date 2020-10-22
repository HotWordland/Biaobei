//
//  TaskToastView.h
//  Biaobei
//
//  Created by 王家辉 on 2019/12/9.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskToastView : UIView
@property (nonatomic, copy) void(^taskBlock)(void);
- (instancetype)init:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
