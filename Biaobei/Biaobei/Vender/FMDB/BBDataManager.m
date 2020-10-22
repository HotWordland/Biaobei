//
//  BBDataManager.m
//  Biaobei
//
//  Created by 胡志军 on 2019/10/22.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "BBDataManager.h"
#import <FMDB/FMDB.h>

//表名
#define BBDataManagerTableName @"T_BBDataManager"
//数据库名字
#define BBDataManagerDataName [NSString stringWithFormat:@"%@.sqlite",BBDataManagerTableName]
/*
 数据库表  字段名说明
 user_id 用户id  task_id 任务id  subTask_id  子任务id  subTask_text 子任务文本
 subTask_localFile 子任务本地文件  subTask_url  子任务服务器地址
 //一下是用来做扩展用的
 sub_extension_one  sub_extension_two  sub_extension_tree
 */
static NSString * t_id = @"t_id";

static NSString * user_id = @"user_id";
static NSString * task_id = @"task_id";
static NSString * subTask_id = @"subTask_id";
static NSString * subTask_text = @"subTask_text";
static NSString * subTask_localFile = @"subTask_localFile";
static NSString * subTask_url = @"subTask_url";

static NSString * sub_extension_one = @"sub_extension_one";
static NSString * sub_extension_two = @"sub_extension_two";
static NSString * sub_extension_tree = @"sub_extension_tree";


@interface BBDataManager ()
//路径
@property (nonatomic, copy)   NSString * dbPath;
//数据库
@property (nonatomic, strong) FMDatabase * database;
@property (nonatomic, strong) NSString * userID;//用户ID
@property (nonatomic, strong) NSString * tid;//唯一标识符
@end
@implementation BBDataManager

//数据库单例 防止多次创建表
+ (instancetype)shareInstance {
    
    static BBDataManager * manager;
    static dispatch_once_t tkon;
    dispatch_once(&tkon, ^{
        manager = [[BBDataManager alloc] init];
    });
    return manager;
}
//创建一个表
- (instancetype)init {
    if (self = [super init]) {
        self.database = [FMDatabase databaseWithPath:self.dbPath];
        
        if ([self.database open]) {

/*
    数据库表  字段名说明
 user_id 用户id  task_id 任务id  subTask_id  子任务id  subTask_text 子任务文本
 subTask_localFile 子任务本地文件  subTask_url  子任务服务器地址
 //一下是用来做扩展用的
 sub_extension_one  sub_extension_two  sub_extension_tree
 */
            NSString * createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ text PRIMARY KEY NOT NULL,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text,%@ text)", BBDataManagerTableName,t_id,user_id,task_id,subTask_id,subTask_text, subTask_localFile, subTask_url, sub_extension_one, sub_extension_two, sub_extension_tree];
            if (![self.database executeUpdate:createTableSQL]) {
                NSLog(@"建表失败");
            }
            [self.database close];
        }else {
            NSLog(@"数据库打开失败");
        }
    }
    return self;
}
#pragma mark --更新数据
- (BOOL)insertToDataBaseWithTaskID:(NSString *)taskID subTaskID:(NSString *)subTaskID subTaskText:(NSString *)subTaskText {
    if([self getSubTaskWithTaskID:taskID subTaskID:subTaskID]){
        return YES;
    }
    if ([self.database open]) {
        
        NSString * inserSQL = [NSString stringWithFormat:@"INSERT INTO %@(%@,%@,%@,%@,%@) VALUES (?,?, ?, ?, ?)",BBDataManagerTableName,t_id,user_id, task_id, subTask_id, subTask_text];
        BOOL re = [self.database executeUpdate:inserSQL,self.tid,self.userID,taskID,subTaskID, subTaskText];
        [self.database close];
        return re;
        
    }else {
        NSLog(@"数据库在插入的时候打开失败");
        return NO;
    }
}
- (BOOL)upDataBaseTaskID:(NSString *)taskID subTaskID:(NSString *)subTaskID localFile:(NSString *)localFile {
    if ([self.database open]) {
        NSString * updataStr =  [NSString stringWithFormat:@"UPDATE %@ SET %@=? WHERE %@=? AND %@=? AND %@=?", BBDataManagerTableName,subTask_localFile,user_id, task_id, subTask_id];
        BOOL re = [self.database executeUpdate:updataStr,localFile,self.userID,taskID,subTaskID];
        [self.database close];
        return re;
        
    }else {
        NSLog(@"更新数据库时打开失败");
        return NO;
    }
}
- (BOOL)upDataBaseTaskID:(NSString *)taskID subTaskID:(NSString *)subTaskID url:(NSString *)url {
    if ([self.database open]) {
      NSString * updataStr =  [NSString stringWithFormat:@"UPDATE %@ SET %@=? WHERE %@=? AND %@=? AND %@=?", BBDataManagerTableName,subTask_url,user_id, task_id, subTask_id];
        BOOL re = [self.database executeUpdate:updataStr,url,self.userID, taskID,subTaskID];
        [self.database close];
        return re;

    }else {
        NSLog(@"更新数据库时打开失败");
        return NO;
    }
}
#pragma mark == 查询数据 ==

