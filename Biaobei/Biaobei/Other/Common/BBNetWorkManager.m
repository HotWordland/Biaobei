//
//  BBNetWorkManager.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/7.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBNetWorkManager.h"

#define CurrentToken @"185967ac-0dd8-4a33-935e-d829db800073"
#define CurrentUserId @"201909091928498460000140539200007923"

@interface BBNetWorkManager() {}
@property (nonatomic, strong)  NSString *networkType;

@end

@implementation BBNetWorkManager

+(BBNetWorkManager *)shared {
    static BBNetWorkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BBNetWorkManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
    });
    return manager;
}

-(instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration{
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        self.requestSerializer.timeoutInterval = 10;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain", nil];
    }
    return self;
}

//网络请求 post
- (void)postWithUrl:(NSString *)urlStr withParameters:(NSDictionary *)parameters suceess:(RequestSessionSuccess)suceess failure:(RequestSessionFailure)failure {
    [self.requestSerializer setValue:@"Basic Ymlhb2JlaTpiaWFvYmVpMTIz" forHTTPHeaderField:@"Authorization"];
    [self.requestSerializer setValue:kAppCacheInfo.token forHTTPHeaderField:@"access_token"];
    [self.requestSerializer setValue:kAppCacheInfo.userId forHTTPHeaderField:@"userId"];
//    NSString *token = kAppCacheInfo.token;
//    NSString *userId = kAppCacheInfo.userId;
    
    NSString * url = [NSString stringWithFormat:@"%@%@",RequestBaseUrl,urlStr];
    [self POST:url parameters:parameters progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//           NSLog(@"%@", responseObject);
           NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
           if ([code isEqualToString:@"0"]) {
               suceess(responseObject);
           } else if ([code isEqualToString:@"40013"]){//token失效
               [self refreshTokenAndReRequestWithType:1 Url:urlStr withParameters:parameters suceess:suceess failure:failure];
           } else if ([code isEqualToString:@"40018"]){
               suceess(responseObject);  //任务已被领取
           } else if ([code isEqualToString:@"40019"]){
               suceess(responseObject);  //此项目领取已超过人数上限
           } else if ([code isEqualToString:@"40027"]){
               suceess(responseObject);  //已提交，请勿重复提交
           } else {
               NSString *message = responseObject[@"message"];
               failure(message);
           }
           
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           failure(error.localizedDescription);
       }];

}

//form表单post
-(void)form_postWithUrl:(NSString *)urlStr withParameters:(NSDictionary *)parameters suceess:(RequestSessionSuccess)suceess failure:(RequestSessionFailure)failure{
    [self.requestSerializer setValue:@"Basic Ymlhb2JlaTpiaWFvYmVpMTIz" forHTTPHeaderField:@"Authorization"];
    [self.requestSerializer setValue:kAppCacheInfo.token forHTTPHeaderField:@"access_token"];
    [self.requestSerializer setValue:kAppCacheInfo.userId forHTTPHeaderField:@"userId"];
    NSString * url = [NSString stringWithFormat:@"%@%@",RequestBaseUrl,urlStr];
 
    [self POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSString *key in [parameters allKeys]) {
            NSString *value = [NSString stringWithFormat:@"%@",parameters[key]];
            [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
        }
        
    } progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
           if ([code isEqualToString:@"0"]) {
               suceess(responseObject);
           }else if ([code isEqualToString:@"40013"]){//token失效
               [self refreshTokenAndReRequestWithType:1 Url:urlStr withParameters:parameters suceess:suceess failure:failure];
           }else{
               NSString *message = responseObject[@"message"];
               failure(message);
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           failure(error.localizedDescription);
       }];
}

//type 0 form表单 1正常
-(void)refreshTokenAndReRequestWithType:(int)type Url:(NSString *)urlStr withParameters:(NSDictionary *)parameters suceess:(RequestSessionSuccess)suceess failure:(RequestSessionFailure)failure{
    if (String_IsEmpty(kAppCacheInfo.refresh_token)) {
        kAppCacheInfo.refresh_token = @"";
    }
    NSDictionary *params = @{
                             @"type":@"refresh_token",
                             @"refreshToken":kAppCacheInfo.refresh_token
                             };
    [[BBRequestManager sharedInstance] refreshTokenWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        NSDictionary *dataDic = responseObject[@"data"];
        NSString *token = dataDic[@"access_token"];
        NSString *refresh_token = dataDic[@"refresh_token"];
        
        kAppCacheInfo.token = token;
        kAppCacheInfo.refresh_token = refresh_token;
        
        if (type==0) {
            [self form_postWithUrl:urlStr withParameters:parameters suceess:suceess failure:failure];
        }else{
            [self postWithUrl:urlStr withParameters:parameters suceess:suceess failure:failure];
        }
    } failure:^(NSString * _Nonnull error) {
        [kAppCacheInfo clearSomeUserDefaultsData]; //清空存的一些数据
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shouldLogin" object:nil];
    }];
    
    
}


//dic转为jsonstring，这里进行格式规范，按照H5走
-(NSString *)convertToJsonData:(NSDictionary *) dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

- (void)networkStateMonitorStart {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"暂无网络\n请检查网络设置"];
                [SVProgressHUD dismissWithDelay:2.0];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                _networkType = @"WWAN";  //蜂窝
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
        }
    }];
    [manager startMonitoring];  //启动
}

+ (BOOL)networkReachability {
    BOOL is = NO;
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        return is = YES;
    }
    return NO;
}

- (NSString *)getNetworkType {
    return _networkType;
}

//+ (void)networkNotReachability {
//    BOOL is = [BBNetWorkManager networkReachability];
//    if (!is) {
//        [self showMessage:@"请检查网络连接"];
//        return;
//    }
//}

@end
