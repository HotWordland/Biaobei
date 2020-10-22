//
//  BBVolumeView.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/16.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBVolumeView.h"
#import "BBAudioManager.h"

@interface BBVolumeView ()<AudioManagerDelegate>
{
    CGContextRef context;
    NSMutableArray *soundMeters;
    
    NSMutableArray *noiseArr;  //噪音检测
    
    NSInteger recCount;  //录音采集频率 4times/s
    float noiseNum;  //噪音值
    NSInteger nCounterFirstS;  //统计第一秒噪音数
    NSInteger nCounterSecondS;
    NSInteger nCounterThirdS;
}


@end

@implementation BBVolumeView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;//内容模式为重绘，因为需要多次重复绘制音量表
        
        soundMeters = [[NSMutableArray alloc]init];  //声音数组
        int count = frame.size.width/5+1;
        for (int i=0; i<count; i++) {
            [soundMeters addObject:@110];
        }
        
//        BBAudioManager *manager = [BBAudioManager sharedInstance];
//        manager.delegate = self;
        
    }
    
    return self;
}

-(void)recordStart{
    recCount = 0;
}

#pragma mark - AudioManagerDelegate
-(void)audioPowerChange:(CGFloat)power{
  
    if (soundMeters.count > 0) {
        [soundMeters removeObjectAtIndex:0];
    }
    [soundMeters addObject:[NSNumber numberWithFloat:power]];
    [self setNeedsDisplay];
    
    /** 噪音检测算法 */
    BBTaskDetailModel *detailModel = [BBAudioManager sharedInstance].taskDetailmodel;  //获取噪音阈值
    //    NSInteger noiseCap = detailModel.noiseCap;  //服务端设置的噪音阈值
    float noiseCap = (float)detailModel.noiseCap.intValue;  //服务端设置的噪音阈值
    
    int offset = -30;  //误差  根据测试噪音值偏大

    noiseNum = power - 50 + offset;  //噪音计量为分贝值
//    NSLog(@"noiseNum -----  %lf",noiseNum);v

    if (recCount == 15) {
        return;
    }
    recCount++;  //峰值采样计数器
    
    NSLog(@"recCount: %li",recCount);
    NSLog(@"noiseNum: %f",noiseNum);
    
    //噪音采用最大峰值 1s - 3s之间，任意2s峰值均超过50db,均认为是噪音
    if (recCount <= 4) {
        if (noiseNum >= noiseCap) {
            ++nCounterFirstS;
        }
    } else if (recCount > 4 && recCount <= 8) {
        if (noiseNum >= noiseCap) {
            ++nCounterSecondS;
        }
    } else if (recCount > 8 && recCount <= 12) {
        if (noiseNum >= noiseCap) {
            ++nCounterThirdS;
        }
    }
    NSLog(@"噪音统计: 1-%li\n2-%li\n3-%li\n",(long)nCounterFirstS,nCounterSecondS,nCounterThirdS);
    if (recCount >= 12) {
        if (nCounterFirstS + nCounterSecondS >= 2 || nCounterFirstS + nCounterThirdS >= 2
            || nCounterSecondS + nCounterThirdS >= 2) {
            //发送噪音通知
            NSLog(@"发送噪音通知");
//            NSLog(@"噪音统计: 1-%li\n2-%li\n3-%li\n",(long)nCounterFirstS,nCounterSecondS,nCounterThirdS);
            
            //发出3s内有噪音通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"noiseNum" object:[NSNumber numberWithFloat:noiseNum]];
            recCount = 15;
            noiseNum = 0;  //噪音值清零
            nCounterFirstS = 0;  //清零
            nCounterSecondS = 0; //清零
            nCounterThirdS = 0;  //清零
        }
    }
}

/** 绘制音频波形图 */
- (void)drawRect:(CGRect)rect {
    
    if (soundMeters.count<=0) {
        return;
    }
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    UIColor *strokeColor = [UIColor colorWithHex:@"#25C29B"];
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    
    float noVoice = 0.0f;    // 该值代表低于-46.0的声音都认为无声音
    float maxVolume = 160.0;   // 该值代表最高声音为55.0
    
    CGContextSetLineWidth(context, 2);
//    NSLog(@"self.height: %f",self.height);
    
    for (int i=0; i<soundMeters.count; i++) {
        float soundMeter = [soundMeters[i] floatValue];
        float height = (soundMeter-110)/(maxVolume-noVoice-110)*self.height;
        
        CGContextMoveToPoint(context, SCREENWIDTH-5*i+3, self.height/2-(height)/2);
        CGContextAddLineToPoint(context, SCREENWIDTH-5*i+3, self.height/2+(height)/2);
    }
    CGContextStrokePath(context);
}

/* 预览试听时，重绘波形 */
- (void)reRedraw:(CGFloat)power {
    if (soundMeters.count > 0) {
        [soundMeters removeObjectAtIndex:0];
    }
    [soundMeters addObject:[NSNumber numberWithFloat:power]];
    [self setNeedsDisplay];
}

//-(void)drawWaveform:(CGFloat)power {
//
//}

-(void)clearView{
//    CGContextClearRect(context, self.bounds);
    soundMeters = [[NSMutableArray alloc]init];  //声音数组
    int count = self.frame.size.width/5+1;
    for (int i=0; i<count; i++) {
        [soundMeters addObject:@110];
    }
    recCount = 0;
    noiseNum = 0;
    [self setNeedsDisplay];
}
- (void)removeAudioArray {
//    [soundMeters removeAllObjects];
}

@end
