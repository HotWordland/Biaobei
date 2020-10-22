//
//  BBMineDetailViewController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineDetailViewController.h"
#import "BBMineDertailCellModel.h"
#import "BBMineDetailBeanModel.h"
#import "BBMineDetailListBeanModel.h"
#import "BBHomeTitleCellModel.h"
#import "BBMineGroupChoiceView.h"
//#import "BBJoinGroupViewController.h"
#import "BBJoinGroupController.h"
#import "BBGroupTranslationViewController.h"
#import "BBCreatGroupViewController.h"
#import "BBMineDertailListSectionController.h"
#import "HmSelectAdView.h"
#import "BBTabbarViewController.h"
#import "BBManagerGroupViewController.h"
#import "DatePickerView.h"
#import "AppDelegate.h"

@interface BBMineDetailViewController ()<DatePickerViewDelegate>
{
    NSMutableArray *array; //包含下面的组数据
    BBMineDetailBeanModel * nameBeanModel;  //姓名
    BBMineDetailBeanModel * sexBeanModel;  //性别
    BBMineDetailBeanModel * ageBeanModel;  //年龄
    BBMineDetailBeanModel * cityBeanModel;  //籍贯
    
    UIView *dateBgView;
    DatePickerView *datePickerView;
    
}
@property (nonatomic, assign) BOOL regist;
@property (nonatomic, strong) UIButton * sureButton;

@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentArea;

@end

@implementation BBMineDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (dateBgView) {
        dateBgView.alpha = 0;
        [kWindow addSubview:dateBgView];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [dateBgView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareData];
    [self prepareUI];
    [self resgisterEnditing];
    [self createDateView];
}

-(void)createDateView{
    //创建日期选择器
    dateBgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    dateBgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    dateBgView.alpha = 0.0;
    [kWindow addSubview:dateBgView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateTapCancel)];
    [dateBgView addGestureRecognizer:tapGes];
    
    datePickerView = [DatePickerView datePickerView];
    datePickerView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 250);
    datePickerView.delegate = self;
    [dateBgView addSubview:datePickerView];
}

-(void)dateTapCancel{
    [UIView animateWithDuration:0.3 animations:^{
        dateBgView.alpha = 0.0;
        //        datePickerView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 250);
    }];
}

#pragma mark - 日期选择器代理
-(void)cancelSelectDate{
    [self dateTapCancel];
}

-(void)getSelectDate:(NSString *)date type:(DateType)type{
    ageBeanModel.summary = [NSString dateToOld:date];
    [self dateTapCancel];
    
    [self updateData];
    [self refresh];
}

-(void)setUserInfoModel:(BBUserInfoModel *)userInfoModel{
    if (!userInfoModel.province) {
        userInfoModel.province = @"";
        userInfoModel.city = @"";
        userInfoModel.town = @"请选择";
    }
    self.currentProvince = userInfoModel.province;
    self.currentCity = userInfoModel.city;
    self.currentArea = userInfoModel.town;
    _userInfoModel = userInfoModel;
}

-(void)prepareUI {
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureButton.backgroundColor = [UIColor colorWithRed:37.0/255 green:194.0/255 blue:155.0/255 alpha:1];
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 27;
    [self.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(54);
    }];
    

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.initList) {
        self.initList = YES;
        [self refresh];
    }
}

-(void)configCollectionViewAndAdapter {
    [super configCollectionViewAndAdapter];
    self.collectionView.bounces = false;
}

-(void)viewDidLayoutSubviews {
    if (self.regist) {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(StatusAndNaviHeight);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(86);
        }];
    } else {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(86);
        }];
    }
}

-(void)isRegist {
    self.regist = YES;
}

-(void)checkButton {

}

