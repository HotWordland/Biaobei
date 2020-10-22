//
//  BBTaskDetailViewController.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/21.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBTaskDetailViewController.h"
#import "BBRecordNoticeViewController.h"
#import "BBHomeMakeSureCollectPeopleInfoController.h"

@interface BBTaskDetailViewController ()
{
    UIScrollView *bgScrollView;
    
    UIImageView *urgentImgView;
    UILabel *timeLabel;
    UILabel *titleLabel;
    UILabel *taskTypeLabel;
    
    UIView *botView;
    MLLabel *descLabel;
    UIView *botAttentView;  //录制注意事项
    UIButton *nextBtn;
    
    BBTaskDetailModel *detailModel;
    
}

@end

@implementation BBTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
    [self getTaskDetail];
}

-(void)createSubViews{
    bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-StatusAndNaviHeight-85)];
    bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    
    //1.
    UILabel *detailLabel = [UIFactory createLab:CGRectMake(22, 18, 290, 40) text:@"任务详情" textColor:BlackColor textFont:kFontMediumSize(36) textAlignment:NSTextAlignmentLeft];
    [bgScrollView addSubview:detailLabel];
    
    //2.
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(12, detailLabel.bottom+30, SCREENWIDTH-24, 142)];
    topView.backgroundColor = WhiteColor;
    topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    topView.layer.shadowOffset = CGSizeMake(0,0);
    topView.layer.shadowOpacity = 1;
    topView.layer.shadowRadius = 8;
    topView.layer.cornerRadius = 6;
    [bgScrollView addSubview:topView];
    
    urgentImgView = [[UIImageView alloc]initWithFrame:CGRectMake(topView.width-40, 2, 24, 54)];
    urgentImgView.image = [UIImage imageNamed:@"加急"];
    [topView addSubview:urgentImgView];
    
    timeLabel = [UIFactory createLab:CGRectMake(20, 20, topView.width-40, 20) text:@"" textColor:BlackColor textFont:kFontRegularSize(12) textAlignment:NSTextAlignmentLeft];
    [topView addSubview:timeLabel];
    
    titleLabel = [UIFactory createLab:CGRectMake(20, timeLabel.bottom+5, timeLabel.width, 30) text:@"" textColor:GreenColor textFont:kFontMediumSize(24) textAlignment:NSTextAlignmentLeft];
    [topView addSubview:titleLabel];
    
    taskTypeLabel = [UIFactory createLab:CGRectMake(20, 117, topView.width-40, 20) text:@"" textColor:[UIColor colorWithHex:@"#9499A1"] textFont:kFontRegularSize(14) textAlignment:NSTextAlignmentLeft];
    [topView addSubview:taskTypeLabel];
    
    //3.
    botView = [[UIView alloc]initWithFrame:CGRectMake(topView.left, topView.bottom+10, topView.width, 150)];
    botView.backgroundColor = WhiteColor;
    botView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    botView.layer.shadowOffset = CGSizeMake(0,0);
    botView.layer.shadowOpacity = 1;
    botView.layer.shadowRadius = 8;
    botView.layer.cornerRadius = 6;
    [bgScrollView addSubview:botView];
    
    UILabel *taskDescLabel = [UIFactory createLab:CGRectMake(20, 22, botView.width-40, 20) text:@"任务描述" textColor:BlackColor textFont:kFontMediumSize(18) textAlignment:NSTextAlignmentLeft];
    [botView addSubview:taskDescLabel];
    
    descLabel = [[MLLabel alloc]initWithFrame:CGRectMake(20, taskDescLabel.bottom+10, botView.width-38, 20)];
    descLabel.lineSpacing = 5;
    [botView addSubview:descLabel];
    
    //4.录制注意事项
    botAttentView = [[UIView alloc]init];
    botAttentView.backgroundColor = [UIColor colorWithHex:@"#FBFBFF"];
    [botView addSubview:botAttentView];
    
    [botAttentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(botView);
        make.height.mas_equalTo(48);
    }];
    
    UIView *dotView = [[UIView alloc]initWithFrame:CGRectMake(20, 21, 6, 6)];
    dotView.backgroundColor = GreenColor;
    dotView.layer.cornerRadius = 3;
    [botAttentView addSubview:dotView];
    
    UILabel *readLabel = [[UILabel alloc]initWithFrame:CGRectMake(34, 0, botView.width-40, 48)];
    [botAttentView addSubview:readLabel];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"请仔细阅读《录制注意事项》"attributes: @{NSFontAttributeName:kFontRegularSize(14),NSForegroundColorAttributeName:BlackColor }];
    [string addAttributes:@{NSForegroundColorAttributeName: BlackColor} range:NSMakeRange(0, 5)];
    [string addAttributes:@{NSForegroundColorAttributeName: GreenColor} range:NSMakeRange(5, 8)];
    readLabel.attributedText = string;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(readLabelAction)];
    readLabel.userInteractionEnabled = YES;
    [readLabel addGestureRecognizer:tapGes];
    
    //4.下一步
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    nextBtn.backgroundColor = GreenColor;
    nextBtn.frame = CGRectMake(30, SCREENHEIGHT-StatusAndNaviHeight-84, SCREENWIDTH-60, 54);
    nextBtn.layer.cornerRadius = 27;
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    
}


