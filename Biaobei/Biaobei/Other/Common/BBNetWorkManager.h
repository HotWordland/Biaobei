//
//  BBNetWorkManager.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/7.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^RequestSessionSuccess)(id information);
typedef void (^RequestSessionFailure)(NSString *error);

@interface BBNetWorkManager : AFHTTPSessionManager
+(BBNetWorkManager *)shared;

//一般类型post
- (void)postWithUrl:(NSString *)urlStr withParameters:(NSDictionary *)parameters suceess:(RequestSessionSuccess)suceess failure:(RequestSessionFailure)failure;

//form表单post
-(void)form_postWithUrl:(NSString *)urlStr withParameters:(NSDictionary *)parameters suceess:(RequestSessionSuccess)suceess failure:(RequestSessionFailure)failure;

- (void)networkStateMonitorStart;

+ (BOOL)networkReachability;

- (NSString *)getNetworkType;




@end

NS_ASSUME_NONNULL_END
