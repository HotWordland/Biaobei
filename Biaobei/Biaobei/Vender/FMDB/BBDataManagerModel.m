//
//  BBDataManagerModel.m
//  Biaobei
//
//  Created by 胡志军 on 2019/10/22.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "BBDataManagerModel.h"

@implementation BBDataManagerModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
- (NSString *)userId {
    return kAppCacheInfo.userId?kAppCacheInfo.userId:@"11";
}
@end
