//
//  UnqualifiedListBeanModel.h
//  Biaobei
//
//  Created by 王家辉 on 2019/11/14.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "BaseBeanModel.h"
#import "UnqualifiedBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnqualifiedListBeanModel : BaseBeanModel
@property(nonatomic, strong) NSArray <UnqualifiedBeanModel *> * detailArray;
@end

NS_ASSUME_NONNULL_END
