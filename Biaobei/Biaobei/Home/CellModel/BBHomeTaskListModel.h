//
//  BBHomeTaskListModel.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/21.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBHomeTaskModel : BaseBeanModel

@property (nonatomic, copy) NSString *collectType;  //采集类型 多人采集相同文本(0) 多人采集不同文本(1)  无文本采集(2）
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *task_id;
@property (nonatomic, copy) NSString *is_express;  //是加急
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *projectPowder;
@property (nonatomic, copy) NSString *projectType;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *systemtime;  //系统时间
@property (nonatomic, copy) NSString *noPowder;  //是否无权限
@property (nonatomic, copy) NSString *status;  //项目审核状态
@property (nonatomic, copy) NSString *total;  //总条数
@property (nonatomic, assign) BOOL is_receive;
@property (nonatomic, assign) NSInteger taskProgress;  //任务进展状态


@end


@protocol BBHomeTaskModel;
@interface BBHomeTaskListModel : BaseBeanModel

@property (nonatomic, assign) BOOL hasNextPage;
@property (nonatomic, copy) NSArray <BBHomeTaskModel>*list;

@end


@interface BBConfigModel : BaseBeanModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *chooseList;

@end


@protocol BBConfigModel;
@interface BBTaskDetailModel : BaseBeanModel

@property (nonatomic, copy) NSString *collectType;
@property (nonatomic, copy) NSString *configListJson;
@property (nonatomic, copy) NSArray <BBConfigModel>*configLists;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *task_id;
@property (nonatomic, assign) BOOL is_express;
@property (nonatomic, copy) NSString *joinnum;
@property (nonatomic, copy) NSString *noiseCap;
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic, copy) NSString *projectPowder;
@property (nonatomic, copy) NSString *projectType;
@property (nonatomic, copy) NSString *receivenum;
@property (nonatomic, copy) NSString *sampleRate;
@property (nonatomic, copy) NSString *soundAu;
@property (nonatomic, copy) NSString *soundChannel;
@property (nonatomic, copy) NSString *soundDepth;
@property (nonatomic, copy) NSString *starttime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *timelimit;


@end


NS_ASSUME_NONNULL_END
