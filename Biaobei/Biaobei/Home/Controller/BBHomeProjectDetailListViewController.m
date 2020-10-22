//
//  BBHomeProjectDetailListViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/7.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeProjectDetailListViewController.h"
#import "BBMineDertailCellModel.h"
#import "BBMineDetailBeanModel.h"
#import "BBMineDetailListBeanModel.h"
#import "BBCollectAudioViewController.h"
#import "BBAudioManager.h"
#import "AppDelegate.h"
#import "BBOssUploadManager.h"

#import "UnqualifiedBeanModel.h"
#import "UnqualifiedCellModel.h"
#import "UnqualifiedListBeanModel.h"

NSInteger unQIndex;  //未质检列表Row
BOOL selceted;  //未质检cell选中
int lastSelectedIndex;


@interface BBHomeProjectDetailListViewController ()

@property (nonatomic, strong) NSMutableArray * audioArr;//临时记录 音频数组

@end

@implementation BBHomeProjectDetailListViewController {
    UIButton *submitBtn;
    
    BBTaskDetailModel *detailModel;
    
    NSInteger currentCount;
    NSInteger allCount;
    BBOssUploadManager *ossManager;
    NSInteger _retry;//参数次数 3次
    
    NSMutableArray *failedToPassArray;  //未通过
    NSMutableArray *unqualifiedArray;  //未质检
    
    UIView *listenAndReRecordView;
    UIButton *listenButton;
    UIButton *reRecordButton ;
    
    UIView *taskView;  //任务背景图
}

#pragma mark == UIView ==

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    selceted = NO;
    lastSelectedIndex = 0;
    unQIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.view.backgroundColor = [UIColor orangeColor];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    [self getTaskDetail];
    if (_re_rec) {
        //是否可以重录，yes代表未通过未质检
        [self getNoPassAudioTextData];  //获取未通过音频列表
    } else {
        //代表未录制 已录制
        [self getAudioTextData];  //获取采集文本信息
        if (_hasRec) {
            //已录制
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
                make.bottom.mas_equalTo(-86);
            }];
            
            if (!submitBtn) {
                submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                submitBtn.frame = CGRectMake(30, self.view.height-85, SCREENWIDTH-60, 54);
                submitBtn.layer.cornerRadius = 27;
                [self.view addSubview:submitBtn];
                [submitBtn addTarget:self action:@selector(submitUrls) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    if (!self.initList) {
        self.initList = YES;
        [self refresh];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTaskStyle];
}

-(void)viewDidLayoutSubviews {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);  //距底部100
    //CGFloat top, left, bottom, right;
}


/* 未质检界面 */

- (void)setupUnqualifiedUI {
    //试听|重录按钮
    CGSize lrSize = CGSizeMake(SCREENWIDTH - 60 , 54);
    CGRect lrRect =  CGRectMake(30, self.view.height - 85, lrSize.width, lrSize.height);
    listenAndReRecordView = [[UIView alloc] initWithFrame:lrRect];
    listenAndReRecordView.backgroundColor = [UIColor redColor];
    listenAndReRecordView.layer.cornerRadius = 27;
    listenAndReRecordView.layer.masksToBounds = YES;
    
    CGRect listenRect = CGRectMake(0, 0, lrSize.width / 2, lrSize.height );
    listenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listenButton.frame = listenRect;
    [listenButton setTitle:@"试听" forState:UIControlStateNormal];
    [listenButton setTitleColor:[UIColor colorWithHex:@"#25C29B"] forState:UIControlStateNormal];
    listenButton.titleLabel.font = [UIFont systemFontOfSize:18];
    listenButton.backgroundColor = [UIColor whiteColor];
    [listenButton addTarget:self action:@selector(listen:) forControlEvents:UIControlEventTouchUpInside];
    [listenAndReRecordView addSubview:listenButton];
    
    CGRect reRecordRect = CGRectMake(lrSize.width / 2, 0, lrSize.width / 2, lrSize.height);
    reRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reRecordButton setTitle:@"重录" forState:UIControlStateNormal];
    reRecordButton.backgroundColor = [UIColor colorWithHex:@"#25C29B"];
    reRecordButton.titleLabel.font = [UIFont systemFontOfSize:18];
    reRecordButton.frame = reRecordRect;
    [reRecordButton addTarget:self action:@selector(reRecord:) forControlEvents:UIControlEventTouchUpInside];
    [listenAndReRecordView addSubview:reRecordButton];
    [self.view addSubview:listenAndReRecordView];
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
            NSLog(@"check local file data length: %tu   %i",audioData.length,i);
        }
    }
}
//test.....

