//
//  AppCacheInfo.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/17.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "AppCacheInfo.h"

@implementation AppCacheInfo

@synthesize token = _token;
@synthesize refresh_token = _refresh_token;
@synthesize userId = _userId;
@synthesize teamId = _teamId;
@synthesize userName = _userName;
@synthesize headImage = _headImage;
@synthesize teamStatus = _teamStatus;
@synthesize age = _age;
@synthesize sex = _sex;
@synthesize nativePlace = _nativePlace;
@synthesize phoneNum = _phoneNum;
@synthesize firstOpen = _firstOpen;
@synthesize local_taskURLDic = _local_taskURLDic;
@synthesize taskURLDic = _taskURLDic;
@synthesize dataCodeDic = _dataCodeDic;
@synthesize user_dataCodeDic = _user_dataCodeDic;
@synthesize taskNumDic = _taskNumDic;
@synthesize taskRecDic = _taskRecDic;
@synthesize user_taskRecDic = _user_taskRecDic;

+ (instancetype)sharedInstance {
    static AppCacheInfo * shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AppCacheInfo alloc] init];
    });
    return shareInstance;
}

-(void)setToken:(NSString *)token{
    _token = token;
    if (![_token isValidString]) {
        [kUserDefault removeObjectForKey:@"app_token"];
    }else {
        [kUserDefault setObject:_token forKey:@"app_token"];
    }
    [kUserDefault synchronize];
    
}

- (NSString *)token {
    if (![_token isValidString]) {
        _token = [kUserDefault objectForKey:@"app_token"];
    }
    return _token;
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    if (![_userId isValidString]) {
        [kUserDefault removeObjectForKey:@"app_userId"];
    }else {
        [kUserDefault setObject:_userId forKey:@"app_userId"];
    }
    [kUserDefault synchronize];
}

-(NSString *)userId{
    if (![_userId isValidString]) {
        _userId = [kUserDefault objectForKey:@"app_userId"];
    }
    return _userId;
}

-(void)setTeamId:(NSString *)teamId{
    _teamId = teamId;
    if (![_teamId isValidString]) {
        [kUserDefault removeObjectForKey:@"app_teamId"];
    }else {
        [kUserDefault setObject:_teamId forKey:@"app_teamId"];
    }
    [kUserDefault synchronize];
}

-(NSString *)teamId{
    if (![_teamId isValidString]) {
        _teamId = [kUserDefault objectForKey:@"app_teamId"];
    }
    return _teamId;
}

-(void)setRefresh_token:(NSString *)refresh_token{
    _refresh_token = refresh_token;
    if (![_refresh_token isValidString]) {
        [kUserDefault removeObjectForKey:@"app_refresh_token"];
    }else {
        [kUserDefault setObject:_refresh_token forKey:@"app_refresh_token"];
    }
    [kUserDefault synchronize];
}

-(NSString *)refresh_token{
    if (![_refresh_token isValidString]) {
        _refresh_token = [kUserDefault objectForKey:@"app_refresh_token"];
    }
    return _refresh_token;
}


-(void)setUserName:(NSString *)userName{
    _userName = userName;
    if (![_userName isValidString]) {
        [kUserDefault removeObjectForKey:@"app_userName"];
    }else {
        [kUserDefault setObject:_userName forKey:@"app_userName"];
    }
    [kUserDefault synchronize];
}

-(NSString *)userName{
    if (![_userName isValidString]) {
        _userName = [kUserDefault objectForKey:@"app_userName"];
    }
    return _userName;
}

-(void)setHeadImage:(NSString *)headImage{
    _headImage = headImage;
    if (![_headImage isValidString]) {
        [kUserDefault removeObjectForKey:@"app_headImage"];
    }else {
        [kUserDefault setObject:_headImage forKey:@"app_headImage"];
    }
    [kUserDefault synchronize];
}

-(NSString *)headImage{
    if (![_headImage isValidString]) {
        _headImage = [kUserDefault objectForKey:@"app_headImage"];
    }
    return _headImage;
}

-(void)setTeamStatus:(NSString *)teamStatus{
    _teamStatus = teamStatus;
    if (![_teamStatus isValidString]) {
        [kUserDefault removeObjectForKey:@"app_teamStatus"];
    }else {
        [kUserDefault setObject:_teamStatus forKey:@"app_teamStatus"];
    }
    [kUserDefault synchronize];
}

-(NSString *)teamStatus{
    if (![_teamStatus isValidString]) {
        _teamStatus = [kUserDefault objectForKey:@"app_teamStatus"];
    }
    return _teamStatus;
}

-(void)setSex:(NSString *)sex{
    _sex = sex;
    if (![_sex isValidString]) {
        [kUserDefault removeObjectForKey:@"app_sex"];
    }else {
        [kUserDefault setObject:_sex forKey:@"app_sex"];
    }
    [kUserDefault synchronize];
}

-(NSString *)sex{
    if (![_sex isValidString]) {
        _sex = [kUserDefault objectForKey:@"app_sex"];
    }
    return _sex;
}

