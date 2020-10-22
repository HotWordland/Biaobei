//
//  BBSearchGroupModel.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/19.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBGroupInfoModel : BaseBeanModel

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *teamLicense;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *teamProfile;
@property (nonatomic, copy) NSString *town;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *createTime;


@end


@protocol BBGroupInfoModel;
@interface BBSearchGroupModel : BaseBeanModel

@property (nonatomic, assign) BOOL hasNextPage; //是否有下一页
@property (nonatomic, copy) NSArray <BBGroupInfoModel>*list;  //搜索结果

@end

NS_ASSUME_NONNULL_END
