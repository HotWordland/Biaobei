//
//  BBMineDetailBeanModel.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineDetailBeanModel.h"

@implementation BBMineDetailBeanModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{
                                                                 @"rec_id":@"id"
                                                                 }];
}

@end
