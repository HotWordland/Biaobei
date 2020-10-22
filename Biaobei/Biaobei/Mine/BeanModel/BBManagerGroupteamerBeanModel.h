//
//  BBManagerGroupteamerBeanModel.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBManagerGroupteamerBeanModel : BaseBeanModel
@property (nonatomic, strong) NSString<Optional> * headerUrl;
@property (nonatomic, strong) NSString<Optional> * name;
@property (nonatomic, strong) NSString<Optional> * phonoNumer;
@property (nonatomic, assign) BOOL isMember;

@property (nonatomic, copy)   NSString *index;
@property (nonatomic, copy)   NSString *teamplayerId;

@property (nonatomic, copy)   NSString *sex;

@end

NS_ASSUME_NONNULL_END
