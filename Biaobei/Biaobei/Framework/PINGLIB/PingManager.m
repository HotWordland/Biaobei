//
//  PingManager.m
//  PingLib
//
//  Created by 王家辉 on 2019/11/12.
//  Copyright © 2019年 Soc. All rights reserved.
//

#import "PingManager.h"

#define MaxTimes 3
//#define MaxDelay 1

#define host @"www.baidu.com"
typedef void (^PingResult)(BOOL);

typedef enum : NSUInteger {
    Success,
    Timeout,
    Fail,
    Unexpected,
} Status;

@interface PingManager () <STSimplePingDelegate> {
    double maxDelay;
    NSInteger time;  //ping次数
    STSimplePing *ping;
    NSDate *startDate;
    NSDate *endDate;
    BOOL start;
    BOOL pingSuccess;
}

@property(nonatomic, strong) PingResult result;

@end

@implementation PingManager

+ (PingManager *)startPing:(NSString *)hostname result:(PingResult)result {
    if (hostname.length == 0) {
        hostname = host;
    }
    PingManager *manager = [[PingManager alloc] initHostname:hostname];
    manager.result = result;
    [manager start];

    return manager;
}

- (instancetype)initHostname:(NSString *)hostname {
    self = [super init];
    if (self) {
        ping = [[STSimplePing alloc] initWithHostName:hostname];
        ping.delegate = self;
        ping.addressStyle = STSimplePingAddressStyleAny;
    }

    return self;
}

//开始ping
- (void)start {
    startDate = [NSDate date];
    maxDelay = 1.0;
    time = 0;  //ping次数
    [ping start];
    
    //不依赖代理的start方法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(maxDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //网络很差时，ping返回很慢
        [self pingTimeout];  //MaxDelay内已经ping了三次
    });
}

//发送ping数据
- (void)sendPingWithData:(nullable NSData *)data {
    
}

//停止
- (void)stop {
    [ping stop];
}

- (void)handleResult:(Status)status {
    //计算绝对延迟时间
    NSTimeInterval timeInterval = (double)[[NSDate date] timeIntervalSinceDate:startDate];

    if (status == Success) {
        if (timeInterval < maxDelay) {
            if (time < MaxTimes) {
                time ++;  //repeat ping times 1.2.3
                NSTimer *timer = [NSTimer timerWithTimeInterval:0.05
                                                         target:self
                                                       selector:@selector(repeat)
                                                       userInfo:nil
                                                        repeats:NO];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            } else {
                if (time == MaxTimes) {
                    pingSuccess = YES;  //网速很快
                    self.result(YES);  //最大延迟时间内ping通4次
                    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(pingTimeout) object:nil];
                    return;
                }
            }
        }
       
    }
    
   
}

//超时里判断网速
- (void)pingTimeout {
    [self stop];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(pingTimeout) object:nil];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(repeat) object:nil];
    if (pingSuccess) {
        return;
    } else {
        if (time == 3) {
            self.result(YES);  //3G
        } else {
            self.result(NO);  //弱网
        }
    }
}

//重试
- (void)repeat {
    [ping stop];
    [ping start];
}


//ping 开始
- (void)st_simplePing:(STSimplePing *)pinger didStartWithAddress:(NSData *)address {
    NSData *packet = [pinger packetWithPingData:nil];
    [ping sendPacket:packet];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MaxDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         //网络很差时，ping返回很慢
//        [self pingTimeout];  //MaxDelay内已经ping了三次
//    });
    
}

//ping 失败
- (void)st_simplePing:(STSimplePing *)pinger didFailWithError:(NSError *)error {
     [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(pingTimeout) object:nil];
    [self stop];
}

//成功发送ping数据
- (void)st_simplePing:(STSimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    
}

//发送ping数据失败
- (void)st_simplePing:(STSimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(pingTimeout) object:nil];
    [self stop];
}

//收到ping响应数据
- (void)st_simplePing:(STSimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
}

- (void)st_simplePing:(STSimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet timeToLive:(NSInteger)timeToLive sequenceNumber:(uint16_t)sequenceNumber timeElapsed:(NSTimeInterval)timeElapsed {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(pingTimeout) object:nil];
    [self handleResult:Success];
//    NSLog(@"^_^ %@", [[NSString alloc] initWithData:packet encoding:NSUTF8StringEncoding]);
}

//收到未知响应数据
- (void)st_simplePing:(STSimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
     [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(pingTimeout) object:nil];
    [self stop];
}

- (NSDate *)getCurrentDate {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*60*60];  //北京时间属于东八区
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd hh:MM:SS"];
    NSDate *date = [NSDate date];
    return date;
}

- (void)dealloc {
    ping = nil;
}


@end
