//
//  AppCacheInfo.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/17.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppCacheInfo : NSObject

//单例对象
+ (instancetype)sharedInstance;
//清除一些保存信息
- (void)clearSomeUserDefaultsData;

@property (nonatomic, copy) NSString *token;//token
@property (nonatomic, copy) NSString *refresh_token;
@property (nonatomic, copy) NSString *userId;//userId
@property (nonatomic, copy) NSString *teamId; //teamId
@property (nonatomic, copy) NSString *phoneNum;//用户手机号

@property (nonatomic, copy) NSString *userName; //用户名
@property (nonatomic, copy) NSString *headImage; //头像
@property (nonatomic, copy) NSString *teamStatus; //0 个人 1 申请中 2 审核未通过 3 拒绝 4 团队
@property (nonatomic, copy) NSString *sex; //性别  1男 0女
@property (nonatomic, copy) NSString *age; //年龄
@property (nonatomic, copy) NSString *nativePlace; //籍贯

@property (nonatomic, assign) BOOL firstOpen; //第一次打开  引导页

@property (nonatomic, copy) NSDictionary *dataCodeDic;  // taskId:datacode
@property (nonatomic, copy) NSDictionary *user_dataCodeDic;  // userId:dataCodeDic
//配置 userId taskId dataCode数据对应
-(void)configUser_dataCodeDicWithTaskId:(NSString *)task_id dataCode:(NSString *)dataCode;

@property (nonatomic, copy) NSDictionary *local_taskURLDic;  //每个任务下录制的本地url们
@property (nonatomic, copy) NSDictionary *taskURLDic;  //每个任务下录制的url们
@property (nonatomic, copy) NSDictionary *taskNumDic; //taskId:任务总数
@property (nonatomic, copy) NSDictionary *taskRecDic;  //任务 taskId:@"1" 已录制条数
@property (nonatomic, copy) NSDictionary *user_taskRecDic; //用户任务表
//    NSDictionary *dic = @{
//                          @"user_id1":@{
//                                            @"task_id1":@"0"
//                                            @"task_id2":@"2"
//                                            },
//                          @"user_id2":@{
//                                            @"task_id1":@"1"
//                                            @"task_id2":@"1"
//                                            },
//                          };
//根据task_id获取用户已录制的条数
-(NSInteger)getUserRecCountWithTaskId:(NSString *)task_id;

//配置用户任务完成条数表
-(void)configUser_taskRecDicWithTaskId:(NSString *)task_id recCount:(int)recCount;


@end

NS_ASSUME_NONNULL_END
