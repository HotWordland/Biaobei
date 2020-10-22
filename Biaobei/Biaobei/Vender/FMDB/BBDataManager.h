//
//  BBDataManager.h
//  Biaobei
//
//  Created by 胡志军 on 2019/10/22.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <Foundation/Foundation.h>
//数据库 数据模型
#import "BBDataManagerModel.h"
NS_ASSUME_NONNULL_BEGIN

/**
 存储录音数据专用
 */
@interface BBDataManager : NSObject
+ (instancetype)shareInstance;

#pragma mark == 更新数据 ==
//插入一条 子任务
- (BOOL)insertToDataBaseWithTaskID:(NSString *)taskID subTaskID:(NSString *)subTaskID subTaskText:(NSString *)subTaskText;
//根据一个任务id 和 子任务id  更新本地文件
- (BOOL)upDataBaseTaskID:(NSString *)taskID subTaskID:(NSString *)subTaskID localFile:(NSString *)localFile;
//根据一个任务id 和 子任务id  更新本服务器地址
- (BOOL)upDataBaseTaskID:(NSString *)taskID subTaskID:(NSString *)subTaskID url:(NSString *)url;

#pragma mark == 查询数据 ==
//查询指定的任务存在与否
- (BOOL)getTaskWithTaskID:(NSString *)taskID;
//通过 任务id 查询 所有的子任务
- (NSArray <BBDataManagerModel*> *)getAllSubTaskWithTaskID:(NSString *)taskID;
//通过 任务id 和 子任务id  查寻 单前的任务
- (BBDataManagerModel *)getSubTaskWithTaskID:(NSString*)taskID subTaskID:(NSString *)subTaskID;
//根据任务 查询 所有已录制的 任务
- (NSArray <BBDataManagerModel*> *)getSubTaskHaveUrlWithTaskID:(NSString*)taskID;
//根据任务 查询 所有任务未录制的 任务
- (NSArray <BBDataManagerModel*> *)getSubTaskNotHaveUrlWithTaskID:(NSString*)taskID;

//根据任务 查询 所有已上传的 任务
- (NSArray <BBDataManagerModel*> *)getSubTaskHaveUploadUrlWithTaskID:(NSString*)taskID;
//根据任务 查询 所有任务未上传的 任务
- (NSArray <BBDataManagerModel*> *)getSubTaskNotHaveUploadUrlWithTaskID:(NSString*)taskID;

//根据任务id 查询 所有的任务的个数
- (NSInteger)getAllSubTaskCountWithTaskID:(NSString *)taskID;
//根据任务 查询 所有已录制的 子任务的个数
- (NSInteger)getAllSubTaskCountWithHaveUrlTaskID:(NSString *)taskID;
//根据任务 查询 所有未录制的 子任务的个数
- (NSInteger)getAllSubTaskCountWithNotHaveUrlTaskID:(NSString *)taskID;

//根据任务 查询 所有已上传的 子任务的个数
- (NSInteger)getAllSubTaskCountWithHaveUploadUrlTaskID:(NSString *)taskID;
//根据任务 查询 所有未上传的 子任务的个数
- (NSInteger)getAllSubTaskCountWithNotHaveUploadUrlTaskID:(NSString *)taskID;

- (BOOL)hasAllTaskSubmitSuccess:(NSString *)taskID;


#pragma mark == 删除 ==
//删除所有任务 --清除缓存的时候用到
- (BOOL)deleteAllTask;
//删除指定任务
- (BOOL)deleteTaskWithTaskID:(NSString *)taskID;
//删除指定任务的子任务
- (BOOL)deleteSubTaskWithTaskID:(NSString *)taskID subTaskID:(NSString *)subTaskID;


@end

NS_ASSUME_NONNULL_END