//查询指定的任务存在与否
- (BOOL)getTaskWithTaskID:(NSString *)taskID {
    if ([self.database open]) {
        NSString * selectSql = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@=? AND %@=?",BBDataManagerTableName,user_id,task_id];
        FMResultSet *result = [self.database executeQuery:selectSql,self.userID, taskID];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        while ([result next]) {
            NSString *taskId = [result stringForColumn:task_id];
            [array addObject:taskId];
        }
        [self.database close];
        BOOL is = NO;
        if (array.count > 0) {
            is = YES;
        }
        return is;
    } else {
        NSLog(@"在删除的时候， 数据库打开失败");
        return NO;
    }
}

//通过 任务id 查询 所有的子任务
- (NSArray <BBDataManagerModel*> *)getAllSubTaskWithTaskID:(NSString *)taskID{
    if ([self.database open]) {
        NSString * selectSQL = [NSString stringWithFormat:@"SELECT *  FROM %@ WHERE %@=? AND %@=?",BBDataManagerTableName, user_id, task_id];

        FMResultSet * re = [self.database executeQuery:selectSQL,self.userID, taskID];
        NSMutableArray * array = [[NSMutableArray alloc] init];
        
        while ([re next]) {
            BBDataManagerModel * model = [[BBDataManagerModel alloc] init];
            model.taskId = [re stringForColumn:task_id];
             model.subTaskId = [re stringForColumn:subTask_id];
             model.subTaskText = [re stringForColumn:subTask_text];
             model.subTaskUrl = [re stringForColumn:subTask_url];
             model.subTaskLocalFile = [re stringForColumn:subTask_localFile];
            model.subExtensionOne = [re stringForColumn:sub_extension_one];
            model.subExtensionTwo = [re stringForColumn:sub_extension_two];
            model.subExtensionTree = [re stringForColumn:sub_extension_tree];

            [array addObject:model];
        }
        [self.database close];
        
        return array;
        
    }else {
        NSLog(@"数据库在查看时打开出错");
        return nil;
    }
}
////通过 任务id 和 子任务id  查寻 单前的任务
- (BBDataManagerModel *)getSubTaskWithTaskID:(NSString*)taskID subTaskID:(NSString *)subTaskID{
    if ([self.database open]) {
        NSString * selectSQL = [NSString stringWithFormat:@"SELECT *  FROM %@ WHERE %@=? AND %@=? AND %@=?",BBDataManagerTableName, user_id, task_id,subTask_id];
        
        FMResultSet * re = [self.database executeQuery:selectSQL,self.userID, taskID,subTaskID];
        NSMutableArray * array = [[NSMutableArray alloc] init];
        
        while ([re next]) {
            BBDataManagerModel * model = [[BBDataManagerModel alloc] init];
            model.taskId = [re stringForColumn:task_id];
            model.subTaskId = [re stringForColumn:subTask_id];
            model.subTaskText = [re stringForColumn:subTask_text];
            model.subTaskUrl = [re stringForColumn:subTask_url];
            model.subTaskLocalFile = [re stringForColumn:subTask_localFile];
            model.subExtensionOne = [re stringForColumn:sub_extension_one];
            model.subExtensionTwo = [re stringForColumn:sub_extension_two];
            model.subExtensionTree = [re stringForColumn:sub_extension_tree];
            
            [array addObject:model];
        }
        [self.database close];
        if (array.count >0) {
            return array[0];
        }else {
             return nil;
        }
       
        
    }else {
        NSLog(@"数据库在查看时打开出错");
        return nil;
    }
}
//根据任务 查询 所有已录制的任务
- (NSArray <BBDataManagerModel*> *)getSubTaskHaveUrlWithTaskID:(NSString*)taskID{
    NSMutableArray *arr = [NSMutableArray new];
    for (BBDataManagerModel *model in [self getAllSubTaskWithTaskID:taskID]) {
        if ([model.subTaskLocalFile isValidString]) {
            [arr addObject:model];
        }
    }
    return arr;
}
//根据任务 查询 所有任务未录制的任务
- (NSArray <BBDataManagerModel*> *)getSubTaskNotHaveUrlWithTaskID:(NSString*)taskID{
    NSMutableArray *arr = [NSMutableArray new];
    for (BBDataManagerModel *model in [self getAllSubTaskWithTaskID:taskID]) {
        if (![model.subTaskLocalFile isValidString]) {
            [arr addObject:model];
        }
    }
    return arr;
}

