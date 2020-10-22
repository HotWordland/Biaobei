//
//  BBMineViewController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineViewController.h"
#import "BBMineHeaderCellModel.h"
#import "BBMineHeaderBeanModel.h"
#import "BBMineTipCellModel.h"
#import "BBMineTipBeanModel.h"
#import "BBMineUsualCellModel.h"
#import "BBMineUsualBeanModel.h"
#import "BBMineSectionController.h"
#import "BBMineLineCellModel.h"
#import "BBTipDetailController.h"
#import "BBSettingViewController.h"
#import "BBMineComplainViewController.h"
#import "BBMineGroupChoiceView.h"
#import "BBMineDetailViewController.h"
#import "BBJoinGroupController.h"
#import "BBGroupTranslationViewController.h"
#import "BBCreatGroupViewController.h"
#import "BBManagerGroupViewController.h"
#import "BBMineTaskStatusViewController.h"

@interface BBMineViewController ()<BaseSectionControllerDelegate>
{
    BBUserInfoModel *userInfoModel;
    BOOL             _isHaveNotPass;
}
@end

@implementation BBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserInfo];
    [self getNotPass];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapMineTag:) name:@"tapMineTag" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = false;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"tapMineTag" object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.initList) {
        self.initList = YES;
        [self refresh];
    }
}

-(void)viewDidLayoutSubviews {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(StatusAndNaviHeight);
    }];
}

