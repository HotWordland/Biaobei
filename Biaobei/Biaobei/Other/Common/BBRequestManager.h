//
//  BBRequestManager.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/11.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "BBUserInfoModel.h"
#import "BBSearchGroupModel.h"
#import "BBHomeTaskListModel.h"
#import "BBGroupTeamerModel.h"

//获取短信验证码
#define SMSCode @"/code/sms"
//手机验证码登录
#define MobileLogin @"/authentication/mobile"
//刷新token
#define RefreshToken @"/refresh/Token"
//获取用户信息
#define GetMyInfo @"/user/me"
//修改手机号
#define UpdateUserMobile @"/user/updateUserMobile"
//更新用户信息
#define UserUpdate @"/user/update"
//创建团队
#define CreateTeam @"/team/create"
//获取个人的团队身份信息
#define TeamNumberInfo @"/team/numberInfo"
//成员列表
#define TeamPlayerList @"/team/teamplayer/list"
//团队搜索
#define SearchTeam @"/team/search"
//申请加入团队
#define JoinTeam @"/team/join"
//修改团队成员状态
#define UpdateTeamplayer @"/team/updateteamplayer"
//获取团队信息
#define GetTeamInfo @"/team/information"
//任务列表
#define GetTaskList @"/task/list"
//任务详情
#define GetTaskDetail @"/task/details"
//任务说明
#define TaskDetailNote @"/task/details/note"
//领取任务
#define ReceiveTask @"/task/receive"
//填写采集人信息
#define CollectTaskUserinfo @"/task/collect/userinfo"
//获取采集文本信息
#define TaskAudioText @"/task/audio/text"
//用户任务列表
#define UserTaskList @"/task/user/list"
//用户上传录音（修改录音）
#define UploadUserTask @"/task/user/upload"
//质检中修改音频列表
#define AudioTaskList @"/task/audio/list"
//用户吐槽
#define UserComment @"/user/comment"
//获取oss授权
#define GetOssToken @"/oss/getToken"
//获取dataCode
#define GetOldDataCode @"/task/get/dataCode"
//获取未通过音频列表
#define NopassList @"/task/audio/nopass/list"
//用户重录后重新上传音频
#define UpdateAudio @"/task/update/audio" 
//获取未通过团队信息
#define kGetTeamNotPass @"/team/informationByUserId"
//更新团队信息
#define kUpdataTeamDetail @"/team/update"
//取消团队申请
#define kCancelTeam @"/team/cancel"

NS_ASSUME_NONNULL_BEGIN

@interface BBRequestManager : NSObject

+(instancetype)sharedInstance;

//获取短信验证码
-(void)getSMSCodeWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//手机验证码登录
-(void)mobileLoginWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//刷新token
-(void)refreshTokenWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//获取用户信息
-(void)getMyInfoWithSuccess:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//修改手机号
-(void)updateUserMobileWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//更新用户信息
-(void)userUpdateWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//创建团队
-(void)createTeamWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//获取个人的团队身份信息
-(void)getTeamNumberInfoWithSuccess:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//成员列表
-(void)getTeamPlayerListWithStatus:(NSString *)status params:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;


//团队搜索
-(void)searchTeamWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//申请加入团队
-(void)joinTeamWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//修改团队成员状态
-(void)updateTeamplayerWithStatus:(NSString *)status params:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//获取团队信息
-(void)getTeamInfoWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//获取未通过审核的团队
-(void)getTeamNotPassInfoWithsuccess:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;
//再次申请
-(void)upDataTeamInfoWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;
//取消团队申请
-(void)cancleTeamInfoWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//任务列表
-(void)getTaskListWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//任务详情
-(void)getTaskDetailWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//任务说明
-(void)getTaskDetailNoteWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//领取任务
-(void)receiveTaskWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//填写采集人信息
-(void)setCollectTaskUserinfoWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//获取采集文本信息
-(void)getTaskAudioTextWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//用户任务列表
-(void)getUserTaskListWithStatus:(NSString *)status params:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//用户上传录音（修改录音）
-(void)uploadUserTaskWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//质检中修改音频列表
-(void)getAudioTaskListWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//用户吐槽
-(void)postUserCommentWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//获取oss授权
-(void)getOssTokenWithSuccess:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//获取dataCode
-(void)getOldDataCodeWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//获取未通过音频列表
-(void)getNopassListWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

//用户重录后重新上传音频
-(void)updateAudioWithParams:(NSDictionary *)params success:(void(^)(id responseObject, JSONModel *model))success failure:(void(^)(NSString *error))failure;

@end

NS_ASSUME_NONNULL_END