//根据任务 查询 所有已上传的 任务
- (NSArray <BBDataManagerModel*> *)getSubTaskHaveUploadUrlWithTaskID:(NSString*)taskID{
    NSMutableArray *arr = [NSMutableArray new];
    for (BBDataManagerModel *model in [self getAllSubTaskWithTaskID:taskID]) {
        if ([model.subTaskUrl isValidString]) {
            [arr addObject:model];
        }
    }
    return arr;
}
//根据任务 查询 所有任务未上传的 任务
- (NSArray <BBDataManagerModel*> *)getSubTaskNotHaveUploadUrlWithTaskID:(NSString*)taskID{
    NSMutableArray *arr = [NSMutableArray new];
    for (BBDataManagerModel *model in [self getAllSubTaskWithTaskID:taskID]) {
        if (![model.subTaskUrl isValidString]) {
            [arr addObject:model];
        }
    }
    return arr;
}

//根据任务id 查询 所有的任务的个数
- (NSInteger)getAllSubTaskCountWithTaskID:(NSString *)taskID{
    return [[self getAllSubTaskWithTaskID:taskID] count];
}
////根据任务 查询 所有已上传的 子任务的个数
- (NSInteger)getAllSubTaskCountWithHaveUrlTaskID:(NSString *)taskID{
     return [[self getSubTaskHaveUrlWithTaskID:taskID] count];
}
////根据任务 查询 所有未上传的 子任务的个数
- (NSInteger)getAllSubTaskCountWithNotHaveUrlTaskID:(NSString *)taskID{
    return [[self getSubTaskNotHaveUrlWithTaskID:taskID] count];
}
//根据任务 查询 所有已上传的 子任务的个数
- (NSInteger)getAllSubTaskCountWithHaveUploadUrlTaskID:(NSString *)taskID{
    return [[self getSubTaskHaveUploadUrlWithTaskID:taskID] count];
}
//根据任务 查询 所有未上传的 子任务的个数
- (NSInteger)getAllSubTaskCountWithNotHaveUploadUrlTaskID:(NSString *)taskID{
    return [[self getSubTaskNotHaveUploadUrlWithTaskID:taskID] count];

}

//成功提交
- (BOOL)hasAllTaskSubmitSuccess:(NSString *)taskID {
    NSInteger subTaskLocalFileCount = [[BBDataManager shareInstance] getAllSubTaskCountWithHaveUrlTaskID:taskID];
    NSInteger subTaskUrlCount = [[BBDataManager shareInstance] getAllSubTaskCountWithHaveUploadUrlTaskID:taskID];
    NSInteger allTaskCount = [[BBDataManager shareInstance] getAllSubTaskCountWithTaskID:taskID];
    if (subTaskLocalFileCount == subTaskUrlCount && subTaskLocalFileCount == allTaskCount) {
        return YES;
    }
    return NO;
}


#pragma mark == 删除 ==

//删除所有任务
- (BOOL)deleteAllTask{
    if ([self.database open]) {
        NSString * deleteSQL = [NSString stringWithFormat: @"DELETE  FROM %@",BBDataManagerTableName];
        BOOL re = [self.database executeUpdate:deleteSQL];
        return  re;
        
    }else {
        NSLog(@"在删除的时候， 数据打开失败");
        return NO;
    }
}
//删除指定任务
- (BOOL)deleteTaskWithTaskID:(NSString *)taskID{
    if ([self.database open]) {
        NSString * deleteSQL = [NSString stringWithFormat: @"DELETE  FROM %@ WHERE %@=? AND %@=?",BBDataManagerTableName,user_id,task_id];
        BOOL re = [self.database executeUpdate:deleteSQL,self.userID, taskID];
        return  re;
        
    }else {
        NSLog(@"在删除的时候， 数据打开失败");
        return NO;
    }
}
////删除指定任务的子任务
- (BOOL)deleteSubTaskWithTaskID:(NSString *)taskID subTaskID:(NSString *)subTaskID{
    if ([self.database open]) {
        NSString * deleteSQL = [NSString stringWithFormat: @"DELETE  FROM %@ WHERE %@=? AND %@=? AND %@=?",BBDataManagerTableName,user_id,task_id, subTask_id];
        BOOL re = [self.database executeUpdate:deleteSQL,self.userID, taskID, subTaskID];
        return  re;
        
    }else {
        NSLog(@"在删除的时候， 数据打开失败");
        return NO;
    }
}

#pragma mark --获取数据库路径
- (NSString *)dbPath {
    if (_dbPath == nil) {
        NSString * libDerPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        _dbPath = [libDerPath stringByAppendingPathComponent:BBDataManagerDataName];
        
    }
    return _dbPath;
}
- (NSString *)tid {
    NSLog(@"------------------->%@",[[NSUUID UUID] UUIDString]);
    return [[NSUUID UUID] UUIDString];
}
- (NSString *)userID {
    return kAppCacheInfo.userId?kAppCacheInfo.userId:@"11";
}

@end