-(void)tapMineTag:(NSNotification *)notifi {
    NSDictionary * dic = (NSDictionary *)notifi.object;
    if ([[dic objectForKey:@"group"] isEqualToString:@"group"]) {
        if ([userInfoModel.teamIdentity isEqualToString:@"0"]) {
            //成员
            BBGroupTranslationViewController * controller = [[BBGroupTranslationViewController alloc]init];
            controller.group_id = userInfoModel.teamId;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            //拥有人
            BBManagerGroupViewController * controller = [[BBManagerGroupViewController alloc]init];
            controller.teamId = userInfoModel.teamId;
            controller.teamName = userInfoModel.teamName;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if ([[dic objectForKey:@"group"] isEqualToString:@"single"] ){
        BBMineGroupChoiceView * choiceView = [[BBMineGroupChoiceView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        __weak typeof(BBMineGroupChoiceView *)weak_choiceView = choiceView;
        choiceView.choiceGroup = ^(ChoiceGroupType type) {
            [weak_choiceView removeFromSuperview];
            if (type == CreatGroup) {
                BBCreatGroupViewController * creatGroup = [[BBCreatGroupViewController alloc]init];
                creatGroup.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:creatGroup animated:YES];
            } else {
                BBJoinGroupController * controller = [[BBJoinGroupController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
        };
        [[UIApplication sharedApplication].keyWindow addSubview:choiceView];
    }else if ([[dic objectForKey:@"group"] isEqualToString:@"noPass"]){
        BBCreatGroupViewController * creatGroup = [[BBCreatGroupViewController alloc]init];
        creatGroup.hidesBottomBarWhenPushed = YES;
        creatGroup.isNotPass = YES;
        [self.navigationController pushViewController:creatGroup animated:YES];

    }
    else if ([[dic objectForKey:@"group"] isEqualToString:@"applying"]){
        
    }
}

-(void)prepareData {
    //个人 团队...
    
    BBMineHeaderCellModel * headerCellModel = [[BBMineHeaderCellModel alloc]initWithData:nil];
    BBMineHeaderBeanModel * headerBeanModel = (BBMineHeaderBeanModel *)headerCellModel.beanModel;
    headerBeanModel.headerUrl = kAppCacheInfo.headImage;
    headerBeanModel.name = kAppCacheInfo.userName;
    NSString *teamStatus = kAppCacheInfo.teamStatus;
    if ([teamStatus isEqualToString:@"4"]) {//0 个人 1 申请中 2 审核未通过 3 拒绝 4 团队  5 禁用
        headerBeanModel.type = group;
    }else if ([teamStatus isEqualToString:@"1"]){
        headerBeanModel.type = applying;
    }else if ([teamStatus isEqualToString:@"2"]){
        headerBeanModel.type = noPass;
    }else if ([teamStatus isEqualToString:@"5"]){
        headerBeanModel.type = forbidden;
    }else{
        headerBeanModel.type = single;
    }
    [self.dataListArray addObject:headerCellModel];
    
    //未提交...
    BBMineTipCellModel * tipCellModel = [[BBMineTipCellModel alloc]initWithData:nil];
    BBMineTipBeanModel * beanModel = (BBMineTipBeanModel *)tipCellModel.beanModel;
    NSMutableArray<BBMineTipDetailBeanModel> * detailArray = [[NSMutableArray<BBMineTipDetailBeanModel> alloc]init];
    
    BBMineTipDetailBeanModel * noReferDetailBeanModel = [[BBMineTipDetailBeanModel alloc]init];
    noReferDetailBeanModel.title = @"未提交";
    noReferDetailBeanModel.imageName = @"Mine_norefer";
    noReferDetailBeanModel.last = NO;
    noReferDetailBeanModel.first = YES;
    noReferDetailBeanModel.tip = NO;
    [detailArray addObject:noReferDetailBeanModel];
    
    BBMineTipDetailBeanModel * checkDetailBeanModel = [[BBMineTipDetailBeanModel alloc]init];
    checkDetailBeanModel.title = @"质检中";
    checkDetailBeanModel.imageName = @"Mine_checking";
    checkDetailBeanModel.last = NO;
    checkDetailBeanModel.first = NO;
    checkDetailBeanModel.tip = NO;
    [detailArray addObject:checkDetailBeanModel];
    
    BBMineTipDetailBeanModel * passDetailBeanModel = [[BBMineTipDetailBeanModel alloc]init];
    passDetailBeanModel.title = @"未通过";
    passDetailBeanModel.imageName = @"Mine_pass";
    passDetailBeanModel.last = NO;
    passDetailBeanModel.first = NO;
    passDetailBeanModel.tip = _isHaveNotPass;
    [detailArray addObject:passDetailBeanModel];
    
    BBMineTipDetailBeanModel * completeDetailBeanModel = [[BBMineTipDetailBeanModel alloc]init];
    completeDetailBeanModel.title = @"已通过";
    completeDetailBeanModel.imageName = @"Mine_alwaysAccess";
    completeDetailBeanModel.last = YES;
    completeDetailBeanModel.first = NO;
    completeDetailBeanModel.tip = NO;
    [detailArray addObject:completeDetailBeanModel];
    
    beanModel.detailModelArray = detailArray;
    [self.dataListArray addObject:tipCellModel];

    BBMineLineCellModel * lineCellModel = [[BBMineLineCellModel alloc]initWithData:nil];
    [self.dataListArray addObject:lineCellModel];

//    BBMineUsualCellModel * sistymCellModel = [[BBMineUsualCellModel alloc]initWithData:@{@"title":@"系统消息",@"summary":@"全民任务大使火热招聘"}];
//    [self.dataListArray addObject:sistymCellModel];

    BBMineUsualCellModel * complainCellModel = [[BBMineUsualCellModel alloc]initWithData:@{@"title":@"意见反馈",@"summary":@""}];
    [self.dataListArray addObject:complainCellModel];

    BBMineUsualCellModel * SsettingCellModel = [[BBMineUsualCellModel alloc]initWithData:@{@"title":@"账户设置",@"summary":@""}];
    [self.dataListArray addObject:SsettingCellModel];
}

- (void)getNotPass{
    
    NSString *pageNum = [NSString stringWithFormat:@"%d",1];
    NSDictionary *params = @{
                             @"pageNum":pageNum,
                             @"pageSize":@"10"
                             };
    [[BBRequestManager sharedInstance] getUserTaskListWithStatus:@"2" params:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        BBHomeTaskListModel *taskListModel = (BBHomeTaskListModel *)model;
        NSArray *list = taskListModel.list;
        if (list.count>0) {
            _isHaveNotPass = YES;
        }else{
            _isHaveNotPass = NO;
        }
        [self.dataListArray removeAllObjects];
        [self prepareData];
        [self refresh];
    } failure:^(NSString * _Nonnull error) {
        
        //        [self showMessage:error];
    }];
}

-(void)getUserInfo{
    [[BBRequestManager sharedInstance] getMyInfoWithSuccess:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        userInfoModel = (BBUserInfoModel *)model;
        kAppCacheInfo.userName = userInfoModel.realName;
//        kAppCacheInfo.headImage = userInfoModel.icon;  //业务逻辑：本地默认头像   icon返回为空
        //头像更新
//        if ([userInfoModel.sex isEqualToString:@"0"]) {
//            kAppCacheInfo.headImage = @"ProfilePhoto_Female";
//            
//        } else {
//            kAppCacheInfo.headImage = @"ProfilePhoto_Male";
//        }
        
        //---------------------------------------
        kAppCacheInfo.headImage = @"ProfilePhoto_Male";  //临时需求
        //---------------------------------------
        
        kAppCacheInfo.teamStatus = userInfoModel.teamStatus;

        kAppCacheInfo.teamId = userInfoModel.teamId;
        kAppCacheInfo.age = userInfoModel.age;
        kAppCacheInfo.sex = userInfoModel.sex;
        
        [self refresh];

    } failure:^(NSString * _Nonnull error) {
        //        [self showMessage:error];
    }];
    
}


-(BaseSectionController *)getSectionController {
    BBMineSectionController * sectionController = [[BBMineSectionController alloc]init];
    sectionController.delegate = self;
    return sectionController;
}

-(void)didSelectItemAtSection:(NSInteger)section Indext:(NSInteger)index withModel:(BaseCellModel *)model {
    if (section == 0) {
        if (!userInfoModel) {
            return;
        }
        //个人资料
        BBMineDetailViewController * mineDetailController =[[BBMineDetailViewController alloc] init];
        mineDetailController.userInfoModel = userInfoModel;
        mineDetailController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mineDetailController animated:YES];
        return;
    } else if (section == 1) {
        //status:0-未提交 1-质检中 2-未通过 3-完成
        BBMineTaskStatusViewController *taskStatusVC = [[BBMineTaskStatusViewController alloc]init];
        taskStatusVC.status = [NSString stringWithFormat:@"%li",(long)index];
        taskStatusVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:taskStatusVC animated:YES];
    } else if (section == 3) {
        //意见反馈
        BBMineComplainViewController * complainViewController = [[BBMineComplainViewController alloc]init];
        complainViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:complainViewController animated:YES];
    } else if (section == 4) {
        //账户设置
        BBSettingViewController * settingController =[[BBSettingViewController alloc]init];
        settingController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingController animated:YES];
    }
}

-(void)configCollectionViewAndAdapter {
    [super configCollectionViewAndAdapter];
    self.collectionView.bounces = false;
}

-(BOOL)canLoadMore {
    return false;
}

-(BOOL)canPullRefresh {
    return false;
}

@end
