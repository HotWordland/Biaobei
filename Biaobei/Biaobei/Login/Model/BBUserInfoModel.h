//
//  BBUserInfoModel.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/17.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBUserInfoModel : BaseBeanModel

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *province;  //籍贯信息
@property (nonatomic, copy) NSString *town;
@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *is_new;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *taskFinishNumber;
@property (nonatomic, copy) NSString *teamStatus; //0 个人 1 申请中 2 审核未通过 3 拒绝 4 团队  5 禁用
@property (nonatomic, copy) NSString *teamIdentity; //身份 =（0 是团队成员  1团队拥有人）
@property (nonatomic, copy) NSString *teamMemberStatus; //0 未审核 1 通过 2拒绝 3移除团队 4 用户取消申请 5 用户退出团队


@end

NS_ASSUME_NONNULL_END
