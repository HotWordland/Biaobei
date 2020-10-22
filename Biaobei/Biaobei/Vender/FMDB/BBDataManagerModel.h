//
//  BBDataManagerModel.h
//  Biaobei
//
//  Created by 胡志军 on 2019/10/22.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN
/*
 数据库表  字段名说明
 user_id 用户id  task_id 任务id  subTask_id  子任务id  subTask_text 子任务文本
 subTask_localFile 子任务本地文件  subTask_url  子任务服务器地址
 //一下是用来做扩展用的
 sub_extension_one  sub_extension_two  sub_extension_tree
 */
@interface BBDataManagerModel : JSONModel
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * taskId;
@property (nonatomic, strong) NSString * subTaskId;
@property (nonatomic, strong) NSString * subTaskText;
@property (nonatomic, strong) NSString * subTaskLocalFile;
@property (nonatomic, strong) NSString * subTaskUrl;
//扩展字段
@property (nonatomic, strong) NSString * subExtensionOne;
@property (nonatomic, strong) NSString * subExtensionTwo;
@property (nonatomic, strong) NSString * subExtensionTree;


@end

NS_ASSUME_NONNULL_END
