//
//  BBTaskSuccessView.h
//  Biaobei
//
//  Created by 胡志军 on 2019/10/20.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBTaskSuccessView : UIView
@property (nonatomic, copy) void(^TaskSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
