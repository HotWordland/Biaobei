//
//  BBMineDetailListBeanModel.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"
#import "BBMineDetailBeanModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol BBMineDetailBeanModel <NSObject>

@end

@interface BBMineDetailListBeanModel : BaseBeanModel
@property (nonatomic, strong) NSArray <BBMineDetailBeanModel *> * detailArray;
@end

NS_ASSUME_NONNULL_END
