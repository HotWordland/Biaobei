//
//  BBJoinGroupUsualBeanModel.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"
#import "BBMineDetailBeanModel.h"
#import "BBMineDetailListBeanModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BBJoinGroupUsualBeanModel : BaseBeanModel
@property (nonatomic, strong) NSArray<BBMineDetailBeanModel> * detailArray;
@end

NS_ASSUME_NONNULL_END
