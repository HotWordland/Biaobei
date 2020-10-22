//
//  BBUserInfoModel.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/17.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBUserInfoModel.h"

@implementation BBUserInfoModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{
                                                                 @"userId":@"id"
                                                                 }];
}

@end
