//
//  BBAudioManager.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/12.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBAudioManager.h"
#import "lame.h"

#define kAudioFolder @"AudioFolder" // 音频文件夹

@interface BBAudioManager ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;    // 录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;        // 音频播放器
@property (strong ,nonatomic) NSDictionary *setting;            // 录音机的设置
@property (copy ,nonatomic) NSString *audioDir;                 // 录音文件夹路径
@property (nonatomic,strong) NSTimer *timer;    // 录音声波监控
@property (copy ,nonatomic) NSString *filename; // 记录当前文件名
@property (assign ,nonatomic) BOOL cancelCurrentRecord;    // 取消当前录制
@property (strong ,nonatomic) NSString *micStatus;  //

@end


@implementation BBAudioManager
- (void)deallocAudio {
    
    [_timer invalidate];
    
    _audioRecorder = nil;
    _audioPlayer = nil;
}
+(instancetype)sharedInstance{
    static BBAudioManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BBAudioManager alloc] init];
    });
    return instance;
}

//检查麦克风权限
- (AVAuthorizationStatus)checkMicAuthStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            ////未询问过用户是否授权
//            self.micStatus = @"AVAuthorizationStatusNotDetermined";
            return AVAuthorizationStatusNotDetermined;
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，例如家长控制
//            self.micStatus = @"AVAuthorizationStatusRestricted";
            return AVAuthorizationStatusRestricted;
            break;
        case AVAuthorizationStatusDenied:
            //未授权，用户曾选择过拒绝授权
//            self.micStatus = @"AVAuthorizationStatusDenied";
            return AVAuthorizationStatusDenied;
            break;
        case AVAuthorizationStatusAuthorized:
            //已经授权
//            self.micStatus = @"AVAuthorizationStatusAuthorized";
            return AVAuthorizationStatusAuthorized;
            break;
        default:
            break;
    }
}

#pragma mark == 初始化AudioRecorder ==

//配置录音机
-(void)setupRecorder{
    //设置音频会话
    NSError *sessionError;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&sessionError];
    if (sessionError){
        NSLog(@"Error creating session: %@",[sessionError description]);
    }else{
        [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    }
    //录音设置
    //创建录音文件保存路径
    NSURL *url = [self getSavePath];
    //创建录音机
    NSError *error = nil;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.setting error:&error];
    _audioRecorder.delegate = self;
    _audioRecorder.meteringEnabled = YES;//如果要监控声波则必须设置为YES
    [_audioRecorder prepareToRecord];
    if (error) {
        NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
    }
}


//录音声波监
-(NSTimer *)timer{
    if (!_timer) {
        //录音采集频率 4times/s = 1time/0.25s
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.250f target:self selector:@selector(powerChange) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

-(void)setTaskDetailmodel:(BBTaskDetailModel *)taskDetailmodel{
    _taskDetailmodel = taskDetailmodel;
    
    NSMutableDictionary *setDic = [[NSMutableDictionary alloc]initWithDictionary:self.setting];
    [setDic setObject:[NSNumber numberWithInt:taskDetailmodel.sampleRate.intValue] forKey:AVSampleRateKey];
    [setDic setObject:[NSNumber numberWithInt:taskDetailmodel.soundChannel.intValue] forKey:AVNumberOfChannelsKey];
    [setDic setObject:[NSNumber numberWithInt:taskDetailmodel.soundDepth.intValue] forKey:AVLinearPCMBitDepthKey];
    
    self.setting = setDic;
}

//录音设置
-(NSDictionary *)setting{
    if (_setting==nil) {
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        //录音格式
        [setting setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        //采样率，8000/11025/22050/44100/96000（影响音频的质量）,8000是电话采样率
        [setting setObject:@(44100) forKey:AVSampleRateKey];
        //通道 , 1/2
        [setting setObject:@(2) forKey:AVNumberOfChannelsKey];
        //采样点位数，分为8、16、24、32, 默认16
        [setting setObject:@(16) forKey:AVLinearPCMBitDepthKey];
        //是否使用浮点数采样
        [setting setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        // 录音质量
        [setting setObject:@(AVAudioQualityMax) forKey:AVEncoderAudioQualityKey];
        //....其他设置等
        _setting = setting;
    }
    return _setting;
}

//录音文件夹
-(NSString *)audioDir {
    if (_audioDir==nil) {
        _audioDir = NSTemporaryDirectory();
        _audioDir = [_audioDir stringByAppendingPathComponent:kAudioFolder];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:_audioDir isDirectory:&isDir];
        if (!(isDir == YES && existed == YES)){
            [fileManager createDirectoryAtPath:_audioDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _audioDir;
}

#pragma mark == 事件 ==

//开始录制
//-(void)checkAudioMicAuthStatus {
//    //麦克风权限检测
//    [self checkMicAuthStatus];
//    if ([self.micStatus isEqualToString:@"AVAuthorizationStatusAuthorized"]) {
////        [self startAudioRecord];
//    } else  if ([self.micStatus isEqualToString:@"AVAuthorizationStatusNotDetermined"]) {
//        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
//            if (granted) {
////                [self startAudioRecord];
//            } else {
//                [PromptAlertView alertWithMessage:@"请开启麦克风"];
//            }
//        }];
//    } else if ([self.micStatus isEqualToString:@"AVAuthorizationStatusDenied"]) {
//         [PromptAlertView alertWithMessage:@"请在设置-隐私-麦克风里打开麦克风"];
//
//    } else {
//        [PromptAlertView alertWithMessage:@"您没有被授权使用麦克风"];
//    }
//}

- (void)startRecord {
    [self setupRecorder];  //配置录音机
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];
        self.timer.fireDate = [NSDate distantPast];
    }
}
//暂停录制
-(void)pauseRecord{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
}
//恢复录制
-(void)resumeRecord{
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];
        self.timer.fireDate=[NSDate distantPast];
    }
}
//停止录制
-(void)stopRecord{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioRecorder stop];
        self.timer.fireDate=[NSDate distantFuture];
    });
 
}

