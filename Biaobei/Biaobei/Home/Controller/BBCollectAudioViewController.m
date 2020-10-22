//
//  BBCollectAudioViewController.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/12.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBCollectAudioViewController.h"
#import "BBAudioManager.h"
#import "BBCollectAudioViewCell.h"
#import "BBVolumeView.h"
#import "BBAudioAlertView.h"
#import "BBOssUploadManager.h"
#import "BBRecordNoticeViewController.h"
#import "AppDelegate.h"
#import "BBTaskSuccessView.h"
#import "ToastView.h"
#import "BBTipDetailListViewController.h"
#import "PingManager.h"
#import "TaskToastView.h"
#import "AudioToastView.h"
#import "AudioAlertView.h"


typedef enum : NSUInteger {
    Record_initial,  //初始
    Record_recording,  //录制中
    Record_endRecord,  //录制结束
    Record_listen  //试听  停止试听变为录制结束状态
} RecordStates;

@interface BBCollectAudioViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AudioManagerDelegate>
@property (nonatomic, strong)  NSMutableArray * audioUrlArr;//判断第二次提交是否上传成功

@end

@implementation BBCollectAudioViewController {
    UICollectionView *taskCollectionView;
    float cellWidth;
    float cellHeight;
    
    NSInteger currentIndex;
    UILabel *indexLabel; //当前任务下标
    
    BBVolumeView *volumeView; //音频波形图
    
    BBAudioManager *audioManager;
    BBOssUploadManager *ossManager;
    
    UIView *recDot;
    UILabel *timeLabel;
    UIButton *listenBtn;  //试听
    UIButton *recordButton;  //录制
    UIButton *nextBtn;    //保存或下一个
    
    
    UIButton *noteButton;  //提示按钮 - 录音注意事项
    UIButton *cancelButton;
    
    //录制按钮提示
    UIImageView *recordTipView;
    UILabel *recordTipLabel;
    
    UIImageView *recordNoTalkTipView;
    UILabel *recordNoTalkTipLabel;
    
    //朗读提示
    UIImageView *readTipView;
    UILabel *readTipLabel;
    
    //试听提示
    UIImageView *listenTipView;
    UILabel *listenTipLabel;
    
    //暂停录制提示
    
    
    //保存提示
    UIImageView *saveTipView;
    UILabel *saveTipLabel;
    
    NSTimer *countDownTimer;//倒计时3s的
    int countDownCount;
    
    NSTimer *recordTimer;
    NSInteger recordTimeCount; //录制时长
    
     //录制完全结束标志
    
    RecordStates recordState;
    
    UIView *noTaskView;  //无任务后的视图
    BBAudioAlertView *upSuccessView; //最后一个上传成功
    NSInteger _retry; //上传失败 自动上传 3次
    BOOL limitStop; //由于时长限制停止录制
    
    NSTimer *playCounterTimer;  //播放音频波形图计时器  KVO被观察者
    
    PingManager *manager;  //弱网检测工具
}


//test.....
- (void)testAudioLocalFileisExist {
    NSLog(@"\n +++++  %s  ++++++",__func__);
    //    NSArray *array = [kBBDataManager getSubTaskNotHaveUploadUrlWithTaskID:_task_id];
    NSArray *array = [[BBDataManager shareInstance] getAllSubTaskWithTaskID:self.task_id];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< array.count; i ++) {
        //获取所有未上传的记录
        BBDataManagerModel *model = array[i];
        if (model && model.subTaskLocalFile && model.subTaskLocalFile.length >0) {
            NSData *audioData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:model.subTaskLocalFile]];
            if (audioData && audioData.length > 0) {
                [dataArray addObject:audioData];
            }
        }
    }
    if (dataArray.count > 0) {
        for (int i = 0; i< dataArray.count; i++) {
            NSData *audioData = dataArray[i];
            NSLog(@"check local file data length: %lu   %i",(unsigned long)audioData.length,i);
        }
    }
}
//test.....

#pragma mark == UIViewload ==

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noiseNumGet:) name:@"noiseNum" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
    [countDownTimer invalidate];
    countDownTimer = nil;
    
    [recordTimer invalidate];
    recordTimer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];  //移除观察者
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    recordState = Record_initial; //初始状态
    audioManager = [BBAudioManager sharedInstance];
    audioManager.delegate = self;
    ossManager = [BBOssUploadManager sharedInstance];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#292F40"];
    [self createSubViews];
}

