//
//  UnqualifiedBeanModel.m
//  Biaobei
//
//  Created by 王家辉 on 2019/11/14.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "UnqualifiedBeanModel.h"

@implementation UnqualifiedBeanModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{ @"rec_id":@"id" }];
}
@end
