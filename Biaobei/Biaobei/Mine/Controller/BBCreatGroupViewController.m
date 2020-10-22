//
//  BBCreatGroupViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBCreatGroupViewController.h"
#import "BBMineDertailCellModel.h"
#import "BBMineDetailBeanModel.h"
#import "BBMineDetailListBeanModel.h"
#import "BBHomeTitleCellModel.h"
#import "BBMineGroupChoiceView.h"
#import "BBJoinGroupViewController.h"
#import "BBGroupTranslationViewController.h"
#import "BBCreatGroupViewController.h"
#import "BBUploadImageViewController.h"
#import "BBMineDertailListSectionController.h"
#import "HmSelectAdView.h"
#import "UIView+Factory_hzj.h"
#import "BBSearchGroupModel.h"

@interface BBCreatGroupViewController ()
{
    BBMineDetailBeanModel * identerBeanModel; //团队名称
    BBMineDetailBeanModel * groupTransBeanModel; //团队简介
    BBMineDetailBeanModel * locationBeanModel;  //所属地区
    BBMineDetailBeanModel * accodingBeanModel;  //相关资质
    
}

@property (nonatomic, strong) UIButton * sureButton;

@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentArea;

@property (nonatomic, strong) UIImage *uploadImage;
@property (nonatomic, copy)  NSString *uploadImgUrl;
@property (nonatomic, strong) BBGroupInfoModel *temoModel;

@property (nonatomic, strong) UIView   * notPassView;//未通过
@property (nonatomic, strong) UIButton * cancleBtn;//取消申请
@property (nonatomic, strong) UIButton * saveBtn;//再次提交

@end

@implementation BBCreatGroupViewController


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.initList) {
        self.initList = YES;
        [self refresh];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isEdit) {
        self.title = @"编辑团队信息";
    }
    self.title = @"申请团队";
    if (self.isNotPass) {
        [self getTeamDetail];
    }
    [self prepareData];
    [self prepareUI];
    
    [self resgisterEnditing];
}

-(void)configCollectionViewAndAdapter {
    [super configCollectionViewAndAdapter];
    self.collectionView.bounces = false;
}

-(void)viewDidLayoutSubviews {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-86);
    }];
}

-(void)prepareUI {
    if (self.isNotPass) {
        self.notPassView = [UIView ViewView];
        kViewRadius(self.notPassView, 54/2);
        [self.view addSubview:self.notPassView];
        
        self.cancleBtn = [UIButton ButtonText:@"取消申请" textColor:rgba(37, 194, 155, 1) textFont:kFontMediumSize(18) backGroundColor:[UIColor whiteColor] trail:self action:@selector(cancleBtnDidClick:) tag:100];
        [self.notPassView addSubview:self.cancleBtn];
        
        self.saveBtn = [UIButton ButtonText:@"再次申请" textColor:[UIColor whiteColor] textFont:kFontMediumSize(18) backGroundColor:rgba(37, 194, 155, 1) trail:self action:@selector(saveBtnDidClick:) tag:101];
        [self.notPassView addSubview:self.saveBtn];
        
        [self.notPassView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.height.offset = 54;
            make.bottom.offset = -32-TabbarSafeBottomMargin;
            make.width.offset = 300;
        }];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset = 0;
            make.right.mas_equalTo(self.saveBtn.mas_left);
            make.width.mas_equalTo(self.saveBtn.mas_width);
        }];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.offset = 0;
        }];
        
    } else {
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureButton.frame = CGRectMake(30, self.view.frame.size.height - StatusAndNaviHeight - 86, [UIScreen mainScreen].bounds.size.width -60, 54);
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sureButton.backgroundColor = [UIColor colorWithRed:37.0/255 green:194.0/255 blue:155.0/255 alpha:1];
        self.sureButton.layer.masksToBounds = YES;
        self.sureButton.layer.cornerRadius = 27;
        [self.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.sureButton];
    }
}