#pragma mark == 获取数据 ==

-(void)getTaskDetail {
    if (String_IsEmpty(_task_id)) {
        [self showMessage:@"任务信息获取失败"];
        return;
    }
    NSDictionary *params = @{ @"taskId":_task_id };
    [[BBRequestManager sharedInstance] getTaskDetailWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        detailModel = (BBTaskDetailModel *)model;
        [BBAudioManager sharedInstance].taskDetailmodel = detailModel;
    } failure:^(NSString * _Nonnull error) {
    }];
}

//待优化
- (void)getDataCode {
    
}

//获取采集文本信息
- (void)getAudioTextData {
    NSString *dataCode = [kAppCacheInfo.dataCodeDic objectForKey:[NSString stringWithFormat:@"%@%@",_task_id, kAppCacheInfo.userId]];
    if (!dataCode) {
        NSDictionary *params = @{ @"taskId":_task_id };
        
        //获取数据码，用来获取采集文本信息
        [[BBRequestManager sharedInstance] getOldDataCodeWithParams:params
          success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
              NSDictionary *dataDic = responseObject[@"data"];
              NSString *old_dataCode = dataDic[@"datacode"];
                                                                
              //配置 userId taskId dataCode数据
              [kAppCacheInfo configUser_dataCodeDicWithTaskId:[NSString stringWithFormat:@"%@%@",_task_id,  kAppCacheInfo.userId] dataCode:old_dataCode];
              [self getAudioTextData];  //拿到后再次走这一步
                                                                
          } failure:^(NSString * _Nonnull error) {
            //[self showMessage:error];
          }];
        return;
    }
    
//    [self.dataListArray removeAllObjects];
    
    NSDictionary *params = @{
                              @"taskId":_task_id,
                              @"datacode":dataCode
                            };
    
    [[BBRequestManager sharedInstance] getTaskAudioTextWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        //获取采集文本信息
        NSArray *dataArr = responseObject[@"data"];
        for (NSDictionary *dic in dataArr) {
            //把子任务插入数据库
            [kBBDataManager insertToDataBaseWithTaskID:_task_id subTaskID:dic[@"id"] subTaskText:dic[@"audioText"]];
        }
        [self loadTaskUI];
    } failure:^(NSString * _Nonnull error) {
        BOOL is = [BBNetWorkManager networkReachability];
        if (!is) {
            //网络不存在时从DB中取数据
            [self showMessage:@"请检查网络连接是否正常"];
            [self loadTaskUI];
        }
    }];
    
}

/* 获取未通过音频列表 */

