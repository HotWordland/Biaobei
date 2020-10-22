//
//  BBRequestManager.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/11.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBRequestManager.h"
#import "BBNetWorkManager.h"
#import "BBLoginViewController.h"

@interface BBRequestManager()

@property (nonatomic, strong) BBNetWorkManager *netWorkManager;

@end

@implementation BBRequestManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static BBRequestManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BBRequestManager alloc] init];
    });
    return sharedInstance;
}

-(BBNetWorkManager *)netWorkManager{
    if (!_netWorkManager) {
        _netWorkManager = [BBNetWorkManager shared];
    }
    return _netWorkManager;
}


//获取短信验证码
-(void)getSMSCodeWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager form_postWithUrl:SMSCode withParameters:params suceess:^(id _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//手机验证码登录
-(void)mobileLoginWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager form_postWithUrl:MobileLogin withParameters:params suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
        BBLoginModel *model = [[BBLoginModel alloc]initWithDictionary:dataDic error:nil];
        success(information,model);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//刷新token
-(void)refreshTokenWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager form_postWithUrl:RefreshToken withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//获取用户信息
-(void)getMyInfoWithSuccess:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:GetMyInfo withParameters:@{} suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
        BBUserInfoModel *model = [[BBUserInfoModel alloc]initWithDictionary:dataDic error:nil];
        success(information,model);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//修改手机号
-(void)updateUserMobileWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager form_postWithUrl:UpdateUserMobile withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//更新用户信息
-(void)userUpdateWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:UserUpdate withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//创建团队
-(void)createTeamWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:CreateTeam withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//获取个人的团队身份信息
-(void)getTeamNumberInfoWithSuccess:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:TeamNumberInfo withParameters:@{} suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//成员列表
-(void)getTeamPlayerListWithStatus:(NSString *)status params:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    NSString *fullUrl = [NSString stringWithFormat:@"%@/%@",TeamPlayerList,status];
    [self.netWorkManager postWithUrl:fullUrl withParameters:params suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
        BBGroupTeamerModel *model = [[BBGroupTeamerModel alloc]initWithDictionary:dataDic error:nil];
        success(information, model);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}



//团队搜索
-(void)searchTeamWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:SearchTeam withParameters:params suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
        BBSearchGroupModel *model = [[BBSearchGroupModel alloc]initWithDictionary:dataDic error:nil];
        success(information,model);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//申请加入团队
-(void)joinTeamWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:JoinTeam withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//修改团队成员状态
-(void)updateTeamplayerWithStatus:(NSString *)status params:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    NSString *fullUrl = [NSString stringWithFormat:@"%@/%@",UpdateTeamplayer,status];
    [self.netWorkManager postWithUrl:fullUrl withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//获取团队信息
-(void)getTeamInfoWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:GetTeamInfo withParameters:params suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
        BBGroupInfoModel *model = [[BBGroupInfoModel alloc]initWithDictionary:dataDic error:nil];
        success(information,model);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}
//获取未通过团队信息
- (void)getTeamNotPassInfoWithsuccess:(void (^)(id _Nonnull, JSONModel * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure {
    [self.netWorkManager postWithUrl:kGetTeamNotPass withParameters:@{} suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
        BBGroupInfoModel *model = [[BBGroupInfoModel alloc]initWithDictionary:dataDic error:nil];
        success(information,model);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}
//再次提交团队信息
- (void)upDataTeamInfoWithParams:(NSDictionary *)params success:(void (^)(id _Nonnull, JSONModel * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure {
    [self.netWorkManager postWithUrl:kUpdataTeamDetail withParameters:params suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
//        BBGroupInfoModel *model = [[BBGroupInfoModel alloc]initWithDictionary:dataDic error:nil];
        success(dataDic,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}
//取消团队申请
- (void)cancleTeamInfoWithParams:(NSDictionary *)params success:(void (^)(id _Nonnull, JSONModel * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure {
    [self.netWorkManager postWithUrl:kCancelTeam withParameters:params suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
        //        BBGroupInfoModel *model = [[BBGroupInfoModel alloc]initWithDictionary:dataDic error:nil];
        success(dataDic,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//任务列表
-(void)getTaskListWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:GetTaskList withParameters:params suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
        BBHomeTaskListModel *model = [[BBHomeTaskListModel alloc]initWithDictionary:dataDic error:nil];
        success(information,model);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//任务详情
-(void)getTaskDetailWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:GetTaskDetail withParameters:params suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
        BBTaskDetailModel *model = [[BBTaskDetailModel alloc]initWithDictionary:dataDic error:nil];
        success(information,model);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//任务说明
-(void)getTaskDetailNoteWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:TaskDetailNote withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//领取任务
-(void)receiveTaskWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:ReceiveTask withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//填写采集人信息
-(void)setCollectTaskUserinfoWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:CollectTaskUserinfo withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

///获取采集文本信息
-(void)getTaskAudioTextWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:TaskAudioText withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//用户任务列表
-(void)getUserTaskListWithStatus:(NSString *)status params:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    NSString *fullUrl = [NSString stringWithFormat:@"%@/%@",UserTaskList,status];
    [self.netWorkManager postWithUrl:fullUrl withParameters:params suceess:^(id  _Nonnull information) {
        NSDictionary *dataDic = information[@"data"];
        BBHomeTaskListModel *model = [[BBHomeTaskListModel alloc]initWithDictionary:dataDic error:nil];
        success(information,model);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//用户上传录音（修改录音）
-(void)uploadUserTaskWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:UploadUserTask withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//质检中修改音频列表
-(void)getAudioTaskListWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:AudioTaskList withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//用户吐槽
-(void)postUserCommentWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:UserComment withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//获取oss授权
-(void)getOssTokenWithSuccess:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:GetOssToken withParameters:@{} suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//获取dataCode
-(void)getOldDataCodeWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:GetOldDataCode withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//获取未通过音频列表
-(void)getNopassListWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:NopassList withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

//用户重录后重新上传音频
-(void)updateAudioWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure{
    [self.netWorkManager postWithUrl:UpdateAudio withParameters:params suceess:^(id  _Nonnull information) {
        success(information,nil);
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}

@end