//获取团队信息
- (void)getTeamDetail {
    [[BBRequestManager sharedInstance] getTeamNotPassInfoWithsuccess:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        if (model) {
            BBGroupInfoModel * temaModel = (BBGroupInfoModel *)model;
            self.temoModel = temaModel;
            identerBeanModel.textField = temaModel.teamName;
            groupTransBeanModel.textField = temaModel.teamProfile;
             locationBeanModel.summary = [NSString stringWithFormat:@"%@ %@ %@", temaModel.province, temaModel.city, temaModel.town];  //所属地区
            
            accodingBeanModel.imageName = temaModel.teamLicense;  //相关资质
//            accodingBeanModel.summary = @"资质已上传";
            accodingBeanModel.summary = @"请重新上传资质";  //未通过提示

            

            self.uploadImgUrl =temaModel.teamLicense;
            self.currentProvince = temaModel.province;
            self.currentCity = temaModel.city;
            self.currentArea = temaModel.town;

            [self refresh];
            
        }
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];

    }];
}
- (void)cancleBtnDidClick:(UIButton *)btn {
    [[BBRequestManager sharedInstance] cancleTeamInfoWithParams:@{@"teamId":self.temoModel.group_id?self.temoModel.group_id:@""} success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [self showMessage:@"团队申请取消成功" block:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];

    }];
}