-(void)getNoPassAudioTextData {
    [self.dataListArray removeAllObjects];  //重新获取未通过列表
    
    failedToPassArray = @[].mutableCopy;
    unqualifiedArray = @[].mutableCopy;
    
    NSDictionary *params = @{ @"taskId":_task_id };
    [[BBRequestManager sharedInstance] getNopassListWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        NSArray *dataArr = responseObject[@"data"];
        currentCount = 1;
        allCount = dataArr.count;
        
        NSMutableArray *unTextArray = [[NSMutableArray alloc] init];  //正序
        NSMutableArray *failTextArray = [[NSMutableArray alloc] init];  //正序


        for (NSInteger i = 0; i < dataArr.count; i++) {
            @autoreleasepool {
                NSDictionary *audioDic = dataArr[i];
                NSString *audioText = audioDic[@"audioText"];
                NSInteger status = [audioDic[@"status"] integerValue];
                if (status == 0) {
                    [unTextArray addObject:audioText];
                }
            }
        }
        
        for (NSInteger i = 0; i < dataArr.count; i++) {
            @autoreleasepool {
                NSDictionary *audioDic = dataArr[i];
                NSString *audioText = audioDic[@"audioText"];
                NSInteger status = [audioDic[@"status"] integerValue];
                if (status == 2) {
                    [failTextArray addObject:audioText];
                }
            }
        }
        
        //加入序号
        NSMutableArray *sUnTextArray = [[NSMutableArray alloc] init];  //正序
        NSMutableArray *sFailTextArray = [[NSMutableArray alloc] init];  //正序
        for (NSInteger i = 0; i < unTextArray.count; i++) {
            @autoreleasepool {
                NSString *text = [NSString stringWithFormat:@"%li.%@",(long)i + 1, unTextArray[i]];  //加序号
                NSString *audioText = text;
                [sUnTextArray addObject:audioText];
            }
        }
        
        for (NSInteger i = 0; i < failTextArray.count; i++) {
            @autoreleasepool {
                NSString *text = [NSString stringWithFormat:@"%li.%@",(long)i + 1, failTextArray[i]];  //加序号
                NSString *audioText = text;
                [sFailTextArray addObject:audioText];
            }
        }
        
        NSInteger j = 0;
        NSInteger k = 0;
        for (NSInteger i = 0; i < dataArr.count; i++) {
            @autoreleasepool {
              

            NSDictionary *audioDic = dataArr[i];
            NSString *audioText = audioDic[@"audioText"];
            NSString *audioId = audioDic[@"id"];
            NSInteger status = [audioDic[@"status"] integerValue];  //区分语料状态  0-未质检 1-通过 2-未通过 3-重新修改
            NSString *audioUrl = audioDic[@"audioUrl"];
            
//            BOOL isExist = [kBBDataManager getTaskWithTaskID:self.task_id];  //任务是否存在
            
            //语料是否存在
            BOOL isExist = NO;
            BBDataManagerModel *model = [kBBDataManager getSubTaskWithTaskID:self.task_id subTaskID:audioId];
            if (model) {
                isExist = YES;
            }

  
            if (status == 0) {
                //未质检列表
                //查询db未质检列表，如果不存在则插入和更新
                if (!isExist) {
                    [kBBDataManager insertToDataBaseWithTaskID:_task_id subTaskID:audioId subTaskText:audioText];
                    [kBBDataManager upDataBaseTaskID:_task_id subTaskID:audioId url:audioUrl];  //存储阿里云Url,试听用
                }
                
               
                
                UnqualifiedCellModel * unqualifiedCellModel = [[UnqualifiedCellModel alloc]initWithData:nil];
                UnqualifiedBeanModel * unqualifiedBeanModel = [[UnqualifiedBeanModel alloc] init];
                
                NSMutableArray *detailArray = [[NSMutableArray alloc] init];
                
              
//                unqualifiedBeanModel.audioText = [NSString stringWithFormat:@"%li.%@",j + 1, audioText];  //加序号
     
                unqualifiedBeanModel.audioText = sUnTextArray[j++];

//                unqualifiedBeanModel.audioText = audioText;
                unqualifiedBeanModel.audioUrl = audioUrl;

                unqualifiedBeanModel.rec_id = audioId;
                unqualifiedBeanModel.noTap = YES;
                unqualifiedBeanModel.selectImageName = @"unSelectImage";  //初始全部未选中
                unqualifiedBeanModel.recordedImageName = @"";
                
                if (model.subTaskLocalFile && model.subTaskLocalFile.length > 0) {
                    unqualifiedBeanModel.recordedImageName = @"recordedImage";
                }

                [detailArray addObject:unqualifiedBeanModel];
                
                UnqualifiedListBeanModel *listBeanModel = [[UnqualifiedListBeanModel alloc] init];
                listBeanModel.detailArray = detailArray;
                unqualifiedCellModel.beanModel = listBeanModel;
                [unqualifiedArray addObject:unqualifiedCellModel];
                
                ///////////////////////////////////////////////////////////////////
                
                
                ///////////////////////////////////////////////////////////////////

            } else if (status == 2) {
                //未通过列表
                //未通过列表db始终是最新
                [kBBDataManager insertToDataBaseWithTaskID:_task_id subTaskID:audioId subTaskText:audioText];
                [kBBDataManager upDataBaseTaskID:_task_id subTaskID:audioId url:@""];  //阿里云url清空
            
                //未通过列表
                BBMineDertailCellModel * cellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
                BBMineDetailBeanModel * beanModel = [[BBMineDetailBeanModel alloc] init];
                NSMutableArray<BBMineDetailBeanModel> *detailArray = [[NSMutableArray<BBMineDetailBeanModel> alloc] init];
                
                beanModel.title = sFailTextArray[k++];  //加序号

//                beanModel.title = audioText;  //加序号
                beanModel.rec_id = audioId;
                beanModel.noTap = YES;
                [detailArray addObject:beanModel];
                BBMineDetailListBeanModel * listBeanModel = [[BBMineDetailListBeanModel alloc] init];
                listBeanModel.detailArray = detailArray;
                cellModel.beanModel = listBeanModel;
                [failedToPassArray addObject:cellModel];
            }
        }
    }
        
        //重新排序
        
        
        
        
            
        if (self.no_pass) {
            [self hiddenUnqualifiedView];
            listenAndReRecordView.hidden = YES;
            self.dataListArray = failedToPassArray;  //未通过
        } else {
            if (unqualifiedArray.count > 0) {
                [self setupUnqualifiedUI];  //试听|重录  有数据时显示
                if (!selceted) {
                    listenButton.enabled = NO;
                    reRecordButton.enabled = NO;
                    [listenButton setTitleColor:[UIColor colorWithHex:@"#BABABA"] forState:UIControlStateNormal];  //灰色
                    reRecordButton.backgroundColor = [UIColor colorWithHex:@"#BABABA"];  //灰色
                } else {
                    listenButton.enabled = YES;
                    reRecordButton.enabled = YES;
                }
            }
            self.dataListArray = unqualifiedArray;  //未质检
        }
        if (self.dataListArray.count == 0) {
            [self hiddenTaskview:NO];
        }
        
        [self refresh];
    } failure:^(NSString * _Nonnull error) {
        //        [self showMessage:error];
    }];
}