//取消当前录制
-(void)cancelRecord {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cancelCurrentRecord = YES;
        [self stopRecord];
        
        //停止录音但不删除文件
//        if ([self.audioRecorder deleteRecording]) {
//            NSLog(@"删除录音文件!");
//        }
    });
 }

/* 获取播放音频峰值 */
- (CGFloat)getAudioPlayerPower {
    _audioPlayer.meteringEnabled = YES;
    [_audioPlayer updateMeters];
    CGFloat power = [_audioPlayer peakPowerForChannel:0];
    return power + 160.0f;
}

- (BOOL)getAudioPlayerState {
    if(_audioPlayer) {
        return _audioPlayer.playing;
    }
    return NO;
}

- (BOOL)getAudioRecorderState {
    if(_audioRecorder) {
        return _audioRecorder.recording;
    }
    return NO;
}



//播放音频文件
-(void)playAudioWithUrl:(NSURL*)url{
    //语音播放
    NSError *error=nil;
    _audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _audioPlayer.numberOfLoops=0;   // 设置为0不循环
    _audioPlayer.delegate = self;
    if (error) {
        NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    if (![_audioPlayer isPlaying]) {
        //解决音量小的问题
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
        [_audioPlayer play];    // 播放音频
    }
}

//播放网络音频
- (void)playOnlineAudio:(NSString *)onlineUrl {
    //语音播放
    NSError *error = nil;
    NSData *audioData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:onlineUrl]];

    _audioPlayer=[[AVAudioPlayer alloc] initWithData:audioData error:&error];
    _audioPlayer.numberOfLoops = 0;   // 设置为0不循环
    _audioPlayer.delegate = self;
    if (error) {
        NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    if (![_audioPlayer isPlaying]) {
        //解决音量小的问题
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
        [_audioPlayer play];    // 播放音频
    }
}


//停止播放语音
-(void)stopPlay{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioPlayer stop];
    });
}

//暂停语音
-(void)pausePlay{
    
    [self.audioPlayer pause];
}

//恢复语音
-(void)resumePlay{
    [self.audioPlayer play];
}


#pragma mark - <************************** 获取数据 **************************>
//获取录音保存路径
-(NSURL*)getSavePath{
    self.filename = [NSString stringWithFormat:@"audio_%@.wav",[self getDateString]];
    NSString* fileUrlString = [self.audioDir stringByAppendingPathComponent:self.filename];
    NSURL *url = [NSURL fileURLWithPath:fileUrlString];
    return url;
}

//返回音频文件地址
-(NSString *)recordCurrentAudioFile{
    NSString* fileUrlString = [self.audioDir stringByAppendingPathComponent:self.filename];
//    NSURL *url = [NSURL fileURLWithPath:fileUrlString];
    return fileUrlString;
}

//获取当前音频文件地址
-(NSURL *)recordCurrentAudioURL{
    NSString* fileUrlString = [self.audioDir stringByAppendingPathComponent:self.filename];
    NSURL *url = [NSURL fileURLWithPath:fileUrlString];
    return url;
}