- (void)createSubViews{
    //1.
    noteButton = [UIFactory createBtn:CGRectMake(SCREENWIDTH-50-50, StatusBarHeight+10, 40, 40) text:@"" textColor:WhiteColor textFont:kFontMediumSize(11) backGroundColor:[UIColor clearColor] trail:self action:@selector(iBtnAction) tag:20001 isRaduis:NO];
    [noteButton setImage:[UIImage imageNamed:@"注意事项icon"] forState:UIControlStateNormal];
    [self.view addSubview:noteButton];
    
    cancelButton = [UIFactory createBtn:CGRectMake(SCREENWIDTH-50, StatusBarHeight+10, 40, 40) text:@"" textColor:WhiteColor textFont:kFontMediumSize(11) backGroundColor:[UIColor clearColor] trail:self action:@selector(cancelBtnAction) tag:20002 isRaduis:NO];
    [cancelButton setImage:[UIImage imageNamed:@"关闭采集器icon"] forState:UIControlStateNormal];
    [self.view addSubview:cancelButton];
    
    //2.
    UILabel *collectLabel = [UIFactory createLab:CGRectMake(20, cancelButton.bottom, 100, 40) text:@"采集" textColor:GreenColor textFont:kFontMediumSize(36) textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:collectLabel];
    
    //3.集合视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    cellWidth = SCREENWIDTH-48;
    cellHeight = SCREENHEIGHT-collectLabel.bottom-20-(160+84)*kScale;
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    //设置上下间距
    layout.minimumLineSpacing = 10;
    //设置左右间距
    layout.minimumInteritemSpacing = 10;
    //设置距离屏幕边缘的边距
    layout.sectionInset = UIEdgeInsetsMake(0, 24, 0, 24);
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    taskCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, collectLabel.bottom+20, SCREENWIDTH, cellHeight) collectionViewLayout:layout];
    taskCollectionView.backgroundColor = [UIColor colorWithHex:@"#292F40"];
    taskCollectionView.showsHorizontalScrollIndicator = NO;
    taskCollectionView.scrollEnabled = NO;
    [self.view addSubview:taskCollectionView];
    [taskCollectionView registerClass:[BBCollectAudioViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    taskCollectionView.delegate = self;
    taskCollectionView.dataSource = self;
    
    //任务进度
    indexLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREENWIDTH-60)/2, taskCollectionView.bottom+2, 60, 18)];
    indexLabel.backgroundColor = [UIColor colorWithHex:@"#33394C"];
    indexLabel.layer.cornerRadius = 9;
    indexLabel.clipsToBounds = YES;
    [self.view addSubview:indexLabel];
    
    NSString *currentCountStr = [NSString stringWithFormat:@"%02d",_currentCount];
    NSString *allCountStr = [NSString stringWithFormat:@"%02d",_allCount];
    NSMutableAttributedString *indexAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@/%@",currentCountStr,allCountStr]];
    [indexAtt addAttributes:@{
                              NSFontAttributeName:kFontRegularSize(12),
                              NSForegroundColorAttributeName:[UIColor colorWithHex:@"#9499A1"]
                              } range:NSMakeRange(0, indexAtt.length)];
    [indexAtt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#00C397"] range:NSMakeRange(0, currentCountStr.length)];
    indexLabel.attributedText = indexAtt;
    indexLabel.textAlignment = NSTextAlignmentCenter;
    
    //4.音频波 44 84-20(indexLabel)-10-10
    volumeView = [[BBVolumeView alloc]initWithFrame:CGRectMake(0, indexLabel.bottom+10, SCREENWIDTH, 44*kScale)];
    [self.view addSubview:volumeView];
    
    //5.控制板
    UIView *botView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-160*kScale, SCREENWIDTH, 160*kScale)];
    botView.backgroundColor = [UIColor colorWithHex:@"#33394C"];
    [self.view addSubview:botView];
    
    timeLabel = [UIFactory createLab:CGRectMake(SCREENWIDTH/2-30, 10*kScale, 100, 22) text:@"00:00:000" textColor:[UIColor colorWithHex:@"#8890A9"] textFont:kFontRegularSize(18) textAlignment:NSTextAlignmentLeft];
    [botView addSubview:timeLabel];
    
    recDot = [[UIView alloc]initWithFrame:CGRectMake(timeLabel.left-12, timeLabel.top+8, 6, 6)];
    recDot.layer.cornerRadius = 3;
    recDot.backgroundColor = GreenColor;
    [botView addSubview:recDot];
    
    //试听
    listenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    listenBtn.frame = CGRectMake(38*kScale, 60*kScale, 40*kScale, 40*kScale);
    [listenBtn setImage:[UIImage imageNamed:@"试听"] forState:UIControlStateNormal];
    [botView addSubview:listenBtn];
    [listenBtn addTarget:self action:@selector(listenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    listenBtn.alpha = 0.3;
    listenBtn.enabled = NO;
    
    //录制
    recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame = CGRectMake((SCREENWIDTH-72*kScale)/2, (160.0-72.0)/2.0*kScale, 72*kScale, 72*kScale);
    [recordButton setBackgroundImage:[UIImage imageNamed:@"开始采集"] forState:UIControlStateNormal];
    [botView addSubview:recordButton];
    recordButton.titleLabel.font = kFontMediumSize(24);
    [recordButton setTitleColor:[UIColor colorWithHex:@"#33394C"] forState:UIControlStateNormal];
    [recordButton addTarget:self action:@selector(recordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //下一个或提交
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(SCREENWIDTH-(40+38)*kScale, 60*kScale, 40*kScale, 40*kScale);
    
    if (self.status == Checking) {
        if (!self.re_recording) {
            [nextBtn setImage:[UIImage imageNamed:@"提交全部"] forState:UIControlStateNormal];
        } else {
            [nextBtn setImage:[UIImage imageNamed:@"保存并开始下一条"] forState:UIControlStateNormal];
        }
        
    } else {
        [nextBtn setImage:[UIImage imageNamed:@"保存并开始下一条"] forState:UIControlStateNormal];
    }
    
//    [nextBtn setImage:[UIImage imageNamed:@"保存并开始下一条"] forState:UIControlStateNormal];
    [botView addSubview:nextBtn];
    nextBtn.alpha = 0.3;
    nextBtn.enabled = NO;
    [nextBtn addTarget:self action:@selector(saveAndNextAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *tipImage = [UIImage imageNamed:@"提示文案背景"];
    NSInteger leftCapWidth = tipImage.size.width * 0.0;
    NSInteger topCapHeight = tipImage.size.height * 0.2;
    tipImage = [tipImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];  //拉伸
    //    tipImage = [tipImage resizableImageWithCapInsets:UIEdgeInsetsMake(tipImage.size.height*0.5, tipImage.size.width*0.0, tipImage.size.height*0.5, tipImage.size.width*0.0)resizingMode:UIImageResizingModeStretch];
    
    //录制按钮提示
    recordTipView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 119, 54)];
    recordTipView.image = tipImage;
    [botView addSubview:recordTipView];
    recordTipView.center = CGPointMake(botView.center.x, 5);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        recordTipView.hidden = YES;
    });
    
    recordTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    recordTipLabel.font = kFontRegularSize(14);
    recordTipLabel.textColor = BlackColor;
    recordTipLabel.text = @"点击开始采集";
    recordTipLabel.textAlignment = NSTextAlignmentCenter;
    [recordTipView addSubview:recordTipLabel];
    
    [recordTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.mas_equalTo(recordTipView);
        make.height.mas_equalTo(44);
    }];
    
    recordNoTalkTipView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 173, 54)];
    recordNoTalkTipView.image = tipImage;
    [botView addSubview:recordNoTalkTipView];
    recordNoTalkTipView.center = CGPointMake(botView.center.x, 5);
    recordNoTalkTipView.hidden = YES;
    
    recordNoTalkTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 44)];
    recordNoTalkTipLabel.font = kFontRegularSize(14);
    recordNoTalkTipLabel.textColor = BlackColor;
    recordNoTalkTipLabel.text = @"请不要说话采集即将开始";
    recordNoTalkTipLabel.textAlignment = NSTextAlignmentCenter;
    [recordNoTalkTipView addSubview:recordNoTalkTipLabel];
    [recordNoTalkTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.mas_equalTo(recordNoTalkTipView);
        make.height.mas_equalTo(44);
    }];
    
    
    //朗读提示
    readTipView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-107)/2, collectLabel.center.x, 107, 54)];
    readTipView.image = tipImage;
    [self.view addSubview:readTipView];
    readTipView.hidden = YES;
    
    readTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 107, 44)];
    readTipLabel.font = kFontRegularSize(14);
    readTipLabel.textColor = BlackColor;
    readTipLabel.textAlignment = NSTextAlignmentCenter;
    readTipLabel.text = @"请朗读句子";
    [readTipView addSubview:readTipLabel];
    
    //试听提示
    listenTipView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 88, 54)];
    listenTipView.image = tipImage;
    [botView addSubview:listenTipView];
    listenTipView.hidden = YES;
    listenTipView.center = CGPointMake(listenBtn.center.x, listenBtn.top-30);
    
    listenTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    listenTipLabel.font = kFontRegularSize(14);
    listenTipLabel.textColor = BlackColor;
    listenTipLabel.textAlignment = NSTextAlignmentCenter;
    [listenTipView addSubview:listenTipLabel];
    
    //保存提示
    saveTipView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-131-10, 0, 131, 54)];
    //    UIImage *tipImage1 = [tipImage stretchableImageWithLeftCapWidth:tipImage.size.width*0.2 topCapHeight:tipImage.size.height*0.3];
    saveTipView.image = [UIImage imageNamed:@"保存并提交"];
    [botView addSubview:saveTipView];
    saveTipView.hidden = YES;
    
    saveTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    saveTipLabel.font = kFontRegularSize(14);
    saveTipLabel.textColor = BlackColor;
    saveTipLabel.textAlignment = NSTextAlignmentCenter;
    [saveTipView addSubview:saveTipLabel];
    [saveTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.mas_equalTo(saveTipView);
        make.height.mas_equalTo(44);
    }];
    
    
    //无任务后
    noTaskView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-150)/2, (SCREENHEIGHT-110)/2-50, 150, 110)];
    noTaskView.backgroundColor = [UIColor clearColor];
    noTaskView.hidden = YES;
    [self.view addSubview:noTaskView];
    
    UIImageView *noImgView = [[UIImageView alloc]initWithFrame:CGRectMake((150-47)/2, 2, 47, 52)];
    noImgView.image = [UIImage imageNamed:@"Combined Shape"];
    [noTaskView addSubview:noImgView];
    
    UILabel *noLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, noImgView.bottom+10, 150, 20)];
    noLabel.textColor = [UIColor colorWithHex:@"#8890A9"];
    noLabel.font = kFontRegularSize(14);