#pragma mark == 试听和重录 ==

- (void)selectedUnqualifiedAudio {
    BBAudioManager *audioManager = [BBAudioManager sharedInstance];
    if ([audioManager getAudioPlayerState]) {
            [audioManager stopPlay];
    }

    if (!selceted) {
        listenButton.enabled = NO;
        reRecordButton.enabled = NO;
        [listenButton setTitleColor:[UIColor colorWithHex:@"#BABABA"] forState:UIControlStateNormal];  //灰色
        reRecordButton.backgroundColor = [UIColor colorWithHex:@"#BABABA"];  //灰色
    } else {
        listenButton.enabled = YES;
        reRecordButton.enabled = YES;
        [listenButton setTitleColor:[UIColor colorWithHex:@"#25C29B"] forState:UIControlStateNormal];
        reRecordButton.backgroundColor = [UIColor colorWithHex:@"#25C29B"];
    }
    
    if (unQIndex != lastSelectedIndex) {
        for (int i = 0; i < self.dataListArray.count; i++) {
            @autoreleasepool {
                UnqualifiedCellModel * cellModel = self.dataListArray[i];
                UnqualifiedListBeanModel *listBeanModel = (UnqualifiedListBeanModel *)cellModel.beanModel;
                UnqualifiedBeanModel *beanModel = listBeanModel.detailArray[0];
                
                if (i == lastSelectedIndex) {
                    beanModel.selectImageName = @"unSelectImage";  //未选中
                    NSArray *_array = @[beanModel].copy;
                    listBeanModel.detailArray = _array;
                    [self refreshSection:(int)lastSelectedIndex];
                    break;
                }
            }
           
        }
        
        for (int i = 0; i < self.dataListArray.count; i++) {
            @autoreleasepool {
                if (i == unQIndex) {
                    UnqualifiedCellModel * cellModel = self.dataListArray[i];
                    UnqualifiedListBeanModel *listBeanModel = (UnqualifiedListBeanModel *)cellModel.beanModel;
                    UnqualifiedBeanModel *beanModel = listBeanModel.detailArray[0];
                    
                    beanModel.selectImageName = @"selectedImage";  //选中
                    NSArray *array = @[beanModel].copy;
                    listBeanModel.detailArray = array;
                    lastSelectedIndex = i;
                    [self refreshSection:(int)unQIndex];
                    break;
                }
            }
        }
        
    } else {
        for (int i = 0; i < self.dataListArray.count; i++) {
            @autoreleasepool {
                UnqualifiedCellModel * cellModel = self.dataListArray[i];
                UnqualifiedListBeanModel *listBeanModel = (UnqualifiedListBeanModel *)cellModel.beanModel;
                UnqualifiedBeanModel *beanModel = listBeanModel.detailArray[0];
                
                if (i == unQIndex) {
                    beanModel.selectImageName = @"selectedImage";  //选中
                    NSArray *array = @[beanModel].copy;
                    listBeanModel.detailArray = array;
                    lastSelectedIndex = i;
                    [self refreshSection:(int)unQIndex];
                    break;
                }
            }
           
        }
        
    }
    
}

- (void)hiddenUnqualifiedView {
    listenAndReRecordView.hidden = YES;
}

