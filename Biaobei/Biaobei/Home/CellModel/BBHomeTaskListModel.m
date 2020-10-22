//
//  BBHomeTaskListModel.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/21.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeTaskListModel.h"


@implementation BBHomeTaskModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{
                                                                 @"task_id":@"id"
                                                                 }];
}

@end

@implementation BBHomeTaskListModel

@end

@implementation BBConfigModel

@end

@implementation BBTaskDetailModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{
                                                                 @"task_id":@"id",
                                                                 @"desc":@"description"
                                                                 }];
}

@end
