//
//  BBHomeListViewController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeListViewController.h"
#import "BBHomeTitleCellModel.h"
#import "BBHomeTitleBeanModel.h"
#import "BBHomeListBeanModel.h"
#import "BBHomeListCellModel.h"
#import "BBHomeBannerBeanModel.h"
#import "BBHomeBannerCellModel.h"
#import "BBHomeProjectDetailListViewController.h"
#import "BBHomeMakeSureCollectPeopleInfoController.h"
#import "BBCollectAudioViewController.h"
@interface BBHomeListViewController ()

@end

@implementation BBHomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareData];
    
    [self createSubViews];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.initList) {
        self.initList = YES;
        [self refresh];
    }
}

-(void)createSubViews{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(100, 400, 100, 40);
    Btn.backgroundColor = [UIColor grayColor];
    [Btn setTitle:@"接口测试" forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn];
}

-(void)BtnAction{
    
    BBCollectAudioViewController *collectAudioVC = [[BBCollectAudioViewController alloc]init];
    collectAudioVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectAudioVC animated:YES];
    
}

-(void)configCollectionViewAndAdapter {
    [super configCollectionViewAndAdapter];
    self.collectionView.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
}

-(void)viewDidLayoutSubviews {
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(StatusBarHeight);
    }];
}

-(void)prepareData {

    NSDictionary * titleDic = @{@"title": @"数据工厂",@"leftDistance": @16 ,@"bottomDistance": @12,@"topDistance": @12,@"font": @36,@"height": @55};
    BBHomeTitleCellModel * titleCellModel = [[BBHomeTitleCellModel alloc]initWithData:titleDic];
    [self.dataListArray addObject:titleCellModel];
    BBHomeBannerCellModel * bannerCellModel = [[BBHomeBannerCellModel alloc]initWithData:@{@"title":@"粤语女声千句采集任务",@"summary":@"让美妙的声音飞起来"}];
    [self.dataListArray addObject:bannerCellModel];
    NSDictionary * summaryDic = @{@"title": @"任务列表",@"leftDistance": @16 , @"bottomDistance": @13,@"topDistance": @13,@"font": @20,@"height": @46};
    BBHomeTitleCellModel * summaryCellModel = [[BBHomeTitleCellModel alloc]initWithData:summaryDic];
    [self.dataListArray addObject:summaryCellModel];
    for (int i = 0; i<10; i++) {
        BBHomeListCellModel * cellModel = [[BBHomeListCellModel alloc]initWithData:nil];
        BBHomeListBeanModel * beanModel = (BBHomeListBeanModel *)cellModel.beanModel;
        beanModel.title = [NSString stringWithFormat:@"%d %@",i,@"粤语女声1000句采集任务"];
        beanModel.summary = @"2019-08-20 至 2019-08-30";
        beanModel.tipString = [self getAttributeString:@"多人采集  相同文本"];
        beanModel.type = i%4;
        [self.dataListArray addObject:cellModel];
    }
}

-(NSAttributedString *)getAttributeString: (NSString *)tip {
    return [[NSAttributedString alloc] initWithString:tip];
}

-(BOOL)canLoadMore {
    return false;
}

-(BOOL)canPullRefresh {
    return false;
}

-(void)didSelectItemAtSection:(NSInteger)section Indext:(NSInteger)index withModel:(BaseCellModel *)model {

    if ([model isKindOfClass:BBHomeListCellModel.class]) {
        BBHomeListBeanModel * beanModel = (BBHomeListBeanModel *)model.beanModel;
        BBHomeProjectDetailListViewController * controller = [[BBHomeProjectDetailListViewController alloc]init];
        controller.title = beanModel.title;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        BBHomeMakeSureCollectPeopleInfoController * controller = [[BBHomeMakeSureCollectPeopleInfoController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