/* 未质检语料试听 */
- (void)listen:(UIButton *)button {
    button.selected = !button.selected;

    BBAudioManager *audioManager = [BBAudioManager sharedInstance];
    if (button.selected) {
        if ([audioManager getAudioPlayerState]) {
            [audioManager stopPlay];
        }
    }
    
    UnqualifiedBeanModel *beanModel = nil;
    
    for (int i = 0; i < self.dataListArray.count; i++) {
        @autoreleasepool {
            UnqualifiedCellModel * cellModel = self.dataListArray[i];
            UnqualifiedListBeanModel *listBeanModel = (UnqualifiedListBeanModel *)cellModel.beanModel;
            if (i == unQIndex) {
                beanModel = listBeanModel.detailArray[0];
                break;
            }
        }
    }
    
    NSString *audioId = beanModel.rec_id;
    BBDataManagerModel *model = [kBBDataManager getSubTaskWithTaskID:self.task_id subTaskID:audioId];
    if (model.subTaskLocalFile && model.subTaskLocalFile.length > 0) {
        [[BBAudioManager sharedInstance] playAudioWithUrl:[NSURL fileURLWithPath:model.subTaskLocalFile]];
    } else {
        NSString *audioOnlineUrl = beanModel.audioUrl;
        [[BBAudioManager sharedInstance] playOnlineAudio:audioOnlineUrl];
    }
}

/* 未质检语料重录 */

- (void)reRecord:(UIButton *)button {
    BBAudioManager *audioManager = [BBAudioManager sharedInstance];
    if ([audioManager getAudioPlayerState]) {
        [audioManager stopPlay];
    }
    
    BOOL is = [BBNetWorkManager networkReachability];
    if (!detailModel) {
        if (!is) {
            [self showMessage:@"请检查网络连接是否正常"];
            return;
        } else {
            [self getTaskDetail];  //网络正常连接，重新请求任务详情
            [NSThread sleepForTimeInterval:0.3];
        }
    }
    
    if (!detailModel) {
        [self showMessage:@"请重试"];  //没拿到时长和噪音限制
        return;
    }
    NSMutableArray *audioTextArr = [[NSMutableArray alloc]init];
    NSMutableArray *audioIdArr = [[NSMutableArray alloc]init];
    
    UnqualifiedBeanModel *beanModel = nil;
    for (int i = 0; i < self.dataListArray.count; i++) {
        @autoreleasepool {
            UnqualifiedCellModel * cellModel = self.dataListArray[i];
            UnqualifiedListBeanModel *listBeanModel = (UnqualifiedListBeanModel *)cellModel.beanModel;
            if (i == unQIndex) {
                beanModel = listBeanModel.detailArray[0];
                [audioTextArr addObject:beanModel.audioText];
                [audioIdArr addObject:beanModel.rec_id];
                break;
            }
        }
    }
 
    BBCollectAudioViewController *collectAudioVC = [[BBCollectAudioViewController alloc] init];
    if (_no_pass) {
        collectAudioVC.re_recording = YES;  //重录提交时需要请求重新提交接口
    }
    if (_re_rec) {
        collectAudioVC.status = Checking;  //返回未质检未通过界面的标记
        
    }
    
    collectAudioVC.task_id = _task_id;
    collectAudioVC.audioTextArr = audioTextArr;
    collectAudioVC.audioIdArr = audioIdArr;
    collectAudioVC.currentCount = 1;
    collectAudioVC.serial = [NSString stringWithFormat:@"%li", (long)unQIndex + 1];  //语料序号

    collectAudioVC.allCount = 1;  //只能录制1条
    
    collectAudioVC.timelimit = detailModel.timelimit.intValue;
    collectAudioVC.noiseCap = detailModel.noiseCap.intValue;
    [self.navigationController pushViewController:collectAudioVC animated:YES];
}

#pragma mark == 提交 ==
/*
 * 提交任务
 * 上传阿里云url列表到本地服务端
 */
