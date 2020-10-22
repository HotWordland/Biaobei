//
//  BBSearchTableViewCell.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/19.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBSearchTableViewCell.h"
#import "BBLeftRightView.h"
#import "BBGroupTranslationViewController.h"
#import "BBMineApplyPeopleView.h"

@interface BBSearchTableViewCell ()

@property (nonatomic, strong) UIViewController *currentVC;

@end

@implementation BBSearchTableViewCell
{
    BBLeftRightView *nameView;  //名称
    BBLeftRightView *descView;  //简介
    BBLeftRightView *locateView;  //所属地区
    BBLeftRightView *zizhiView;  //资质
    
}

-(UIViewController *)currentVC{
    if (!_currentVC) {
        _currentVC = [self getCurrentViewController];
    }
    return _currentVC;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 5, SCREENWIDTH-24, 264)];
    bgView.backgroundColor = WhiteColor;
    bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    bgView.layer.shadowOpacity = 1;
    bgView.layer.shadowRadius = 8;
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    //1.
    nameView = [[BBLeftRightView alloc]initWithFrame:CGRectMake(0, 5, bgView.width, 50) leftStr:@"" rightStr:@""];
    [bgView addSubview:nameView];
    
    descView = [[BBLeftRightView alloc]initWithFrame:CGRectMake(0, nameView.bottom, bgView.width, 50) leftStr:@"团队简介" rightStr:@""];
    [bgView addSubview:descView];
    
    locateView = [[BBLeftRightView alloc]initWithFrame:CGRectMake(0, descView.bottom, bgView.width, 50) leftStr:@"所属地区" rightStr:@""];
    [bgView addSubview:locateView];
    
    zizhiView = [[BBLeftRightView alloc]initWithFrame:CGRectMake(0, locateView.bottom, bgView.width, 50) leftStr:@"相关资质" rightStr:@"查看照片"];
    [bgView addSubview:zizhiView];
    
    //2.
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(0, bgView.bottom-53, bgView.width, 53);
    applyBtn.backgroundColor = [UIColor colorWithHex:@"#FBFBFF"];
    [applyBtn setTitle:@"申请加入" forState:UIControlStateNormal];
    [applyBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [bgView addSubview:applyBtn];
    [applyBtn addTarget:self action:@selector(applyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)setGroupInfoModel:(BBGroupInfoModel *)groupInfoModel{
    _groupInfoModel = groupInfoModel;
    if (!groupInfoModel) {
        return;
    }
    
    nameView.leftStr = groupInfoModel.teamName;
    descView.rightStr = groupInfoModel.teamProfile;
    locateView.rightStr = [NSString stringWithFormat:@"%@ %@ %@",groupInfoModel.province,groupInfoModel.city,groupInfoModel.town];
    
}


-(void)applyBtnAction{
    __weak typeof(self) weakSelf = self;
    BBMineApplyPeopleView * applyPeopleview = [[BBMineApplyPeopleView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    applyPeopleview.change = ^{
        [weakSelf.currentVC.navigationController popViewControllerAnimated:YES];
    };
    
    applyPeopleview.sure = ^{
        [weakSelf makeSureJoinGroup];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:applyPeopleview];
    
    
}


-(void)makeSureJoinGroup{
    [SVProgressHUD showWithStatus:@"申请中..."];
    NSDictionary *params = @{
                             @"teamId":_groupInfoModel.group_id
                             };
    [[BBRequestManager sharedInstance] joinTeamWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [SVProgressHUD dismiss];
//        BBGroupTranslationViewController * controller = [[BBGroupTranslationViewController alloc]init];
//        controller.group_id = _groupInfoModel.group_id;
//        controller.isApplaying = YES;
//        [self.currentVC.navigationController pushViewController:controller animated:YES];
        
    } failure:^(NSString * _Nonnull error) {
        [SVProgressHUD dismiss];
//        [PromptAlertView alertWithMessage:@"申请失败"];
    }];
}

@end