//获取语音时长
-(float)durationWithAudio:(NSURL *)audioUrl{
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}


//删除所有文件夹
-(void)removeAllAudioFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:self.audioDir error:nil]) {
        NSLog(@"删除文件夹成功！！");
    }
}

//删除指定文件
-(void)removeAudioFile:(NSURL *)url{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:url.path error:nil]) {
        NSLog(@"删除录音文件成功！！");
    }
}

//删除指定后缀的文件
-(void)removeFileSuffixList:(NSArray<NSString *> *)suffixList filePath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contentOfFolder = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [path stringByAppendingPathComponent:aPath];
        BOOL isDir = NO;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir == YES) {
                // 是文件夹，则继续遍历
                [self removeFileSuffixList:suffixList filePath:fullPath];
            }
            else{
                NSLog(@"file-:%@", aPath);
                for (NSString* suffix in suffixList) {
                    if ([aPath hasSuffix:suffix]) {
                        if ([fileManager removeItemAtPath:fullPath error:nil]) {
                            NSLog(@"删除文件成功！！");
                        }
                    }
                }
            }
        }
    }
}



#pragma mark - <************************** 代理方法 **************************>
//录音代理事件
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (self.cancelCurrentRecord) {
        self.cancelCurrentRecord = NO;
        NSLog(@"取消录制！");
    }
    else{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(audioRecorderDidFinishRecording:successfullyFlag:)]) {
            [self.delegate audioRecorderDidFinishRecording:recorder successfullyFlag:flag];
        }
        NSLog(@"录制完成!");
    }
}
//播放语音代理事件
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)]) {
        [self.delegate audioPlayerDidFinishPlaying:player successfully:flag];
    }
    NSLog(@"播放完成!");
}


#pragma mark - <************************** 私有方法 **************************>
//获取时刻名称
-(NSString*)getDateString{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];
    NSString* formatString = @"%d%02d%02d%02d%02d%02d";
    return [NSString stringWithFormat:formatString, year, month, day, hour, min, sec];
}

//录音声波状态设置
-(void)powerChange {
    [self.audioRecorder updateMeters];//更新测量值
//    float power = [self.audioRecorder averagePowerForChannel:0];  // 取得第一个通道的音频，注意音频强度范围是-160到0，平均振幅
    float power = [self.audioRecorder peakPowerForChannel:0];  // 峰值，最大振幅
    
    //    20*pow(10, ((1/A) * [self.recorder averagePowerForChannel:0]))计算分贝数;
    //    其中A为振幅。（振幅找不到标准值，这边暂且用600）就可计算出分贝数；
    
    NSInteger offset = 0;  //测试值偏移值 15-20
    power = power + 160 + offset;
//    NSLog(@"峰值：%f",power);
//    NSLog(@"音频均值：%f",power);
    
//    int dB = 0;
//    if (power < 0.f) {
//        dB = 0;
//    } else if (power < 40.f) {
//        dB = (int)(power * 0.875);
//    } else if (power < 100.f) {
//        dB = (int)(power - 15);
//    } else if (power < 110.f) {
//        dB = (int)(power * 2.5 - 165);
//    } else {
//        dB = 110;
//    }
    
//    power = (float)dB;
//    NSLog(@"噪音值：%f",power);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPowerChange:)]) {
        [self.delegate audioPowerChange:power];
    }
    
    
    /*
    [self.audioRecorder updateMeters];//更新测量值
    float power = [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围是-160到0
    CGFloat progress = power+160 -50; //0-160
    NSLog(@"音频强度：%f",power);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(audioPowerChange:)]) {
        [self.delegate audioPowerChange:progress];
    }
    */
}

-(void)dealloc{
    [self removeAllAudioFile];
}

//wav转mp3
- (NSString *)audioPCMtoMP3:(NSString *)wavPath {
    NSString *cafFilePath = wavPath;
    NSString *mp3FilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"ddd.mp3"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil]){ NSLog(@"删除原MP3文件");
        
    }
    @try
    {
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");
        //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);
        //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");
        //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        lame_t lame = lame_init();
        //        lame_set_in_samplerate(lame, 22050.0);
        lame_set_in_samplerate(lame, 4000.0);
        lame_set_VBR(lame, vbr_default); lame_init_params(lame);
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0) write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
            
        }while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
        
    } @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        
    } @finally {
        return mp3FilePath;
        
    }
    
}

@end