-(void)submitUrls {
    BOOL is = [BBNetWorkManager networkReachability];
    if (!is) {
        [self showMessage:@"请检查网络连接是否正常"];
        return;
    }
    _retry = 3;
    //开始提交
//    submitBtn.enabled = NO;
    [self updateAudio];
    
}
//上传数据
- (void)updateAudio {
    if([kBBDataManager getAllSubTaskCountWithNotHaveUploadUrlTaskID:_task_id]){
        
        dispatch_group_t group_t = dispatch_group_create();
        
        NSArray *arr = [kBBDataManager getSubTaskNotHaveUploadUrlWithTaskID:_task_id];
        for (int i = 0; i< arr.count; i ++) {
            //获取所有未上传的记录
            BBDataManagerModel *model = arr[i];
            [self.audioArr addObject:@""];//先插入一个标记
            NSString * taskFile = model.subTaskLocalFile;
            NSData *audioData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:taskFile]];

            //获取本地文件失败 需要重新录制
            if (audioData == nil) {
                [kBBDataManager upDataBaseTaskID:_task_id subTaskID:model.subTaskId localFile:@""];
                [self showMessage:@"本地文件加载失败，请重新录制" block:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                return;
            } else {
                [self updataOssFile:audioData row:i group:group_t subTaskID:model.subTaskId];
            }
            
            
        }
        dispatch_group_notify(group_t, dispatch_get_main_queue(), ^{
            //全部上传完成
            BOOL isSuccess = YES;
            for (NSString *str in self.audioArr) {
                if (![str isValidString]) {
                    //只要有空的 说明 上传阿里云失败
                    
                    isSuccess = NO;
                    break;
                }
            }
            if (isSuccess) {
                //真正的提交任务
                [self updataTask];
            } else {
                if (_retry >0) {
                    _retry --;
                    [self updateAudio];
                } else {
                    [self showMessage:@"提交失败，请稍后再试" block:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }
        });
    } else {
        [self updataTask];  //真正的提交任务
    }
}

//上传阿里云 文件 fileurl 文件路径， row 第几个
- (void)updataOssFile:(NSData *)audioData row:(int)row group:(dispatch_group_t)group subTaskID:(NSString *)subTaskID{
    dispatch_group_enter(group);
    ossManager = [BBOssUploadManager sharedInstance];
    
    /**********************************************************************************************/
    ossManager.contentUrl = [NSString stringWithFormat:@"%@/ios_%@",_task_id,kAppCacheInfo.userId];
    /**********************************************************************************************/
    
    [SVProgressHUD showWithStatus:@"正在提交..."];
    [ossManager asyncUploadAudio:audioData callback:^(BOOL success, NSString * _Nonnull msg, NSArray<NSString *> * _Nonnull keys) {
        [SVProgressHUD dismiss];
        

        dispatch_group_leave(group);
        if (success) {
            //成功的时候替换url
            [kBBDataManager upDataBaseTaskID:_task_id subTaskID:subTaskID url:keys[0]];
            [self.audioArr replaceObjectAtIndex:row withObject:keys[0]];
        }
    }];
}

/*
 * 提交任务
 * 上传阿里云返回的audio url列表到服务端
 */
- (void)updataTask {
    NSInteger  haveUrlInteger = [kBBDataManager getAllSubTaskCountWithNotHaveUrlTaskID:_task_id];

    //未提交的数据有 为录制的
    if (haveUrlInteger>0 && [kBBDataManager getAllSubTaskCountWithTaskID:_task_id] >0) {
        for (BBDataManagerModel *model in [kBBDataManager getSubTaskNotHaveUploadUrlWithTaskID:_task_id]) {
            [kBBDataManager upDataBaseTaskID:_task_id subTaskID:model.subTaskId localFile:@""];
        }
        [self showMessage:@"本地音频加载失败，需要重新录制" block:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    
    NSMutableArray * taskArray = [NSMutableArray new];
    for (BBDataManagerModel *model in [kBBDataManager getAllSubTaskWithTaskID:_task_id]) {
        NSDictionary *urlDic = @{
                                  @"audioText":model.subTaskText,
                                  @"audioUrl":model.subTaskUrl
                                };
     
        [taskArray addObject:urlDic];
    }
    
    NSDictionary *params = @{
                              @"taskId":_task_id,
                              @"audioUrlList":taskArray
                            };
    /**********************************************************************************************/
    ossManager.contentUrl = [NSString stringWithFormat:@"%@/ios_%@",_task_id,kAppCacheInfo.userId];
    /**********************************************************************************************/

    [SVProgressHUD showWithStatus:@"正在提交..."];
    [[BBRequestManager sharedInstance] uploadUserTaskWithParams:params
      success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [SVProgressHUD dismiss];
          
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 40018) {
            [self showMessage:@"已提交，请勿重复提交"];
            return;
        }
        [self showMessage:@"任务提交成功"];
        [kBBDataManager deleteTaskWithTaskID:_task_id];  //删除任务
          
        [submitBtn setTitle:@"任务已提交" forState:UIControlStateNormal];
        submitBtn.backgroundColor = NineColor;
        submitBtn.enabled = NO;

         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
           dispatch_get_main_queue(), ^{
               [self.navigationController popToRootViewControllerAnimated:YES];  //回首页
         });
          

    } failure:^(NSString * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self showMessage:@"任务提交异常"];
//        [self showMessage:error];
    }];
}

