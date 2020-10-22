//
//  BBMineHeaderBeanModel.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    single = 0,
    group,
    applying,  //申请中
    noPass,
    forbidden   //禁用
} GroupType;

@interface BBMineHeaderBeanModel : BaseBeanModel
@property (nonatomic, strong) NSString<Optional> * headerUrl;
@property (nonatomic, strong) NSString<Optional> * name;
@property (nonatomic, assign) GroupType type;
@end

NS_ASSUME_NONNULL_END
