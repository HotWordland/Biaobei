//
//  BBCollectAudioViewController.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/12.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBCollectAudioViewController : BaseViewController

@property (nonatomic, copy) NSString *task_id;
@property (nonatomic, copy) NSArray *audioTextArr;
@property (nonatomic, copy) NSArray *audioIdArr;//重录时的id
@property (nonatomic, copy) NSString *serial;  //语料序号

@property (nonatomic, assign) int currentCount;
@property (nonatomic, assign) int allCount;
@property (nonatomic, assign) int timelimit;  //录制时长限制
@property (nonatomic, assign) int noiseCap;  //声音阈值

@property (nonatomic, assign) voiceStates status;  //语料状态 
@property (nonatomic, assign) BOOL re_recording;  //是否重新录制
//@property (nonatomic, assign) BOOL failedToPass;  //未通过



@end

NS_ASSUME_NONNULL_END