-(void)sureButtonClick {
    
    if (String_IsEmpty(nameBeanModel.textField) || [cityBeanModel.summary containsString:@"请选择"] || [ageBeanModel.summary isEqualToString:@"请选择采集人年龄"]) {
        [self showMessage:@"请填写完整资料"];
        return;
    }
    
    NSString *sex = @"1";
    if ([sexBeanModel.summary isEqualToString:@"女"]) {
        sex = @"0";
    }
//    NSString *is_new = @"0";
//    if (self.regist) {//是新用户
//        is_new = @"1";
//    }
    
    NSDictionary *params = @{
        @"realName": nameBeanModel.textField,
        @"sex": sex,
        @"age": ageBeanModel.summary,
        @"province": self.currentProvince,
        @"city": self.currentCity,
        @"town": self.currentArea,
        @"icon": @"",
        @"is_new":@"0"
        };
    [[BBRequestManager sharedInstance] userUpdateWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        kAppCacheInfo.sex = sex;
        kAppCacheInfo.userName = nameBeanModel.textField;
        kAppCacheInfo.age = ageBeanModel.summary;
        kAppCacheInfo.nativePlace = cityBeanModel.summary;
        
        if (self.regist) {
            [self showMessage:@"提交成功" block:^{
                if (self.regist) {
                    kAppCacheInfo.teamStatus = @"0";
                    
                    BBTabbarViewController * tabbarController = [[BBTabbarViewController alloc]init];
                    tabbarController.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:tabbarController animated:YES completion:nil];
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    appDelegate.currentTabbarVC = tabbarController;
                    return;
                }
            }];
        } else {
            [self showMessage:@"资料更新成功" block:^{
               [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];
    
}

-(void)prepareData {
    NSDictionary * titleDic = @{@"title": @"个人资料",@"leftDistance": @24 ,@"bottomDistance": @18,@"topDistance": @12,@"font": @36,@"height": @66};
    BBHomeTitleCellModel * titleCellModel = [[BBHomeTitleCellModel alloc]initWithData:titleDic];
    [self.dataListArray addObject:titleCellModel];
    if (!self.regist) {
        BBMineDertailCellModel * identerCellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
        NSMutableArray<BBMineDetailBeanModel> * identerArray = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
        BBMineDetailBeanModel * identerBeanModel = [[BBMineDetailBeanModel alloc]init];
        identerBeanModel.title = @"身份";
        NSString *teamStatus = self.userInfoModel.teamStatus;
        if ([teamStatus isEqualToString:@"4"]) {//0 个人 1 申请中 2 审核未通过 3 拒绝 4 团队  5 禁用
            identerBeanModel.summary = @"团队";
        }else if ([teamStatus isEqualToString:@"0"]) {
            identerBeanModel.summary = @"个人";
        }else if ([teamStatus isEqualToString:@"1"]) {
            identerBeanModel.summary = @"申请中";
        }else if ([teamStatus isEqualToString:@"2"]) {
            identerBeanModel.summary = @"未通过";
        }else if ([teamStatus isEqualToString:@"5"]) {
            identerBeanModel.summary = @"禁用";
        }
        identerBeanModel.imageName = @"Mine_Right_direct";
        [identerArray addObject:identerBeanModel];
        BBMineDetailListBeanModel * identerListBeanModel = [[BBMineDetailListBeanModel alloc]init];
        identerListBeanModel.detailArray = identerArray;
        identerCellModel.beanModel = identerListBeanModel;
        [self.dataListArray addObject:identerCellModel];
    }

    BBMineDertailCellModel * cellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
    array = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
    nameBeanModel = [[BBMineDetailBeanModel alloc]init];
    nameBeanModel.title = @"姓名";
    nameBeanModel.placeHold = @"请输入姓名";
    nameBeanModel.textLength = 10;
    nameBeanModel.textField = self.userInfoModel.realName;
    [array addObject:nameBeanModel];
    sexBeanModel = [[BBMineDetailBeanModel alloc]init];
    sexBeanModel.title = @"性别";
    if ([self.userInfoModel.sex isEqualToString:@"1"]) {
        sexBeanModel.summary = @"男";
    }else{
        sexBeanModel.summary = @"女";
    }
    
    sexBeanModel.imageName = @"Mine_Right_direct";
    [array addObject:sexBeanModel];
    ageBeanModel = [[BBMineDetailBeanModel alloc]init];
    ageBeanModel.title = @"年龄";
//    ageBeanModel.placeHold = @"请输入年龄";
//    ageBeanModel.textField = self.userInfoModel.age;
    if (String_IsEmpty(self.userInfoModel.age) || [self.userInfoModel.age isEqualToString:@"0"]) {
        ageBeanModel.summary = @"请选择采集人年龄";
    }else{
        ageBeanModel.summary = self.userInfoModel.age;
    }
    ageBeanModel.imageName = @"Mine_Right_direct";
    [array addObject:ageBeanModel];
    cityBeanModel = [[BBMineDetailBeanModel alloc]init];
    cityBeanModel.title = @"籍贯";
    NSString *nativePlace = [NSString stringWithFormat:@"%@ %@ %@",_userInfoModel.province,_userInfoModel.city,_userInfoModel.town];
    cityBeanModel.summary = nativePlace;
    cityBeanModel.imageName = @"Mine_Location";
    [array addObject:cityBeanModel];
    BBMineDetailListBeanModel * listBeanModel = [[BBMineDetailListBeanModel alloc]init];
    listBeanModel.detailArray = array;
    cellModel.beanModel = listBeanModel;
    [self.dataListArray addObject:cellModel];
}

-(void)updateData{
    [self.dataListArray removeLastObject];
    
    BBMineDertailCellModel * cellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
    array = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
    [array addObject:nameBeanModel];
    [array addObject:sexBeanModel];
    [array addObject:ageBeanModel];
    [array addObject:cityBeanModel];
    
    BBMineDetailListBeanModel * listBeanModel = [[BBMineDetailListBeanModel alloc]init];
    listBeanModel.detailArray = array;
    cellModel.beanModel = listBeanModel;
    [self.dataListArray addObject:cellModel];
}

-(BOOL)canLoadMore {
    return false;
}

-(BOOL)canPullRefresh {
    return false;
}

-(void)didSelectItemAtSection:(NSInteger)section Indext:(NSInteger)index withModel:(BaseCellModel *)model {
    if (index == 1) {

    }
}


-(BaseSectionController *)getSectionController {
    BBMineDertailListSectionController * sectionController = [[BBMineDertailListSectionController alloc]init];
    return sectionController;
}

-(void)selctedCellWithModel:(BBMineDetailBeanModel *)model {
    if ([model.title isEqualToString:@"身份"]){
        if ([model.summary isEqualToString: @"个人"] ) {
            BBMineGroupChoiceView * choiceView = [[BBMineGroupChoiceView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            choiceView.choiceGroup = ^(ChoiceGroupType type) {
                if (type == CreatGroup) {
                    BBCreatGroupViewController * creatGroup = [[BBCreatGroupViewController alloc]init];
                    [self.navigationController pushViewController:creatGroup animated:YES];
                } else {
                    BBJoinGroupController * controller = [[BBJoinGroupController alloc]init];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            };
            [[UIApplication sharedApplication].keyWindow addSubview:choiceView];
        } else if ([model.summary isEqualToString: @"未通过"]) {
            BBCreatGroupViewController * creatGroup = [[BBCreatGroupViewController alloc]init];
            creatGroup.isNotPass = YES;
            [self.navigationController pushViewController:creatGroup animated:YES];
        } else if ([model.summary isEqualToString: @"团队"]) {
            if ([_userInfoModel.teamIdentity isEqualToString:@"0"]) {
                //团队成员
                BBGroupTranslationViewController * controller = [[BBGroupTranslationViewController alloc]init];
                controller.group_id = _userInfoModel.teamId;
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                //团队申请人
                BBManagerGroupViewController * controller = [[BBManagerGroupViewController alloc]init];
                controller.teamId = _userInfoModel.teamId;
                controller.teamName = _userInfoModel.teamName;
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
//            BBGroupTranslationViewController * controller = [[BBGroupTranslationViewController alloc]init];
//            controller.group_id = _userInfoModel.teamId;
//            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if ([model.title isEqualToString:@"性别"]){
        [self.view endEditing:YES];
        
        BBMineGroupChoiceView * choiceView = [[BBMineGroupChoiceView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) titles:@[@"男",@"女"]];
        choiceView.choiceGroup = ^(ChoiceGroupType type) {
            if (type == CreatGroup) {//选的男
                sexBeanModel.summary = @"男";
            } else {
                sexBeanModel.summary = @"女";
            }
            [self updateData];
            [self refresh];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:choiceView];
    }else if ([model.title isEqualToString:@"籍贯"]){
        [self.view endEditing:YES];
        
        HmSelectAdView *selectV = [[HmSelectAdView alloc] initWithLastContent:!String_IsEmpty(self.currentProvince) ? @[self.currentProvince, self.currentCity, self.currentArea] : nil];
        selectV.confirmSelect = ^(NSArray *address) {
            self.currentProvince = address[0];
            self.currentCity = address[1];
            self.currentArea = address[2];
            cityBeanModel.summary = [NSString stringWithFormat:@"%@ %@ %@", self.currentProvince, self.currentCity, self.currentArea];
            kAppCacheInfo.nativePlace = cityBeanModel.summary;
            
            [self updateData];
            [self refresh];
        };
        [selectV show];
    }else if ([model.title isEqualToString:@"年龄"]){
        [self choiceAge];
    }
    
}

-(void)choiceAge {
    [self.view endEditing:YES];  //先丢失第一响应
    [UIView animateWithDuration:0.3 animations:^{
        dateBgView.alpha = 1.0;
        datePickerView.frame = CGRectMake(0, SCREENHEIGHT-250, SCREENWIDTH, 250);
    }];
    
    //    _ageModel.summary = @"18";
    //    [self refreshSection:0];
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