//再次申请被驳回的团队信息
- (void)saveBtnDidClick:(UIButton *)btn {
    NSString *teamLicense = self.uploadImgUrl;
    if ( !String_IsEmpty(teamLicense) && !self.uploadImage) {
        [self showMessage:@"请重新上传资质"];  //URL有，imagedata空是被驳回时的资质照片
        return;
    }

    if (String_IsEmpty(identerBeanModel.textField) || String_IsEmpty(groupTransBeanModel.textField) || String_IsEmpty(self.currentProvince) || String_IsEmpty(teamLicense)) {
        [self showMessage:@"请填写完整信息"];
        return;
    }
    
//       [BBOssUploadManager sharedInstance].contentUrl = [NSString stringWithFormat:@"%@/%@",@"license",kAppCacheInfo.userId];
    NSDictionary *params = @{
                              @"teamName": identerBeanModel.textField,
                              @"teamProfile": groupTransBeanModel.textField,
                              @"province": self.currentProvince,
                              @"city":self.currentCity,
                              @"town":self.currentArea,
                              @"teamLicense":teamLicense,
                              @"id":self.temoModel.group_id?self.temoModel.group_id:@""
                            };
    
    [[BBRequestManager sharedInstance] upDataTeamInfoWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [self showMessage:@"团队信息提交成功" block:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];
}

-(void)checkButton {

}

//创建团队申请
-(void)sureButtonClick {
    NSString *teamLicense = self.uploadImgUrl;
    if (String_IsEmpty(identerBeanModel.textField) || String_IsEmpty(groupTransBeanModel.textField) || String_IsEmpty(self.currentProvince) || String_IsEmpty(teamLicense)) {
        [self showMessage:@"请填写完整信息"];
        return;
    }
    NSDictionary *params = @{
               @"teamName": identerBeanModel.textField,
               @"teamProfile": groupTransBeanModel.textField,
               @"province": self.currentProvince,
               @"city":self.currentCity,
               @"town":self.currentArea,
               @"teamLicense":teamLicense
               };

    [[BBRequestManager sharedInstance] createTeamWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [self showMessage:@"团队信息提交成功" block:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];

}

-(void)prepareData {
    BBMineDertailCellModel * identerCellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
    NSMutableArray<BBMineDetailBeanModel> * identerArray = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
    identerBeanModel = [[BBMineDetailBeanModel alloc]init];
    identerBeanModel.title = @"团队名称";
    identerBeanModel.placeHold = @"请填写团队名称";
    identerBeanModel.textLength = 20;
//    identerBeanModel.summary = @"标贝壳机";
    identerBeanModel.imageName = @"Mine_Right_direct";
    [identerArray addObject:identerBeanModel];
    BBMineDetailListBeanModel * identerListBeanModel = [[BBMineDetailListBeanModel alloc]init];
    identerListBeanModel.detailArray = identerArray;
    identerCellModel.beanModel = identerListBeanModel;
    [self.dataListArray addObject:identerCellModel];

    BBMineDertailCellModel * groupCellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
    NSMutableArray<BBMineDetailBeanModel> * array = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
    groupTransBeanModel = [[BBMineDetailBeanModel alloc]init];
    groupTransBeanModel.title = @"团队简介";
    groupTransBeanModel.placeHold = @"请填写团队简介";
//    groupTransBeanModel.summary = @"成员在一起改变世界";
    groupTransBeanModel.textLength = 50;
    groupTransBeanModel.imageName = @"Mine_Right_direct";
    [array addObject:groupTransBeanModel];
    locationBeanModel = [[BBMineDetailBeanModel alloc]init];
    locationBeanModel.title = @"所属地区";
    locationBeanModel.summary = @"请选择所属区域";
    locationBeanModel.imageName = @"Mine_Location";
    [array addObject:locationBeanModel];
    accodingBeanModel = [[BBMineDetailBeanModel alloc]init];
    accodingBeanModel.title = @"相关资质";
    accodingBeanModel.summary = @"请上传相关资质";
    accodingBeanModel.imageName = @"Mine_Right_direct";
    [array addObject:accodingBeanModel];
    BBMineDetailListBeanModel * listBeanModel = [[BBMineDetailListBeanModel alloc]init];
    listBeanModel.detailArray = array;
    groupCellModel.beanModel = listBeanModel;
    [self.dataListArray addObject:groupCellModel];

    NSDictionary * titleDic = @{@"title": @"团队对接人兼管理员",@"leftDistance": @30 ,@"bottomDistance": @10,@"topDistance": @26,@"font": @16,@"height": @52};
    BBHomeTitleCellModel * titleCellModel = [[BBHomeTitleCellModel alloc]initWithData:titleDic];
    [self.dataListArray addObject:titleCellModel];

    BBMineDertailCellModel * connectCellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
    NSMutableArray<BBMineDetailBeanModel> * connectArray = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
    BBMineDetailBeanModel * nameBeanModel = [[BBMineDetailBeanModel alloc]init];
    nameBeanModel.title = @"姓名";
    nameBeanModel.summary = kAppCacheInfo.userName;
    nameBeanModel.summaryColor = [UIColor grayColor];
    [connectArray addObject:nameBeanModel];
    BBMineDetailBeanModel * sexBeanModel = [[BBMineDetailBeanModel alloc]init];
    sexBeanModel.title = @"手机号";
    sexBeanModel.summary = kAppCacheInfo.phoneNum;
    sexBeanModel.summaryColor = [UIColor grayColor];
    [connectArray addObject:sexBeanModel];
    BBMineDetailListBeanModel * connectlistBeanModel = [[BBMineDetailListBeanModel alloc]init];
    connectlistBeanModel.detailArray = connectArray;
    connectCellModel.beanModel = connectlistBeanModel;
    [self.dataListArray addObject:connectCellModel];

}

-(void)updateData {
    [self.dataListArray removeObjectAtIndex:1];
    
    BBMineDertailCellModel * groupCellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
    NSMutableArray<BBMineDetailBeanModel> * array = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
    [array addObject:groupTransBeanModel];
    [array addObject:locationBeanModel];
    [array addObject:accodingBeanModel];
    BBMineDetailListBeanModel * listBeanModel = [[BBMineDetailListBeanModel alloc]init];
    listBeanModel.detailArray = array;
    groupCellModel.beanModel = listBeanModel;
    [self.dataListArray insertObject:groupCellModel atIndex:1];
}

-(BOOL)canLoadMore {
    return false;
}

-(BOOL)canPullRefresh {
    return false;
}

-(void)didSelectItemAtSection:(NSInteger)section Indext:(NSInteger)index withModel:(BaseCellModel *)model {
    
}

-(void)selctedCellWithModel:(BBMineDetailBeanModel *)model {
    if ([model.title isEqualToString: @"相关资质"]) {
        BBUploadImageViewController * controller = [[BBUploadImageViewController alloc]init];
        controller.upLoadImage = self.uploadImage;
        [self.navigationController pushViewController:controller animated:YES];
        
        kWeak_self
        controller.uploadImgBlock = ^(UIImage *image, NSString *imageUrl) {
            weakSelf.uploadImage = image;
            weakSelf.uploadImgUrl = imageUrl;
            accodingBeanModel.summary = @"资质已上传";
            [self refresh];  //更新一下section/row

        };
    }else if ([model.title isEqualToString: @"所属地区"]) {
        [self.view endEditing:YES];  //先丢失第一响应
        
        HmSelectAdView *selectV = [[HmSelectAdView alloc] initWithLastContent:self.currentProvince ? @[self.currentProvince, self.currentCity, self.currentArea] : nil];
        selectV.confirmSelect = ^(NSArray *address) {
            self.currentProvince = address[0];
            self.currentCity = address[1];
            self.currentArea = address[2];
            locationBeanModel.summary = [NSString stringWithFormat:@"%@ %@ %@", self.currentProvince, self.currentCity, self.currentArea];
            
            [self updateData];
            [self refresh];
        };
        [selectV show];
    }
}

-(BaseSectionController *)getSectionController {
    BBMineDertailListSectionController * sectionController = [[BBMineDertailListSectionController alloc]init];
    return sectionController;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