//    noLabel.text = @"暂无任务\n你可以“回到首页”领取";
    noLabel.text = @"";
    noLabel.numberOfLines = 0;
    [noLabel sizeToFit];
    noLabel.textAlignment = NSTextAlignmentCenter;
    [noTaskView addSubview:noLabel];
    
    //提交成功信息
    upSuccessView = [[BBAudioAlertView alloc]initWithWhiteFrame:CGRectMake(45, (SCREENHEIGHT-180)/2-10, SCREENWIDTH-90, 180) AudioAlertType:AlertTypeUpLoadSuccess alertTitle:@"任务提交成功\n可在个人中心查看审核进度" highLightStr:@""];  //最后一个上传s成功
}

- (void)setTaskStyle:(UIView *)view text:(NSString *)text hidden:(BOOL)hidden {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)v;
            label.text = text;
            break;
        }
    }
    view.hidden = hidden;
}

- (void)initTaskStyle:(UIView *)view {
    //无任务背景
    UIView *taskView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-150)/2, (SCREENHEIGHT-110)/2-50, 150, 110)];
    taskView.backgroundColor = [UIColor clearColor];
    taskView.hidden = YES;
    [view addSubview:noTaskView];
    
    UIImageView *noImgView = [[UIImageView alloc]initWithFrame:CGRectMake((150-47)/2, 2, 47, 52)];
    noImgView.image = [UIImage imageNamed:@"Combined Shape"];
    [noTaskView addSubview:noImgView];
    
    UILabel *noLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, noImgView.bottom+10, 150, 20)];
    noLabel.textColor = [UIColor colorWithHex:@"#8890A9"];
    noLabel.font = kFontRegularSize(14);
    //    noLabel.text = @"暂无任务\n你可以“回到首页”领取";
    noLabel.text = @"";
    noLabel.numberOfLines = 0;
    [noLabel sizeToFit];
    noLabel.textAlignment = NSTextAlignmentCenter;
    [taskView addSubview:noLabel];
}

#pragma mark  == 噪音检测 ==
//噪音检测  接收噪音通知
-(void)noiseNumGet:(NSNotification *)notification {
    [self showMessage:@"当前噪音过高，请换个环境录制"];
    [audioManager stopRecord];
    
    [recordTimer invalidate];
    recordTimer = nil;
    [countDownTimer invalidate];
    countDownTimer = nil;
    recDot.backgroundColor = GreenColor;
    timeLabel.text = @"00:00:00";
    recordTimeCount = 0;
    countDownCount = 0;
    [volumeView clearView];
    [volumeView recordStart];
    limitStop = NO;
    noTaskView.hidden = YES;
    recordButton.selected = YES;
    
    //左右按钮变化
    listenBtn.alpha = 0.3;
    listenBtn.enabled = NO;
    
    nextBtn.alpha = 0.3;
    nextBtn.enabled = NO;
    listenTipView.hidden = YES;
    saveTipView.hidden = YES;
    recordState = Record_endRecord;
    recordButton.userInteractionEnabled = YES;
    [recordButton setBackgroundImage:[UIImage imageNamed:@"开始采集"] forState:UIControlStateNormal];
    [recordButton setTitle:@"" forState:UIControlStateNormal];
    [volumeView removeAudioArray];
}

#pragma mark == 录音 ==

/* 进入录制注意事项页面 */
-(void)iBtnAction {
    [audioManager cancelRecord];
    recordButton.selected = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [recordButton setBackgroundImage:[UIImage imageNamed:@"开始采集"] forState:UIControlStateNormal];
    });
    
    //左右按钮变化
    listenBtn.alpha = 0.3;
    listenBtn.enabled = NO;
    
    nextBtn.alpha = 0.3;
    nextBtn.enabled = NO;
    
    [recordTimer invalidate];
    recordTimer = nil;
    
    timeLabel.text = @"00:00:00";
    recordTimeCount = 0;
    [volumeView clearView];
    [volumeView recordStart];
    
    recordState = Record_initial;
    limitStop = NO;
    
    BBRecordNoticeViewController *noticeVC = [[BBRecordNoticeViewController alloc]init];
    noticeVC.taskId = _task_id;
    [self.navigationController pushViewController:noticeVC animated:YES];
    
}