#pragma mark == 配置界面  ==

- (void)loadTaskUI {
    if (self.dataListArray && self.dataListArray.count > 0) {
        [self.dataListArray removeAllObjects];
    }

//    BOOL hasSubmitSuccess = [kBBDataManager hasAllTaskSubmitSuccess:self.task_id];  //提交成功  针对数据库不删除的情况
//    BOOL hasSubmitSuccess = [kBBDataManager getTaskWithTaskID:self.task_id];  //提交成功  针对数据库删除的情况
    NSInteger hasRecCount = [kBBDataManager getAllSubTaskCountWithHaveUrlTaskID:_task_id];//已录制条数 3
    currentCount = hasRecCount+1;
    allCount = [kBBDataManager getAllSubTaskCountWithTaskID:_task_id];//总条数
    
    //提交按钮的显示状态
    if (submitBtn) {
        if (hasRecCount == allCount) {
            submitBtn.enabled = YES;
            submitBtn.backgroundColor = GreenColor;
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [submitBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        } else {
            submitBtn.enabled = NO;
            submitBtn.backgroundColor = NineColor;
            [submitBtn setTitle:[NSString stringWithFormat:@"还有%ld条未录制",(long)[kBBDataManager getAllSubTaskCountWithNotHaveUrlTaskID:_task_id]] forState:UIControlStateNormal];
            [submitBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        }
    }
    
    //根据界面载入合适的数据
    NSArray * taskArray;
    if (_hasRec) {
        //已录制界面
        if (hasRecCount == 0) {
            //未录制任何语音或领取任务第一次进入
            taskArray = @[];
            [self hiddenTaskview:NO];
            
        } else {
            //全部上传，未提交成功  hasRecCount == allCount
            //部分上传
            [self hiddenTaskview:YES];
            taskArray = [kBBDataManager getSubTaskHaveUrlWithTaskID:_task_id];
        }
    } else {
        //待录制界面
        if (hasRecCount == allCount) {
            //全部上传，未提交成功
            [self hiddenTaskview:NO];
            taskArray = @[];
        } else if (hasRecCount == 0) {
            //未录制任何语音或领取任务第一次进入
            taskArray = [kBBDataManager getAllSubTaskWithTaskID:_task_id];
        } else {
            //部分上传
            taskArray = [kBBDataManager getSubTaskNotHaveUrlWithTaskID:_task_id];
        }
    }
   
    //载入Cell
    int i = 0;
    for (BBDataManagerModel *model in taskArray) {
        NSMutableArray<BBMineDetailBeanModel> * identerArray = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
        
        BBMineDertailCellModel * cellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
        
        BBMineDetailBeanModel * beanModel = [[BBMineDetailBeanModel alloc]init];
        
        beanModel.title = [NSString stringWithFormat:@"%d.%@",i+1,model.subTaskText];  //加序号
        beanModel.rec_id = model.subTaskId;//子任务id
        beanModel.noTap = YES;
        [identerArray addObject:beanModel];
        
        BBMineDetailListBeanModel * listBeanModel = [[BBMineDetailListBeanModel alloc]init];
        listBeanModel.detailArray = identerArray;
        cellModel.beanModel = listBeanModel;
        [self.dataListArray addObject:cellModel];
        i++;
    }
    
    if (self.dataListArray.count == 0) {
        taskView.hidden = NO;
    } else {
        taskView.hidden = YES;
    }
    
    
    
    
    [self refresh];
}


- (void)initTaskStyle {
    //无任务背景
    taskView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH - 150) / 2, (SCREENHEIGHT - 110) / 2 - 139, 150, 110)];
    taskView.backgroundColor = [UIColor clearColor];
    taskView.hidden = YES;  //初始化时隐藏无任务背景
    [self.view addSubview:taskView];
    
    UIImageView *noImgView = [[UIImageView alloc]initWithFrame:CGRectMake((150 - 46) / 2, 0, 46, 51)];
    noImgView.image = [UIImage imageNamed:@"Combined Shape"];
    [taskView addSubview:noImgView];
    
    UILabel *noLabel = [[UILabel alloc]initWithFrame:CGRectMake(noImgView.left-5, noImgView.bottom+10, 150, 20)];
    noLabel.textColor = [UIColor colorWithHex:@"#8890A9"];
    noLabel.font = kFontRegularSize(14);
    //    noLabel.text = @"暂无任务\n你可以“回到首页”领取";
    noLabel.text = @"暂无数据";
    noLabel.numberOfLines = 0;
    [noLabel sizeToFit];
    noLabel.textAlignment = NSTextAlignmentCenter;
    [taskView addSubview:noLabel];
}