-(void)setAge:(NSString *)age{
    _age = age;
    if (![_age isValidString]) {
        [kUserDefault removeObjectForKey:@"app_age"];
    }else {
        [kUserDefault setObject:_age forKey:@"app_age"];
    }
    [kUserDefault synchronize];
}

-(NSString *)age{
    if (![_age isValidString]) {
        _age = [kUserDefault objectForKey:@"app_age"];
    }
    return _age;
}

-(void)setNativePlace:(NSString *)nativePlace{
    _nativePlace = nativePlace;
    if (![_nativePlace isValidString]) {
        [kUserDefault removeObjectForKey:@"app_nativePlace"];
    }else {
        [kUserDefault setObject:_nativePlace forKey:@"app_nativePlace"];
    }
    [kUserDefault synchronize];
}

-(NSString *)nativePlace{
    if (![_nativePlace isValidString]) {
        _nativePlace = [kUserDefault objectForKey:@"app_nativePlace"];
    }
    return _nativePlace;
}

-(void)setPhoneNum:(NSString *)phoneNum{
    _phoneNum = phoneNum;
    if (![_phoneNum isValidString]) {
        [kUserDefault removeObjectForKey:@"app_phoneNum"];
    }else {
        [kUserDefault setObject:_phoneNum forKey:@"app_phoneNum"];
    }
    [kUserDefault synchronize];
}

-(NSString *)phoneNum{
    if (![_phoneNum isValidString]) {
        _phoneNum = [kUserDefault objectForKey:@"app_phoneNum"];
    }
    return _phoneNum;
}

-(void)setFirstOpen:(BOOL)firstOpen{
    _firstOpen = firstOpen;
    [kUserDefault setBool:_firstOpen forKey:@"app_firstOpen"];
    [kUserDefault synchronize];
}

-(BOOL)firstOpen{
    _firstOpen = [kUserDefault objectForKey:@"app_firstOpen"];
    return _firstOpen;
}

#pragma mark - 配置 userId taskId dataCode数据对应
-(void)setTaskURLDic:(NSDictionary *)taskURLDic{
    _taskURLDic = taskURLDic;
    if (!_taskURLDic) {
        _taskURLDic = [[NSDictionary alloc]init];
    }
    [kUserDefault setObject:_taskURLDic forKey:@"app_taskURLs"];
    [kUserDefault synchronize];
}

-(NSDictionary *)taskURLDic{
    _taskURLDic = [kUserDefault objectForKey:@"app_taskURLs"];
    if (!_taskURLDic) {
        _taskURLDic = [[NSDictionary alloc]init];
        [kUserDefault setObject:_taskURLDic forKey:@"app_taskURLs"];
        [kUserDefault synchronize];
    }
    return _taskURLDic;
}

-(void)setLocal_taskURLDic:(NSDictionary *)local_taskURLDic{
    _local_taskURLDic = local_taskURLDic;
    if (!_local_taskURLDic) {
        _local_taskURLDic = [[NSDictionary alloc]init];
    }
    [kUserDefault setObject:_local_taskURLDic forKey:@"app_local_taskURLs"];
    [kUserDefault synchronize];
}

-(NSDictionary *)local_taskURLDic{
    _local_taskURLDic = [kUserDefault objectForKey:@"app_local_taskURLs"];
    if (!_local_taskURLDic) {
        _local_taskURLDic = [[NSDictionary alloc]init];
        [kUserDefault setObject:_local_taskURLDic forKey:@"app_local_taskURLs"];
        [kUserDefault synchronize];
    }
    return _local_taskURLDic;
}

-(void)setDataCodeDic:(NSDictionary *)dataCodeDic{
    _dataCodeDic = dataCodeDic;
    if (!_dataCodeDic) {
        _dataCodeDic = [[NSDictionary alloc]init];
    }
    [kUserDefault setObject:_dataCodeDic forKey:@"app_dataCodeDic"];
    [kUserDefault synchronize];
}

-(NSDictionary *)dataCodeDic{
    _dataCodeDic = [kUserDefault objectForKey:@"app_dataCodeDic"];
    if (!_dataCodeDic) {
        _dataCodeDic = [[NSDictionary alloc]init];
        [kUserDefault setObject:_dataCodeDic forKey:@"app_dataCodeDic"];
        [kUserDefault synchronize];
    }
    return _dataCodeDic;
}

-(void)setUser_dataCodeDic:(NSDictionary *)user_dataCodeDic{
    _user_dataCodeDic = user_dataCodeDic;
    if (!_user_dataCodeDic) {
        _user_dataCodeDic = [[NSDictionary alloc]init];
    }
    [kUserDefault setObject:_user_dataCodeDic forKey:@"user_dataCodeDic"];
    [kUserDefault synchronize];
}

-(NSDictionary *)user_dataCodeDic{
    _user_dataCodeDic = [kUserDefault objectForKey:@"user_dataCodeDic"];
    if (!_user_dataCodeDic) {
        _user_dataCodeDic = [[NSDictionary alloc]init];
        [kUserDefault setObject:_user_dataCodeDic forKey:@"user_dataCodeDic"];
        [kUserDefault synchronize];
    }
    return _user_dataCodeDic;
}