/* 关闭采集 */
-(void)cancelBtnAction {
    //未质检|未通过
    NSString *message = @"";
    CGFloat width = 0;
    CGFloat height = 0;
    if (self.status == Checking) {
        message = @"确定要退出么？未通过语料录制中途退出将不做任何保存";
        width = SCREENWIDTH - 48;
        height = 180+57;

    } else {
        //待录制|已录制
        message = @"确定要退出吗？退出后将保存当前进度，你可以通过\"我的-未提交\"中进行录制提交,可在个人中心查看审核进度";
        width = SCREENWIDTH - 48;
        height = 180+118;
    }
    
    AudioAlertView *alertView = [[AudioAlertView alloc] init:@"Combined Shape"
                                                alertMessage:message
                                                 cancelTitle:@"取消"
                                                     okTitle:@"确定"];
    kWeak_self
    alertView.okBlock = ^(NSInteger index) {
        if (index == 1) {
            //退出录音界面 进入待录制或未质检界面
            [audioManager cancelRecord];
            NSMutableArray *vcArray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
          
            BBTipDetailListViewController *vc = [[BBTipDetailListViewController alloc] init];
            vc.task_id = self.task_id;

            if (self.status == Checking) {
                if (self.re_recording) {
                    //未通过录音时未全部录制完成退出时删除未通过的所有语料
                    for (int i = 0; i < self.audioIdArr.count; i++) {
                        [kBBDataManager deleteSubTaskWithTaskID:self.task_id subTaskID:self.audioIdArr[i]];
                    }
                }
                [vc tag:Checking];
            } else {
                [vc tag:NoRefer];
            }
            
            for (UIViewController *_vc in vcArray) {
                if ([_vc isKindOfClass:[BBTipDetailListViewController class]]) {
                    [vcArray replaceObjectAtIndex:[vcArray indexOfObject:_vc] withObject:vc];
                    break;
                }
            }
            [self.navigationController setViewControllers:vcArray];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [kWindow addSubview:alertView];
}

/* 录音按钮点击事件 */
- (void)recordButtonAction:(UIButton *)button {
    //避免连续点击，时间间隔为1s
    recordButton.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //允许点击的条件：1. 不在倒计时内 2. 倒计时失效
        if (!countDownTimer || ![countDownTimer isValid]) {
            recordButton.userInteractionEnabled = YES;
        }
    });
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(startRecordAction) object:nil];
    [self performSelector:@selector(startRecordAction) withObject:nil afterDelay:0.5];
}

/* 开始录制 */
-(void)startRecordAction {
    if (recordState==Record_endRecord || recordState==Record_listen) {
        //已经录制完成 或者在听回放
        NSString *alertStr = @"你确定要重新采集当前条目？\n此操作将覆盖上一次采集";
        CGRect frame = CGRectMake(12, (SCREENHEIGHT-180-57)/2, SCREENWIDTH-24, 180+57);
        AudioToastView *toast = [[AudioToastView alloc] initWithWhiteFrame:frame
                                                                alertImage:[UIImage imageNamed:@"Combined Shape"]
                                                                alertTitle:alertStr
                                                              highLightStr:@""
                                                              leftBtnTitle:@"我再想想"
                                                             rightBtnTitle:@"重新采集"];
        kWeak_self

        toast.okBlock = ^(NSInteger index) {
            if (index == 1) {
                //index = 1的时候重新采集
                //重新采集
                NSURL *currentURL = [audioManager recordCurrentAudioURL];
                [audioManager removeAudioFile:currentURL];
                NSString * subTaskid = self.audioIdArr[currentIndex];  //注意断网、弱网等情况下提交不成功导致的currentIndex > array.index 越界问题
                
                //重录需要跟下本地数据库
                [kBBDataManager upDataBaseTaskID:_task_id subTaskID:subTaskid localFile:@""];
                [kBBDataManager upDataBaseTaskID:_task_id subTaskID:subTaskid url:@""];
                
                [volumeView clearView];
                [volumeView recordStart];
                recordTimeCount = 0;
                
                recordState = Record_initial;
                recordButton.selected = NO;
                [weakSelf recordButtonAction:recordButton];  //重新录制
                limitStop = NO;
                
                listenBtn.alpha = 0.3;
                listenBtn.enabled = NO;
                nextBtn.alpha = 0.3;
                nextBtn.enabled = NO;
            }
        };
        [kWindow addSubview:toast];
        return;
    }
    
    recordButton.selected = !recordButton.selected;  //开始录制/停止
    if (recordButton.selected) {
//        [self checkMicAuthAndStartRecord];  //检测麦克风权限并录音
        
        
        //开始录制
        noteButton.enabled = NO;  //录制过程中禁止点击注意事项按钮
        limitStop = NO;
        recDot.backgroundColor = [UIColor colorWithHex:@"#D0021B"];

        //麦克风权限检测
        ////////////////////////

        [audioManager startRecord];  //录制时音频文件路径已经创建
        [volumeView recordStart];
        recordState = Record_recording;
        
        //只在第一段语料提示
        if (_currentCount == 1) {
            recordTipView.hidden = YES;  // "点击开始采集" 提示
            //点击停止采集提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                recordTipLabel.text = @"点击开始采集";
                recordTipView.hidden = YES;
            });
            
        }
        
        recordNoTalkTipLabel.text = @"请不要说话采集即将开始";
        recordNoTalkTipView.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            recordNoTalkTipView.hidden = YES;
            
            //点击停止采集提示  复用
            if (_currentCount == 1) {
                recordTipLabel.text = @"点击停止采集";
                recordTipView.hidden = NO;
            }
          
        });
      
        
        //倒计时
        [recordButton setTitle:@"3" forState:UIControlStateNormal];
        recordButton.userInteractionEnabled = NO;  //禁止点击

        if (!countDownTimer || !countDownTimer.isValid) {
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(countDown:)
                                                            userInfo:nil
                                                             repeats:YES];
        }



        if (!recordTimer || !countDownTimer.isValid) {
            recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(recordTimerAction)
                                                         userInfo:nil
                                                          repeats:YES];
        }
        
    } else {
        //停止录制
        //已达录制上限会进入这儿
        limitStop = YES;  //避免超时判断里再走一遍
        
        [recordButton setTitle:@"3" forState:UIControlStateNormal];
        recordButton.userInteractionEnabled = NO;  //倒计时，禁止点击

        if (!countDownTimer || !countDownTimer.isValid) {
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        }
        
        recordNoTalkTipLabel.text = @"请不要说话采集即将结束";
        recordNoTalkTipView.hidden = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            recordNoTalkTipView.hidden = YES;
            [self stopRecord];
        });
    }
}