- (void)hiddenTaskview:(BOOL)hidden {
    taskView.hidden = hidden;
}

#pragma mark == TableView delegate  ==

-(void)didSelectItemAtSection:(NSInteger)section Indext:(NSInteger)index withModel:(BaseCellModel *)model {
    BOOL is = [BBNetWorkManager networkReachability];
    
    if (!detailModel) {
        if (!is) {
            [self showMessage:@"请检查网络连接是否正常"];
            return;
        } else {
          [self getTaskDetail];  //网络正常连接，重新请求任务详情
          [NSThread sleepForTimeInterval:0.3];
        }
    }

    if (!detailModel) {
        [self showMessage:@"请重试"];  //没拿到时长和噪音限制
        return;
    }
    
    if (_hasRec) {//已录制，暂时不让过
        return;
    }
 
//////////////////////////////////
    
    if (_re_rec) {
        if (!self.no_pass) {
            //未质检
            //查询 DB 有没有本地url  有 已录制标签显示  无 已录制标签隐藏
            //语料选中状态  可试听 可重录 可点击
            //语料未选中 试听状态 重录状态 灰色 不可点击  （刚进入界面，包括录制完成返回）
            unQIndex = section;  //第几行 index: 0.1...
            selceted = YES;  //选中
            [self selectedUnqualifiedAudio];  //选中
//            NSString *message = [NSString stringWithFormat:@"第 %li 行",(long)section];
//            [self showMessage:message];
            return;
        }
    }
   
//////////////////////////////////
  
    
    if (section == 0) {
        NSMutableArray *audioTextArr = [[NSMutableArray alloc]init];
        NSMutableArray *audioIdArr = [[NSMutableArray alloc]init];
        for (BBMineDertailCellModel * cellModel in self.dataListArray) {
            BBMineDetailListBeanModel *listBeanModel = (BBMineDetailListBeanModel *)cellModel.beanModel;
            BBMineDetailBeanModel *beanModel = listBeanModel.detailArray[0];
            [audioTextArr addObject:beanModel.title];
            [audioIdArr addObject:beanModel.rec_id];
        }
        
        BBCollectAudioViewController *collectAudioVC = [[BBCollectAudioViewController alloc]init];
        
        if (_no_pass) {
            collectAudioVC.re_recording = YES;  //重录提交时需要请求重新提交接口
            collectAudioVC.allCount = (int)self.dataListArray.count;  //重新录制数
        } else {
            collectAudioVC.allCount = (int)[kBBDataManager getAllSubTaskCountWithNotHaveUrlTaskID:_task_id];
        }
        
        if (_re_rec) {
            collectAudioVC.status = Checking;  //返回未质检未通过界面的标记
        } else {
            collectAudioVC.status = NoRefer;  //返回待录制已录制界面的标记
        }
        collectAudioVC.task_id = _task_id;
        collectAudioVC.audioTextArr = audioTextArr;
        collectAudioVC.audioIdArr = audioIdArr;
        collectAudioVC.currentCount = 1;
        collectAudioVC.timelimit = detailModel.timelimit.intValue;
        collectAudioVC.noiseCap = detailModel.noiseCap.intValue;
        [self.navigationController pushViewController:collectAudioVC animated:YES];
    } else {
        [self showMessage:@"请从最前面任务开始"];
    }
    
}
//暂时作废
-(void)prepareData {

}

//是否可以上拉加载
-(BOOL)canLoadMore {
    return NO;
}

//是否可以下拉刷新
-(BOOL)canPullRefresh {
    return NO;
}
- (NSMutableArray *)audioArr {
    if (!_audioArr) {
        _audioArr = [NSMutableArray new];
    }
    return _audioArr;
}

@end
