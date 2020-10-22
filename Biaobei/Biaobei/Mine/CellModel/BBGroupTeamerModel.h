//
//  BBGroupTeamerModel.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/24.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBTeamerInfoModel : BaseBeanModel

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *is_new;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *taskFinishNumber;
@property (nonatomic, copy) NSString *teamStatus;
@property (nonatomic, copy) NSString *town;
@property (nonatomic, copy) NSString *updateTime;

@end


@protocol BBTeamerInfoModel;
@interface BBGroupTeamerModel : BaseBeanModel

@property (nonatomic, copy) NSArray <BBTeamerInfoModel> *list;
@property (nonatomic, assign) BOOL hasNextPage;

@end

NS_ASSUME_NONNULL_END
