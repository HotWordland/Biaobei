//
//  BBCollectPeopleChildViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/7.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBCollectPeopleChildViewController.h"
#import "BBMineDertailCellModel.h"
#import "BBMineDetailBeanModel.h"
#import "BBMineDetailListBeanModel.h"
#import "BBHomeTitleCellModel.h"
#import "BBMineDertailListSectionController.h"
#import "HmSelectAdView.h"
#import "BBMineGroupChoiceView.h"
#import "DatePickerView.h"
#import "BBConfigTableViewCell.h"
#import "BBTaskAlertView.h"

@interface BBCollectPeopleChildViewController ()<DatePickerViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *dateBgView;
    DatePickerView *datePickerView;
    
    
    UIView *configBgView;
    UITableView *configTableView;
    NSMutableDictionary *configDic;   //name对应的index 后台设置的配置信息
    BBConfigModel *currentConfigModel;
    BBMineDetailBeanModel *currentConfigBeanModel;
    
    BBMineDetailBeanModel * _currenModel;
}

@end

@implementation BBCollectPeopleChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
}

-(void)viewDidLayoutSubviews {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_offset(200);

    }];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);  //距底部100
    //CGFloat top, left, bottom, right;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.initList) {
        self.initList = YES;
        [self refresh];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [dateBgView removeFromSuperview];
    [configBgView removeFromSuperview];
}

-(void)prepareData {
    BBMineDertailCellModel * groupCellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
    NSMutableArray<BBMineDetailBeanModel> * array = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
    _nameModel = [[BBMineDetailBeanModel alloc]init];
    _nameModel.title = @"姓名";
    _nameModel.placeHold = @"请输入采集人姓名";
    _nameModel.textField = kAppCacheInfo.userName;
    _nameModel.textLength = 10;
    _nameModel.row = 0;
    [array addObject:_nameModel];
    _sexModel = [[BBMineDetailBeanModel alloc]init];
    _sexModel.title = @"性别";
    _sexModel.row = 0;
    if ([kAppCacheInfo.sex isEqualToString:@"1"]) {
        _sexModel.summary = @"男";
    }else{
        _sexModel.summary = @"女";
    }
    _sexModel.imageName = @"Mine_Right_direct";
    [array addObject:_sexModel];
    _ageModel = [[BBMineDetailBeanModel alloc]init];
    _ageModel.title = @"年龄";
    _sexModel.row = 0;
    _ageModel.summary = kAppCacheInfo.age;
    if (String_IsEmpty(kAppCacheInfo.age)) {
        _ageModel.summary = @"请选择";
    }
    _ageModel.imageName = @"Mine_Right_direct";
    [array addObject:_ageModel];
    _placeModel = [[BBMineDetailBeanModel alloc]init];
    _placeModel.title = @"籍贯";
    _placeModel.row = 0;
    _placeModel.summary = kAppCacheInfo.nativePlace;
    _placeModel.imageName = @"Mine_Location";
    [array addObject:_placeModel];
    BBMineDetailListBeanModel * listBeanModel = [[BBMineDetailListBeanModel alloc]init];
    listBeanModel.detailArray = array;
    groupCellModel.beanModel = listBeanModel;
    [self.dataListArray addObject:groupCellModel];

    NSDictionary * titleDic = @{@"title": @"配置信息",@"leftDistance": @30 ,@"bottomDistance": @10,@"topDistance": @26,@"font": @16,@"height": @52};
    BBHomeTitleCellModel * titleCellModel = [[BBHomeTitleCellModel alloc]initWithData:titleDic];
    if (!Array_IsEmpty(self.detailModel.configLists)) {
        [self.dataListArray addObject:titleCellModel];
    }

    BBMineDertailCellModel * connectCellModel = [[BBMineDertailCellModel alloc]initWithData:nil];
//    NSMutableArray<BBMineDetailBeanModel> * connectArray = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
    
    _configArr = [[NSMutableArray alloc]init];
    configDic = [[NSMutableDictionary alloc]init];
    for (int i=0; i<_detailModel.configLists.count; i++) {
        BBConfigModel *configModel = _detailModel.configLists[i];
        BBMineDetailBeanModel *itemModel = [[BBMineDetailBeanModel alloc]init];
        itemModel.title = configModel.name;
        itemModel.row = 2;
        itemModel.summary = @"请选择";
        itemModel.imageName = @"Mine_Right_direct";
        [_configArr addObject:itemModel];
        
        [configDic setObject:[NSNumber numberWithInt:i] forKey:configModel.name];  //后台设置的配置信息
    }
    
//    _moodModel = [[BBMineDetailBeanModel alloc]init];
//    _moodModel.title = @"心情";
//    _moodModel.summary = @"请选择";
//    _moodModel.imageName = @"Mine_Right_direct";
//    [connectArray addObject:_moodModel];
    BBMineDetailListBeanModel * connectlistBeanModel = [[BBMineDetailListBeanModel alloc]init];
    connectlistBeanModel.detailArray = _configArr;
    connectCellModel.beanModel = connectlistBeanModel;
    [self.dataListArray addObject:connectCellModel];
    
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
    
    
    //创建配置项选择
    configBgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    configBgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    configBgView.alpha = 0.0;
    [kWindow addSubview:configBgView];
    
    UIButton *cancelConfigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelConfigBtn.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-150);
    [configBgView addSubview:cancelConfigBtn];
    [cancelConfigBtn addTarget:self action:@selector(cancelConfigView) forControlEvents:UIControlEventTouchUpInside];
    
    configTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-150, SCREENWIDTH, 150) style:UITableViewStylePlain];
    configTableView.delegate = self;
    configTableView.dataSource = self;
    configTableView.tableFooterView = [UIView new];
    [configBgView addSubview:configTableView];
    
}

