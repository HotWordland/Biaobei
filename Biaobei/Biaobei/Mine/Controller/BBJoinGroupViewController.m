//
//  BBJoinGroupViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBJoinGroupViewController.h"
#import "BBJoinGroupUsualCellModel.h"
#import "BBMineJoinGropSearchBeanModel.h"
#import "BBMineJoinGropSearchCellModel.h"
#import "BBMineDetailListBeanModel.h"
#import "BBMineApplyPeopleView.h"
#import "BBGroupTranslationViewController.h"

@interface BBJoinGroupViewController () {
    NSString * _serchName;
    BBMineJoinGropSearchCellModel * _searchCellModel;
}

@end

@implementation BBJoinGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"加入团队";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchButtonClick:) name:@"searchGroup" object:nil];
    [self prepareData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.initList) {
        self.initList = YES;
        [self refresh];
    }
}

-(void)prepareData {
    _searchCellModel = [[BBMineJoinGropSearchCellModel alloc]initWithData:@{@"title":@"",@"imageName":@"Mine_search"}];
    [self.dataListArray addObject:_searchCellModel];
}

-(void)searchButtonClick:(NSNotification *)notification {
    _serchName = notification.object;
    BBMineJoinGropSearchBeanModel * beanModel = (BBMineJoinGropSearchBeanModel *)_searchCellModel.beanModel;
    beanModel.title = _serchName;
    [self.dataListArray removeAllObjects];
    [self.dataListArray addObject:_searchCellModel];
    [self refresh];
//    if (_serchName.length != 0) {
//        [self startPullRefresh];
//    }
    [self addList];
}

-(void)addList {
    for (int i=0; i<3; i++) {
        BBJoinGroupUsualCellModel * cellModel = [[BBJoinGroupUsualCellModel alloc]initWithData:nil];
        NSMutableArray<BBMineDetailBeanModel> * array = [[NSMutableArray<BBMineDetailBeanModel> alloc]init];
        BBMineDetailBeanModel * nameBeanModel = [[BBMineDetailBeanModel alloc]init];
        nameBeanModel.title = @"标贝科技";
        nameBeanModel.summary = @"团队成员：15人";
        [array addObject:nameBeanModel];
        BBMineDetailBeanModel * sexBeanModel = [[BBMineDetailBeanModel alloc]init];
        sexBeanModel.title = @"团队简介";
        sexBeanModel.summary = @"成员在一起只为改变世界";
        [array addObject:sexBeanModel];
        BBMineDetailBeanModel * ageBeanModel = [[BBMineDetailBeanModel alloc]init];
        ageBeanModel.title = @"所属地区";
        ageBeanModel.summary = @"北京 朝阳";
        [array addObject:ageBeanModel];
        BBMineDetailBeanModel * cityBeanModel = [[BBMineDetailBeanModel alloc]init];
        cityBeanModel.title = @"相关资质";
        cityBeanModel.summary = @"上传照片";
        [array addObject:cityBeanModel];
        BBMineDetailListBeanModel * listBeanModel = [[BBMineDetailListBeanModel alloc]init];
        listBeanModel.detailArray = array;
        cellModel.beanModel = listBeanModel;
        [self.dataListArray addObject:cellModel];
    }
    
}

-(void)insertRowAtTop {
    if (_serchName.length == 0) {
        [self closePullToRefreshView];
    } else {
        [super insertRowAtTop];
    }
}

-(void)reloadDataList:(NSArray *)data {
    [self.dataListArray removeAllObjects];
    [self.dataListArray addObjectsFromArray:data];
    [self refresh];
    [self closePullToRefreshView];
}

-(BOOL)canLoadMore {
    return false;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didSelectItemAtSection:(NSInteger)section Indext:(NSInteger)index withModel:(BaseCellModel *)model {
    if (section != 0) {
        __weak typeof(BBJoinGroupViewController *) weakSelf = self;
        BBMineApplyPeopleView * applyPeopleview = [[BBMineApplyPeopleView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        applyPeopleview.change = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };

        applyPeopleview.sure = ^{
            [weakSelf makeSureJoinGroup];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:applyPeopleview];
    }
}

-(void)makeSureJoinGroup {
    BBGroupTranslationViewController * controller = [[BBGroupTranslationViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
