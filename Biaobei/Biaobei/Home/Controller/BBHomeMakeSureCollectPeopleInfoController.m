//
//  BBHomeMakeSureCollectPeopleInfoController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/7.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeMakeSureCollectPeopleInfoController.h"
#import "BBCollectPeopleChildViewController.h"
#import "BBTipDetailListViewController.h"
#import "BaseWebViewController.h"
#import "BBTaskAlertView.h"
#import "BBAggreProtocolViewController.h"
@interface BBHomeMakeSureCollectPeopleInfoController ()

@property (nonatomic, strong) BBCollectPeopleChildViewController * childController;
@property (nonatomic, strong) UIView * underView;
@property (nonatomic, strong) UIView * dotView;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) UILabel * protocolLabel;
@property (nonatomic, strong) UIButton * bringButton;
@end

@implementation BBHomeMakeSureCollectPeopleInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认采集人信息";
    [self prepareUI];
    [self resgisterEnditing];
}

-(void)prepareUI {
    _childController = [[BBCollectPeopleChildViewController alloc]init];
    _childController.detailModel = _detailModel;
    [self addChildViewController:_childController];
    [self didMoveToParentViewController:_childController];
    _childController.view.frame = CGRectMake(0, 25, SCREENWIDTH, SCREENHEIGHT - StatusAndNaviHeight - 102);
    [self.view addSubview:_childController.view];
    
    self.bringButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bringButton setTitle:@"立即领取" forState:UIControlStateNormal];
    self.bringButton.titleLabel.font = kFontRegularSize(18);
    self.bringButton.backgroundColor = GreenColor;
    self.bringButton.layer.masksToBounds = YES;
    self.bringButton.layer.cornerRadius = 27;
    [self.bringButton addTarget:self action:@selector(BringTaskButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bringButton];

    [self.bringButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(54);
        make.bottom.mas_equalTo(-32);
    }];
}

-(void)tapProtocol {
    BaseWebViewController *webViewVC = [[BaseWebViewController alloc]init];
    webViewVC.urlStr = UserProtocol;
    webViewVC.webTitle = @"数据工场用户协议";
    [self.navigationController pushViewController:webViewVC animated:YES];
}

/* 领取任务 */
-(void)BringTaskButtonClick {
    if (!_taskId) {
        return;
    }
    BBMineDetailBeanModel * nameModel = _childController.nameModel; //姓名
    BBMineDetailBeanModel * sexModel = _childController.sexModel;  //性别
    BBMineDetailBeanModel * ageModel = _childController.ageModel;  //年龄
    BBMineDetailBeanModel * placeModel = _childController.placeModel; //籍贯
    
    if (String_IsEmpty(nameModel.textField) || [sexModel.summary isEqualToString:@"请选择"] || [placeModel.summary isEqualToString:@"请选择"] || [ageModel.summary isEqualToString:@"请选择"]) { //缺个年龄
        [self showMessage:@"请输入完整信息"];
        return;
    }
    
    NSMutableArray *configLists = [[NSMutableArray alloc]init];
    for (BBMineDetailBeanModel *model in _childController.configArr) {
        if ([model.summary isEqualToString:@"请选择"]) {
            [self showMessage:@"请输入完整信息"];
            return;
        }
        
        NSDictionary *configDic = @{ model.title:model.summary };
        [configLists addObject:configDic];
    }
    
    if (!_childController.currentProvince) {
        NSArray *strArr = [kAppCacheInfo.nativePlace componentsSeparatedByString:@" "];
        _childController.currentProvince = strArr[0];
        _childController.currentCity = strArr[1];
        _childController.currentArea = strArr[2];
    }
    
    if (!_childController.currentProvince) {
        [self showMessage:@"请选择籍贯"];
        return;
    }
    
    
    NSString *sex = @"1";
    if ([sexModel.summary isEqualToString:@"女"]) {
        sex = @"0";
    }
    BBTaskAlertView * vc = [[BBTaskAlertView alloc] init];
//    [self.view addSubview:vc];
    vc.aggreBtnDidClock = ^{
        NSString *teamId = @"";
        if (!String_IsEmpty(kAppCacheInfo.teamId)) {
            teamId = kAppCacheInfo.teamId;
        }
        NSDictionary *params = @{
                                 @"taskId":_taskId,
                                 @"collectName":nameModel.textField,
                                 @"collectAge":ageModel.summary,
                                 @"collectSex":sex,
                                 @"configLists":configLists,
                                 @"collectProvince":_childController.currentProvince,
                                 @"collectCity":_childController.currentCity,
                                 @"collectTown":_childController.currentArea,
                                 @"teamId":teamId
                                 };
        [[BBRequestManager sharedInstance] receiveTaskWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
            NSInteger code = [responseObject[@"code"] integerValue];//要是已被领取还是会返回datacode
            NSDictionary *dataDic;
            NSString *dataCode = @"";
            if (responseObject[@"data"] && ![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                dataDic = responseObject[@"data"];
                if (dataDic[@"datacode"]) {
                    dataCode  = dataDic[@"datacode"];
                }
            }
            
            if (code == 40018) {
                [self showMessage:@"任务已被领取"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];

                });
            } else if (code == 40019) {
                [self showMessage:@"此项目领取已超过人数上限"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            } else {
                //配置 userId taskId dataCode数据
                [kAppCacheInfo configUser_dataCodeDicWithTaskId:_taskId dataCode:dataCode];
                [self showMessage:@"任务领取成功" block:^{
                    //进入录音任务界面
                    BBTipDetailListViewController * controller = [[BBTipDetailListViewController alloc]init];
                    [controller tag:NoRefer];
                    controller.task_id = _taskId;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController pushViewController:controller animated:YES];
                    });
                }];
            }
        } failure:^(NSString * _Nonnull error) {
//            [self showMessage:error];
        }];
    };
    vc.procolBtnDidClock = ^{
        BBAggreProtocolViewController * vc = [[BBAggreProtocolViewController alloc]init];
         [self.navigationController pushViewController:vc animated:YES];
    };
    
//    _childController.ageModel.summary
 
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