//麦克风权限检测
- (void)checkMicAuthAndStartRecord {
    AVAuthorizationStatus status = [audioManager checkMicAuthStatus];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                [self startRecord];
            } else {
                [PromptAlertView alertWithMessage:@"请开启麦克风"];
            }
        }];
    } else if (status == AVAuthorizationStatusRestricted) {
          [PromptAlertView alertWithMessage:@"您没有被授权使用麦克风"];
    } else if (status == AVAuthorizationStatusDenied) {
       [PromptAlertView alertWithMessage:@"请在设置-隐私-麦克风里打开麦克风"];
    } else if (status == AVAuthorizationStatusAuthorized) {
        [self startRecord];
    }
}

- (void)startRecord {
    //开始录制
    noteButton.enabled = NO;  //录制过程中禁止点击注意事项按钮
    limitStop = NO;
    recDot.backgroundColor = [UIColor colorWithHex:@"#D0021B"];
    
    //麦克风权限检测
    
    [audioManager startRecord];  //录制时音频文件路径已经创建
    [volumeView recordStart];  //绘制波形
    recordState = Record_recording;  //正在录音
    
    recordTipView.hidden = YES;  //开始采集录音提示
    recordNoTalkTipLabel.text = @"请不要说话采集即将开始";
    recordNoTalkTipView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        recordNoTalkTipView.hidden = YES;
    });
    
    //倒计时
    [recordButton setTitle:@"3" forState:UIControlStateNormal];
    recordButton.userInteractionEnabled = NO;  //禁止点击
    
    if (!countDownTimer || !countDownTimer.isValid) {
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(countDown:)
                                                        userInfo:nil
                                                         repeats:YES];
        
    }
    
    
    
    if (!recordTimer || !countDownTimer.isValid) {
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(recordTimerAction)
                                                     userInfo:nil
                                                      repeats:YES];
    }
}

/* 停止录制 */
-(void)stopRecord {
    recDot.backgroundColor = GreenColor;
    
    [audioManager stopRecord];  //停止录音
    recordState = Record_endRecord;  //更新录制状态
    
    [recordTimer invalidate];  //失效录制计时器
    recordTimer = nil;

    recordButton.userInteractionEnabled = YES;  //停止录音后允许开始录制   test......
    noteButton.enabled = YES;  //停止录制后允许点击注意事项按钮
    
    [recordButton setBackgroundImage:[UIImage imageNamed:@"开始采集"] forState:UIControlStateNormal];
    
    //试听和下一条处理
    listenBtn.alpha = 1.0;
    listenBtn.enabled = YES;
    nextBtn.alpha = 1.0;
    nextBtn.enabled = YES;
    
    //只在第一段语料提示
    if (_currentCount == 1) {
        listenTipView.hidden = NO;
        listenTipLabel.text = @"预览试听";
        saveTipView.hidden = NO;
    }
    
    
    
    if (self.status == Checking) {
        if (!self.re_recording) {
            //未质检
            saveTipLabel.text = @"保存";
        } else {
            //未通过
            if (_currentCount == 1) {
                saveTipLabel.text = @"保存并下一条";
            }
        }
    } else {
        if (_currentCount == 1) {
            saveTipLabel.text = @"保存并下一条";
        }
    }
    
   if (_currentCount == _allCount) {
        if (self.status == Checking) {
            if (!self.re_recording) {
                if (_currentCount == _allCount) {
                    saveTipLabel.text = @"保存";
                    [nextBtn setImage:[UIImage imageNamed:@"提交全部"] forState:UIControlStateNormal];
                }
            } else {
                saveTipLabel.text = @"保存并提交任务";
            }
        } else {
            saveTipLabel.text = @"保存并提交任务";
        }
    }

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        listenTipView.hidden = YES;
        saveTipView.hidden = YES;
    });
}

/* 已达录制时限自动停止录音 */
- (void)timeToStop {
    limitStop = YES;  //避免超时判断里再走一遍
    recordButton.selected = NO;
    
    [recordButton setTitle:@"3" forState:UIControlStateNormal];
    recordButton.userInteractionEnabled = NO;
    
    if (!countDownTimer || !countDownTimer.isValid) {
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    }

    recordNoTalkTipLabel.text = @"请不要说话采集即将结束";
    recordNoTalkTipView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        recordNoTalkTipView.hidden = YES;
        [self stopRecord];
    });
    limitStop = YES;  //避免超时判断里再走一遍
}


/* 录制倒计时 */
-(void)countDown:(NSTimer *)timer {
    countDownCount++;  //倒计时
    NSLog(@"倒计时开始：%i",countDownCount);
    
    if (countDownCount >= 3) {
        recordButton.userInteractionEnabled = YES;  //倒计时结束允许点击
        
        //关闭计数器并失效
        countDownCount = 0;
        [countDownTimer invalidate];
        countDownTimer = nil;
        
        [recordButton setBackgroundImage:[UIImage imageNamed:@"结束采集"] forState:UIControlStateNormal];
        [recordButton setTitle:@"" forState:UIControlStateNormal];
        
        if (!limitStop && currentIndex == 0) {
            //若是超过录制时长，不需要弹阅读
            readTipView.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                readTipView.hidden = YES;
            });
        }
        
    } else {
        recordButton.userInteractionEnabled = NO;  // //倒计时，禁止点击
        [recordButton setTitle:[NSString stringWithFormat:@"%d",3 - countDownCount] forState:UIControlStateNormal];
    }
}

