//
//  BBGroupTeamerModel.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/24.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBGroupTeamerModel.h"

@implementation BBTeamerInfoModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{
                                                                 @"user_id":@"id"
                                                                 }];
}

@end


@implementation BBGroupTeamerModel

@end
