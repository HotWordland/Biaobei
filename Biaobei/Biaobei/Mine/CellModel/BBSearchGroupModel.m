//
//  BBSearchGroupModel.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/19.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBSearchGroupModel.h"

@implementation BBGroupInfoModel

+(JSONKeyMapper *)keyMapper{
    
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{
                                                                 @"group_id":@"id"
                                                                 }];
}

@end

@implementation BBSearchGroupModel

@end