-(void)cancelConfigView{
    [UIView animateWithDuration:0.3 animations:^{
        configBgView.alpha = 0.0;
//        datePickerView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 250);
    }];
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
    _currenModel.summary = [NSString dateToOld:date];
    [self dateTapCancel];
    
    [self refreshSection:0];
    if (_detailModel.configLists.count>0) {
        [self refreshSection:2];
    }
}


-(void)selctedCellWithModel:(BBMineDetailBeanModel *)model {
    if (model.row != 2) {
        if ([model.title isEqualToString:@"性别"]) {
            [self choiceSex:model];
        } else if ([model.title isEqualToString:@"籍贯"]) {
            [self choiceLocation:model];
        } else if ([model.title isEqualToString:@"年龄"]) {
            [self choiceAge:model];
        }
    } else {
        //配置信息
        if ([configDic objectForKey:model.title]) {
            int index = [[configDic objectForKey:model.title] intValue];
            currentConfigModel = _detailModel.configLists[index];
            currentConfigBeanModel = _configArr[index];
            if (currentConfigModel) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [configTableView reloadData];
                });
            }
            [self choiceConfig];
        }
    }
}

-(BaseSectionController *)getSectionController {
    BBMineDertailListSectionController * sectionController = [[BBMineDertailListSectionController alloc]init];
    return sectionController;
}

-(void)choiceSex:(BBMineDetailBeanModel*)model {
    BBMineGroupChoiceView * choiceView = [[BBMineGroupChoiceView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) titles:@[@"男",@"女"]];
    choiceView.choiceGroup = ^(ChoiceGroupType type) {
        if (type == CreatGroup) {//选的男
            model.summary = @"男";
        } else {
            model.summary = @"女";
        }
        [self refreshSection:(int)model.row];
       
        
    };
    [[UIApplication sharedApplication].keyWindow addSubview:choiceView];
    
}

-(void)choiceAge:(BBMineDetailBeanModel*)model {
    [self.view endEditing:YES];  //先丢失第一响应
    _currenModel = model;
    [UIView animateWithDuration:0.3 animations:^{
        dateBgView.alpha = 1.0;
        datePickerView.frame = CGRectMake(0, SCREENHEIGHT-250, SCREENWIDTH, 250);
    }];
    
//    _ageModel.summary = @"18";
//    [self refreshSection:0];
}

-(void)choiceLocation:(BBMineDetailBeanModel*)model {
    [self.view endEditing:YES];  //先丢失第一响应
    
    HmSelectAdView *selectV = [[HmSelectAdView alloc] initWithLastContent:self.currentProvince ? @[self.currentProvince, self.currentCity, self.currentArea] : nil];
    selectV.confirmSelect = ^(NSArray *address) {
        self.currentProvince = address[0];
        self.currentCity = address[1];
        self.currentArea = address[2];
        model.summary = [NSString stringWithFormat:@"%@ %@ %@", self.currentProvince, self.currentCity, self.currentArea];
        
        [self refreshSection:(int)model.row];

    };
    [selectV show];
    
}

-(void)choiceConfig {
    
    [self.view endEditing:YES];  //先丢失第一响应
    [UIView animateWithDuration:0.3 animations:^{
        configBgView.alpha = 1.0;
//        configTableView.frame = CGRectMake(0, SCREENHEIGHT-150, SCREENWIDTH, 150);
    }];
    
}

-(BOOL)canLoadMore {
    return false;
}

-(BOOL)canPullRefresh {
    return false;
}


#pragma mark - tableview dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentConfigModel.chooseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    BBConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BBConfigTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.configStr = currentConfigModel.chooseList[indexPath.row];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        currentConfigBeanModel.summary = currentConfigModel.chooseList[indexPath.row];
        [self cancelConfigView];
        [self refreshSection:2];
    });
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
@end
