//
//  BBMineDetailView.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMineDetailBeanModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BBMineDetailView : UIView
@property (nonatomic, strong) BBMineDetailBeanModel<Optional> * model;
@end

NS_ASSUME_NONNULL_END