/* 录制时长 */
-(void)recordTimerAction {
    if (recordState == Record_recording) {
        if (recordTimer) {
            recordTimeCount++;
            NSLog(@"recordTimeCount  %li",(long)recordTimeCount);
        }
    }
    //显示录制时长
    NSString *recordHMS = [NSString getHHMMSSFromSS:recordTimeCount];
    timeLabel.text = recordHMS;

//  实现毫秒计时器
//    NSString *duration = [NSString getMinute_Second_millisecond:recordTimeCount];
//    timeLabel.text = duration;
    

    
    //提示时间为当前3s倒计时 + 时长限制时间
    if (recordTimeCount >= _timelimit + 3) {
        //超过规定录制时长
        if (!limitStop) {
            limitStop = YES;
        
            [self showMessage:@"已达录制时限"];  //设计错误，并没有提交，本地（）保存
//            [self recordButtonAction:recordButton];  //停止录制
            
            [self timeToStop];
        }
    }
}


/* 预览试听 */
-(void)listenBtnAction:(UIButton *)btn {
    //清除录音波形图
    [volumeView clearView];
    //预览或取消
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [self noClick];

        recordState = Record_listen;
        [btn setImage:[UIImage imageNamed:@"取消试听"] forState:UIControlStateNormal];
    
        NSURL *currentUrl = [audioManager recordCurrentAudioURL];
        [audioManager playAudioWithUrl:currentUrl];
        
        //播放音频时重新绘制波形图
        playCounterTimer = [NSTimer scheduledTimerWithTimeInterval:0.250f target:self selector:@selector(getAudioPlayerPower) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:playCounterTimer forMode:NSRunLoopCommonModes];
        
        listenTipLabel.text = @"取消试听";
        listenTipView.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            listenTipView.hidden = YES;
        });
    } else {
        [self allowClick];
        [btn setImage:[UIImage imageNamed:@"试听"] forState:UIControlStateNormal];
        recordState = Record_endRecord;
        [audioManager stopPlay];
        [self stopPlayCounterTimer];  //取消预览音频
    }
    
    
}
/* 禁止点击 */
- (void)noClick {
    noteButton.enabled = NO;
    cancelButton.enabled = NO;
    nextBtn.enabled = NO;
    recordButton.enabled = NO;
}

/* 允许点击 */
- (void)allowClick {
    noteButton.enabled = YES;
    cancelButton.enabled = YES;
    nextBtn.enabled = YES;
    recordButton.enabled = YES;
}

/* 停止绘制波形图 */
- (void)stopPlayCounterTimer {
    BOOL playing = [audioManager getAudioPlayerState];
    if (!playing) {
        [playCounterTimer invalidate];
        playCounterTimer = nil;
        [self allowClick];  //预览自动停止
    }
}

/* 预览音频时重新绘制波形图 */
- (void)getAudioPlayerPower {
    [self stopPlayCounterTimer];
    CGFloat power = [audioManager getAudioPlayerPower];  //获取播放机里音频峰值
    [volumeView reRedraw:power];  //清除录音波形图，重新绘制播放波形图
}

#pragma mark == 上传 ==

/* 保存并进入下一条 *
 * 提交录制完成的音频文件
 */

- (void)saveAndNextAction {
    nextBtn.enabled = NO;
    
    BOOL is = [BBNetWorkManager networkReachability];
    if (!is) {
        //断网
        if (self.re_recording) {
            //未质检 未通过界面无网络不允许继续录制
            [self showMessage:@"请检查网络连接是否正常"];
            nextBtn.enabled = YES;
            return;
        } else {
            //断网录制
            //待录制已录制最后提交时再检测网络提示
            [self uploadAudioData];
        }
    } else {
        //弱网
        //备注：待录制任务允许断网弱网录制最后提交
        //临时解决弱网下上传音频到阿里云时返回太慢导致页面卡死的情况
        //simpleping 在4G情况下ping不通百度，特殊处理
        NSString *networkType = [[BBNetWorkManager shared] getNetworkType];
        if ([networkType isEqualToString:@"WWAN"]) {
            [self uploadAudioData];
        } else {
            manager = [PingManager startPing:@"" result:^(BOOL result) {
                if (!result) {
                    [self showMessage:@"请检查网络环境"];  //弱网不保存到DB 临时替代方案
                    nextBtn.enabled = YES;
                    return ;
                } else {
                    [self uploadAudioData];
                }
            }];
        }
    }
    
}

