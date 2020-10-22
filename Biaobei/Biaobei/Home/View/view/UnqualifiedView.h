//
//  UnqualifiedView.h
//  Biaobei
//
//  Created by 王家辉 on 2019/11/14.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnqualifiedBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnqualifiedView : UIView
@property (nonatomic, strong) UnqualifiedBeanModel<Optional> *model;
@end

NS_ASSUME_NONNULL_END