-(void)getTaskDetail{
    if (String_IsEmpty(_taskId)) {
        [self showMessage:@"任务信息获取失败"];
        return;
    }
    NSDictionary *params = @{
                              @"taskId":_taskId
                            };
    [[BBRequestManager sharedInstance] getTaskDetailWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        detailModel = (BBTaskDetailModel *)model;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];
    
}

-(void)updateUI{
    if (detailModel.is_express) {
        urgentImgView.hidden = NO;
    } else {
        urgentImgView.hidden = YES;
    }
    
//    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset = 20;
//        make.top.mas_equalTo(titleLabel.bottom + 5);
//    }];
    
    //1.
    NSString *startTime = [NSString day_timestampToString:detailModel.starttime.integerValue];
    NSString *endTime = [NSString day_timestampToString:detailModel.endtime.integerValue];
    timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
    
    titleLabel.text = detailModel.projectName;
//    titleLabel.frame = titleLabel.frame;
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    
    [taskTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.top.mas_equalTo(titleLabel.bottom + 5);
    }];
    
    NSString *collectType = detailModel.collectType;
    if ([collectType isEqualToString:@"0"]) {
        taskTypeLabel.text = @"多人采集相同文本";
    }else if ([collectType isEqualToString:@"1"]){
        taskTypeLabel.text = @"多人采集不同文本";
    }else if ([collectType isEqualToString:@"2"]){
        taskTypeLabel.text = @"无文本采集";
    }
    
    //2.
    descLabel.text = detailModel.desc;
    descLabel.frame = descLabel.frame;
    descLabel.numberOfLines = 0;
    [descLabel sizeToFit];
    
    if (descLabel.height>100) {
        botAttentView.top = descLabel.bottom+20;
        botView.height = botAttentView.bottom;
        bgScrollView.contentSize = CGSizeMake(SCREENWIDTH, botView.bottom+20);
    }
    
    //3.任务领取人数达到上限
    NSInteger receivenum = detailModel.receivenum.integerValue;
    NSInteger joinnum = detailModel.joinnum.integerValue;
    if (receivenum>=joinnum) {
        [nextBtn setTitle:@"人数已达标" forState:UIControlStateNormal];
        nextBtn.backgroundColor = [UIColor colorWithHex:@"#BABABA"];
        nextBtn.enabled = NO;
    }
    
}


-(void)readLabelAction{
    BBRecordNoticeViewController *noticeVC = [[BBRecordNoticeViewController alloc]init];
    noticeVC.taskId = _taskId;
    [self.navigationController pushViewController:noticeVC animated:YES];
}

-(void)nextBtnAction{
    BBHomeMakeSureCollectPeopleInfoController *collectPeopleVC = [[BBHomeMakeSureCollectPeopleInfoController alloc]init];
    collectPeopleVC.taskId = _taskId;
    collectPeopleVC.detailModel = detailModel;
    [self.navigationController pushViewController:collectPeopleVC animated:YES];
}

@end