/* 上传音频文件 */
- (void)uploadAudioData {
    cancelButton.enabled = NO;  //禁止退出
    
    if (_currentCount == _allCount-1) {
        [nextBtn setImage:[UIImage imageNamed:@"提交全部"] forState:UIControlStateNormal];
    }
    
    if (_currentCount > _allCount) {
        //防止越界
        currentIndex --;
        _currentCount--;
    
    }
    
    //获取当前子任务ID
    NSString *audioId = self.audioIdArr[currentIndex];
    NSString *audioLocalUrlStr = [audioManager recordCurrentAudioFile];
    NSURL *audioLocalUrl = [audioManager recordCurrentAudioURL];
    
    //更新数据库当前子任务文件本地路径
    [kBBDataManager upDataBaseTaskID:_task_id subTaskID:audioId localFile:audioLocalUrlStr];
    
    //断网全部提交时停留在最后的语料界面
    BOOL is = [BBNetWorkManager networkReachability];
    if (_currentCount == _allCount) {
        if (!is) {
            [self showMessage:@"请检查网络连接是否正常"];
            cancelButton.enabled = YES;
            nextBtn.enabled = YES;
            return;
        }
    }
    
    
    NSData *audioData = [NSData dataWithContentsOfURL:audioLocalUrl];  //音频二进制文件

    
    /**********************************************************************************************/
    ossManager.contentUrl = [NSString stringWithFormat:@"%@/ios_%@",_task_id,kAppCacheInfo.userId];
    /**********************************************************************************************/
    
    
    //上传音频文件到阿里云获取阿里云Url
    [ossManager asyncUploadAudio:audioData callback:^(BOOL success, NSString * _Nonnull msg, NSArray<NSString *> * _Nonnull keys) {
        cancelButton.enabled = YES;  //允许退出
    

        if (success) {
            //成功返回
            NSString *audioUrl = keys[0];  //阿里云返回audio url
            NSLog(@"------> 上传audio阿里云返回的url:  %@",audioUrl);
            
            //更新当前子任务的  上传阿里云返回的audio url
            [kBBDataManager upDataBaseTaskID:_task_id subTaskID:audioId url:audioUrl];
            
            if (_currentCount > _allCount) {
//                nextBtn.enabled = NO;  //禁止连续点击下一个/保存

                dispatch_async(dispatch_get_main_queue(), ^{
                    taskCollectionView.hidden = YES;
                    noTaskView.hidden = NO;
                    recordButton.alpha = 0.3;
                    recordButton.enabled = NO;

                    if (self.status == Checking) {
                        if (!self.re_recording) {
                            //未质检语料保存但不提交，与未通过录音完成一起提交
                            NSString *message = @"该条目已录制完成\n请将未通过中所有语料录制完成后一并提交";
                            TaskToastView *toast = [[TaskToastView alloc] init:message];
                            kWeak_self
                            toast.taskBlock = ^{
                                [weakSelf popToViewController];
                            };
                        } else {
                            [self reSaveUrlWithType];  //直接走重录重新提交接口
                        }
                    } else {
                        [self submitUrls];  //上传任务
                    }
                });
            }
            
        } else {
            //失败返回
            if (_currentCount > _allCount) {
                //防止越界
                currentIndex --;
                _currentCount--;
                BOOL is = [BBNetWorkManager networkReachability];
                if (!is) {
                    [self showMessage:@"请检查网络连接是否正常"];
                    if (self.re_recording) {
                        return;
                    }
                }
            }
        }
    }];
    
    if (_currentCount < _allCount) {
        currentIndex ++; //这个是从0开始的，做偏移
        _currentCount++; //这是从未录制条数开始的，做显示
        
        float offsetX = (cellWidth+10)*currentIndex;
        [UIView animateWithDuration:0.33 animations:^{
            taskCollectionView.contentOffset = CGPointMake(offsetX, 0);
        }];
        
        if (_currentCount <= _allCount) {
            NSString *indexStr = [NSString stringWithFormat:@"%02d/%02d",_currentCount,_allCount];
            NSMutableAttributedString *indexAtt = [[NSMutableAttributedString alloc]initWithString:indexStr];
            [indexAtt addAttributes:@{
                                      NSFontAttributeName:kFontRegularSize(12),
                                      NSForegroundColorAttributeName:[UIColor colorWithHex:@"#9499A1"]
                                      } range:NSMakeRange(0, indexAtt.length)];
            [indexAtt addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#00C397"] range:NSMakeRange(0, 2)];
            indexLabel.attributedText = indexAtt;
            indexLabel.textAlignment = NSTextAlignmentCenter;
        }
        //左右按钮变化
        listenBtn.alpha = 0.3;
        listenBtn.enabled = NO;
        
        nextBtn.alpha = 0.3;
        nextBtn.enabled = NO;
        
        timeLabel.text = @"00:00:00";
        recordTimeCount = 0;
        [volumeView clearView];
        [volumeView recordStart];
        
        recordState = Record_initial;
        limitStop = NO;
        
    } else {
        //异步任务的原因先++
        currentIndex ++; //这个是从0开始的，做偏移
        _currentCount++; //这是从未录制条数开始的，做显示
    }
    nextBtn.enabled = NO;  //禁止连续点击下一个/保存
}

- (void)popToViewController {
    NSMutableArray *vcArray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    BBTipDetailListViewController *vc = [[BBTipDetailListViewController alloc] init];
    vc.task_id = self.task_id;
    
    if (self.status == Checking) {
        if (self.re_recording) {
            //未通过录音时未全部录制完成退出时删除未通过的所有语料
            for (int i = 0; i < self.audioIdArr.count; i++) {
                [kBBDataManager deleteSubTaskWithTaskID:self.task_id subTaskID:self.audioIdArr[i]];
            }
        }
        [vc tag:Checking];
    } else {
        [vc tag:NoRefer];
    }
    
    for (UIViewController *_vc in vcArray) {
        if ([_vc isKindOfClass:[BBTipDetailListViewController class]]) {
            [vcArray replaceObjectAtIndex:[vcArray indexOfObject:_vc] withObject:vc];
            break;
        }
    }
    [self.navigationController setViewControllers:vcArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveToDBAndUploadAudio {
    
}

#pragma mark == 提交 ==
/* 提交 上传Audio文件到阿里云 */
-(void)submitUrls {
    _retry = 3;  //重试3次
    [self updateAudio:0];
}

/* 再次提交 */
-(void)reSubmitUrls {
    _retry = 3;
    [self updateAudio:1];
}

/* 提交音频文件
 * type = 0 提交 type = 1 更新
 */
- (void)updateAudio:(NSInteger)type {
    BOOL is = [BBNetWorkManager networkReachability];
    if (!is) {
        [self showMessage:@"请检查网络连接是否正常"];
        return;
    }

    // 单前任务 的子任务 有未上传的  需要重新上传
    if ([kBBDataManager getAllSubTaskCountWithNotHaveUploadUrlTaskID:_task_id] > 0) {
        dispatch_group_t group = dispatch_group_create();
        int i = 0;
        for (BBDataManagerModel *model in [kBBDataManager getSubTaskNotHaveUploadUrlWithTaskID:_task_id]) {
            [self.audioUrlArr addObject:@""];
            //上传阿里云
            [self updateAudioOSSWithFile:model.subTaskLocalFile subTaskeID:model.subTaskId group:group count:i];
            i++;
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            BOOL success = YES;
            //循环 查询是否还有未上传的 音频
            for (NSString *url in self.audioUrlArr) {
                if (![url isValidString]) {
                    success = NO;
                    break ;
                }
            }
            if (success) {
                if (type == 0) {
                    [self saveUrlWithType];
                }else {
                    [self reSaveUrlWithType];
                }
            } else {
                if (_retry>0) {
                  
                    _retry --;
                    [self updateAudio:type];
                
                }else {
                    [self showMessage:@"任务提交失败，请稍后再试" block:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }
        });
        
    } else {
        //提交数据
        if (type == 0) {
             [self saveUrlWithType];
        } else {
             [self reSaveUrlWithType];
        }
    }
    
}
//上传阿里云audiodata
- (void)updateAudioOSSWithFile:(NSString *)file subTaskeID:(NSString *)subTaskeID group:(dispatch_group_t)grout_t count:(int)count {
    NSData *audioData = [NSData dataWithContentsOfURL:[audioManager recordCurrentAudioURL]];
    dispatch_group_enter(grout_t);
    
    /**********************************************************************************************/
    ossManager.contentUrl = [NSString stringWithFormat:@"%@/ios_%@",_task_id,kAppCacheInfo.userId];
    /**********************************************************************************************/
    
    [ossManager asyncUploadAudio:audioData callback:^(BOOL success, NSString * _Nonnull msg, NSArray<NSString *> * _Nonnull keys) {
        dispatch_group_leave(grout_t);
        if (success) {
            NSString *audioUrl = keys[0];
            //更新当前子任务的  上传阿里云的url
            [self.audioUrlArr replaceObjectAtIndex:count withObject:audioUrl];
            [kBBDataManager upDataBaseTaskID:_task_id subTaskID:subTaskeID url:audioUrl];
        }
    }];
}
/* 提交阿里云返回的Audio url到本地Server
 * type = 0, 提交， type = 1 更新
 */
- (void)saveUrlWithType {
    BOOL is = [BBNetWorkManager networkReachability];
    if (!is) {
        [self showMessage:@"请检查网络连接是否正常"];
        return;
    }
    
    //准备所有audio url
    NSMutableArray * audioArr = [NSMutableArray new];
    for (BBDataManagerModel *model in [kBBDataManager getAllSubTaskWithTaskID:_task_id]) {
        NSMutableDictionary *urlDic = [NSMutableDictionary new];
        [urlDic setObject:model.subTaskText forKey:@"audioText"];
        [urlDic setObject:model.subTaskUrl forKey:@"audioUrl"];
        [audioArr addObject:urlDic];
    }
    NSDictionary *params = @{
                              @"taskId":_task_id,
                              @"audioUrlList":audioArr
                            };
    
    //上传服务端阿里云Audio url列表
    
    [[BBRequestManager sharedInstance] uploadUserTaskWithParams:params
      success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [kBBDataManager deleteTaskWithTaskID:_task_id];  //上传成功删除数据库当前所有任务
          dispatch_async(dispatch_get_main_queue(), ^{
              taskCollectionView.hidden = YES;
              noTaskView.hidden = NO;
              recordButton.alpha = 0.3;
              recordButton.enabled = NO;
              
              
              __block  ToastView *toastView = [[ToastView alloc] init];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  toastView.hidden = YES;
                  
                  BBTaskSuccessView * vc = [[BBTaskSuccessView alloc] init];
                  kWeak_self
                  vc.TaskSuccessBlock = ^{
                      if (toastView.hidden == YES) {
                          [weakSelf.navigationController popToRootViewControllerAnimated:YES];  //点击返回
                      }
                  };
              });
          });
    } failure:^(NSString * _Nonnull error) {
        [self showMessage:@"提交音频失败提示文案：音频文件损坏导致上传失败，需重新录制后提交" block:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

//未通过重新提交
-(void)reSaveUrlWithType {
    BOOL is = [BBNetWorkManager networkReachability];
    if (!is) {
        [self showMessage:@"请检查网络连接是否正常"];
        return;
    }

    NSMutableArray *failurePassurlArray = @[].mutableCopy;  //未通过中有url的
    for (int i = 0; i < self.audioIdArr.count; i++) {
        BBDataManagerModel *model = [kBBDataManager getSubTaskWithTaskID:self.task_id subTaskID:self.audioIdArr[i]];
        if (model.subTaskUrl && model.subTaskUrl.length > 0) {
            [failurePassurlArray addObject:model];
        }
    }

    if (failurePassurlArray.count < self.audioIdArr.count) {
        [self showMessage:@"请重新录制"];  //总数>=未通过数时才能提交
        return;
    }
    
    //所有已录制
    NSArray *allLocalUrlArray = [kBBDataManager getSubTaskHaveUrlWithTaskID:self.task_id];
    
    NSMutableArray *subTaskUrlsArray = @[].mutableCopy;
    for (int i = 0; i < allLocalUrlArray.count; i++) {
        BBDataManagerModel *model = allLocalUrlArray[i];
        NSString *idStr = model.subTaskId;
        NSString *subTaskUrl = model.subTaskUrl;  //更新过的阿里云
        NSMutableDictionary *urlDicurlDic = @{
                                               @"id":idStr,
                                               @"audioUrl":subTaskUrl
                                             }.mutableCopy;
        [subTaskUrlsArray addObject:urlDicurlDic];
    }
    NSDictionary *params = @{
                              @"taskId":_task_id,
                              @"audioUrlList":subTaskUrlsArray
                            };

    [[BBRequestManager sharedInstance] updateAudioWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [kBBDataManager deleteTaskWithTaskID:_task_id];  //提交成功情况清空数据库

        dispatch_async(dispatch_get_main_queue(), ^{
            taskCollectionView.hidden = YES;
            noTaskView.hidden = NO;
            recordButton.alpha = 0.3;
            recordButton.enabled = NO;
            
       
            __block  ToastView *toastView = [[ToastView alloc] init];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               toastView.hidden = YES;
            
               BBTaskSuccessView * vc = [[BBTaskSuccessView alloc] init];
               kWeak_self
               vc.TaskSuccessBlock = ^{
                   if (toastView.hidden == YES) {
                       [weakSelf.navigationController popToRootViewControllerAnimated:YES];  //点击返回
                   }
               };
            });
        });
    } failure:^(NSString * _Nonnull error) {
        [kBBDataManager deleteTaskWithTaskID:_task_id];  //提交失败清空数据库
        [self showMessage:@"提交音频失败提示文案：音频文件损坏导致上传失败，需重新录制后提交" block:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark == AudioRecorder delegte ==
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder*)recorder successfullyFlag:(BOOL)flag{
    [recordTimer invalidate];
//    recordTimer = nil;
}

-(void)audioPowerChange:(CGFloat)power{
    [volumeView audioPowerChange:power];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMessage:@"播放结束"];
        [listenBtn setImage:[UIImage imageNamed:@"试听"] forState:UIControlStateNormal];
        listenBtn.selected = NO;
    });
}

#pragma mark == Collection datasource & delegate ==

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.audioTextArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    BBCollectAudioViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    if (self.status == Checking) {
//        if (!self.re_recording) {
//        }
//    }
    
    NSString *text = self.audioTextArr[indexPath.item];
    NSString *subText = [text substringFromIndex:2];  //截取数字和点
    cell.audioText = subText;
    
    
//    cell.audioText = self.audioTextArr[indexPath.item];

    return cell;
}

- (NSMutableArray *)audioUrlArr {
    if (!_audioUrlArr) {
        _audioUrlArr = [NSMutableArray new];
    }
    return _audioUrlArr;
}

- (void)dealloc {
    [recordTimer invalidate];
    recordTimer = nil;
    [countDownTimer invalidate];
    countDownTimer = nil;
}

@end