-(void)configUser_dataCodeDicWithTaskId:(NSString *)task_id dataCode:(NSString *)dataCode{
    NSDictionary *user_dataCodeDic = kAppCacheInfo.user_dataCodeDic;
    NSDictionary *dataCodeDic = [user_dataCodeDic objectForKey:kAppCacheInfo.userId];
    
    NSMutableDictionary *newDataCodeDic = [NSMutableDictionary dictionaryWithDictionary:dataCodeDic];
    [newDataCodeDic setObject:dataCode forKey:task_id];
    kAppCacheInfo.dataCodeDic = newDataCodeDic; //保存到本地
    
    
    NSMutableDictionary *new_user_dataCodeDic = [NSMutableDictionary dictionaryWithDictionary:user_dataCodeDic];
    [new_user_dataCodeDic setObject:newDataCodeDic forKey:kAppCacheInfo.userId];
    kAppCacheInfo.user_dataCodeDic = new_user_dataCodeDic; //保存到本地
}

#pragma mark - 配置 userId taskId 已录制 数据对应
-(void)setTaskNumDic:(NSDictionary *)taskNumDic{
    _taskNumDic = taskNumDic;
    if (!_taskNumDic) {
        _taskNumDic = [[NSDictionary alloc]init];
    }
    [kUserDefault setObject:_taskNumDic forKey:@"app_taskNumDic"];
    [kUserDefault synchronize];
}

-(NSDictionary *)taskNumDic{
    _taskNumDic = [kUserDefault objectForKey:@"app_taskNumDic"];
    if (!_taskNumDic) {
        _taskNumDic = [[NSDictionary alloc]init];
        [kUserDefault setObject:_taskNumDic forKey:@"app_taskNumDic"];
        [kUserDefault synchronize];
    }
    return _taskNumDic;
}

-(void)setTaskRecDic:(NSDictionary *)taskRecDic{
    _taskRecDic = taskRecDic;
    if (!_taskRecDic) {
        _taskRecDic = [[NSDictionary alloc]init];
    }
    [kUserDefault setObject:_taskRecDic forKey:@"app_taskRecDic"];
    [kUserDefault synchronize];
}

-(NSDictionary *)taskRecDic{
    _taskRecDic = [kUserDefault objectForKey:@"app_taskRecDic"];
    if (!_taskRecDic) {
        _taskRecDic = [[NSDictionary alloc]init];
        [kUserDefault setObject:_taskRecDic forKey:@"app_taskRecDic"];
        [kUserDefault synchronize];
    }
    return _taskRecDic;
}

-(void)setUser_taskRecDic:(NSDictionary *)user_taskRecDic{
    _user_taskRecDic = user_taskRecDic;
    if (!_user_taskRecDic) {
        _user_taskRecDic = [[NSDictionary alloc]init];
    }
    [kUserDefault setObject:_user_taskRecDic forKey:@"user_taskRecDic"];
    [kUserDefault synchronize];
}

-(NSDictionary *)user_taskRecDic{
    _user_taskRecDic = [kUserDefault objectForKey:@"user_taskRecDic"];
    if (!_user_taskRecDic) {
        _user_taskRecDic = [[NSDictionary alloc]init];
        [kUserDefault setObject:_user_taskRecDic forKey:@"user_taskRecDic"];
        [kUserDefault synchronize];
    }
    return _user_taskRecDic;
}

-(NSInteger)getUserRecCountWithTaskId:(NSString *)task_id{
    NSDictionary *user_taskRecDic = kAppCacheInfo.user_taskRecDic;
    NSDictionary *taskRecDic = [user_taskRecDic objectForKey:kAppCacheInfo.userId];
    
    NSString *recCount = taskRecDic[task_id];
    
    if (!recCount) {
        return 0;
    }
    return recCount.integerValue;
}

//配置用户任务完成条数表
-(void)configUser_taskRecDicWithTaskId:(NSString *)task_id recCount:(int)recCount{
    NSDictionary *user_taskRecDic = kAppCacheInfo.user_taskRecDic;
    NSDictionary *taskRecDic = [user_taskRecDic objectForKey:kAppCacheInfo.userId];
    
    NSMutableDictionary *newTaskRecDic = [NSMutableDictionary dictionaryWithDictionary:taskRecDic];
    [newTaskRecDic setObject:[NSString stringWithFormat:@"%d",recCount] forKey:task_id];
    kAppCacheInfo.taskRecDic = newTaskRecDic; //保存到本地
    
    
    NSMutableDictionary *new_user_taskRecDic = [NSMutableDictionary dictionaryWithDictionary:user_taskRecDic];
    [new_user_taskRecDic setObject:newTaskRecDic forKey:kAppCacheInfo.userId];
    kAppCacheInfo.user_taskRecDic = new_user_taskRecDic; //保存到本地
}




//清除一些保存信息
- (void)clearSomeUserDefaultsData{
    self.token = @"";
    self.refresh_token = @"";
    self.userId = @"";
    
    self.userName = @"";
    self.headImage = @"";
    self.sex = @"0";
    self.age = @"";
//    self.nativePlace = @"";
    
}



@end
