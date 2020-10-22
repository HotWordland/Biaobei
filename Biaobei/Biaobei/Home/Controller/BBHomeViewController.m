//
//  BBHomeViewController.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/19.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeViewController.h"
#import "SDCycleScrollView.h"
#import "BBHomeTaskTableViewCell.h"
#import "BBTaskDetailViewController.h"
#import "BBTipDetailListViewController.h"
#import "BaseWebViewController.h"
#import "CarouselsCollectionViewCell.h"
#import "TaskToastView.h"

@interface BBHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate> {
    UIView *headerView;
    UILabel *timeLabel;
    
    SDCycleScrollView *bannerView;  //轮播背景
//    UILabel *bannerTitleLabel;
//    UILabel *banner_descLabel;
//    UIImageView *urgentImgView;  //加急任务标识
    
    
//    SDCycleScrollView *carouselsView;  //轮播图
    CarouselsCollectionViewCell *carouselCell;  //自定义轮播Cell

    
    
    UITableView *taskTableView;
    NSMutableArray *dataArr;
    
    int loadDataCount;
}

@property (nonatomic, strong)  NSMutableArray *urgentDataArr;

@end

@implementation BBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArr = [[NSMutableArray alloc]init];
    self.urgentDataArr = [[NSMutableArray alloc]init];
    [self createSubViews];
    [self getUrgentListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.tabBarController.tabBar setHidden:NO];

    loadDataCount = 0;
    [self getTaskListData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)createSubViews{
    //1.头视图
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
    headerView.backgroundColor = [UIColor colorWithHex:@"#F8F8FB"];
    
    NSString *currentTime = [[NSDate date] currentDateStr];
    timeLabel = [UIFactory createLab:CGRectMake(15, StatusBarHeight+15, 300, 20) text:currentTime textColor:[UIColor colorWithHex:@"#9499A1"] textFont:kFontMediumSize(16) textAlignment:NSTextAlignmentLeft];
    [headerView addSubview:timeLabel];
    
    UILabel *titleLabel = [UIFactory createLab:CGRectMake(15, timeLabel.bottom+10, 300, 40) text:@"数据工场" textColor:BlackColor textFont:kFontMediumSize(36) textAlignment:NSTextAlignmentLeft];
    [headerView addSubview:titleLabel];
    
    //需求采集
    UIButton *demandBtn = [UIFactory createBtn:CGRectMake(SCREENWIDTH-32-12, timeLabel.top, 32, 32) text:@"" textColor:WhiteColor textFont:kFontMediumSize(10) backGroundColor:WhiteColor trail:self action:@selector(demandBtnAction) tag:100092 isRaduis:NO];
    [demandBtn setImage:[UIImage imageNamed:@"Rectangle"] forState:UIControlStateNormal];
    [headerView addSubview:demandBtn];
    
    //轮播展示
    NSArray *bannerImages = @[];  //传入图片总数
    CGRect bannerRect = CGRectMake(12, titleLabel.bottom + 15, SCREENWIDTH - 24, 140);

    //初始化轮播组件
    bannerView = [SDCycleScrollView cycleScrollViewWithFrame:bannerRect delegate:self placeholderImage:nil];
    bannerView.localizationImageNamesGroup = bannerImages;  //轮播图片数并不真实传值
    bannerView.layer.cornerRadius = 6;
    bannerView.clipsToBounds = YES;
    bannerView.autoScrollTimeInterval = 3.0;
    bannerView.pageControlRightOffset = -135 * kScale;
    [headerView addSubview:bannerView];
    
    //任务列表标题
    UILabel *taskLabel = [UIFactory createLab:CGRectMake(15, bannerView.bottom + 24, 300, 22) text:@"任务列表" textColor:BlackColor textFont:kFontMediumSize(20) textAlignment:NSTextAlignmentLeft];
    [headerView addSubview:taskLabel];
    headerView.height = taskLabel.bottom+15;
    
    //任务列表
    taskTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-TabbarAndSafeHeight) style:UITableViewStylePlain];
    taskTableView.delegate = self;
    taskTableView.dataSource = self;
    taskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    taskTableView.tableHeaderView = headerView;
    [self.view addSubview:taskTableView];
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    taskTableView.mj_header = header;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    taskTableView.mj_footer = footer;
}

//隐藏轮播图
- (void)hiddenBannerView:(BOOL)hidden {
//    if (hidden) {
//        urgentImgView.hidden = YES;
//        bannerTitleLabel.hidden = YES;
//        banner_descLabel.hidden = YES;
//    } else {
//        urgentImgView.hidden = NO;
//        bannerTitleLabel.hidden = NO;
//        banner_descLabel.hidden = NO;
//    }
}

-(void)getTaskListData {
//    BOOL is = [BBNetWorkManager networkReachability];
//    if (!is) {
//        [self showMessage:@"请检查网络连接是否正常"];
//        return;
//    }
    
    loadDataCount++;
    if (loadDataCount==1) {
        timeLabel.text = [[NSDate date] currentDateStr];
        [dataArr removeAllObjects];
    }
    
    NSString *pageNum = [NSString stringWithFormat:@"%d",loadDataCount];
    NSString *teamId = kAppCacheInfo.teamId;
    if (!teamId) {
        teamId = @"";
    }
    NSDictionary *params = @{
                              @"pageNum":pageNum,
                              @"pageSize":@"10",
                              @"teamId":teamId,
                              @"is_express":@"0"
                            };
    
    [[BBRequestManager sharedInstance]getTaskListWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
    
        BBHomeTaskListModel *taskListModel = (BBHomeTaskListModel *)model;
        NSArray *list = taskListModel.list;
        [dataArr addObjectsFromArray:list];
        
        BOOL hasNextPage = taskListModel.hasNextPage;
        dispatch_async(dispatch_get_main_queue(), ^{
            [taskTableView.mj_header endRefreshing];
            [taskTableView.mj_footer endRefreshing];
            [taskTableView reloadData];
            
            if (!hasNextPage) {
                [taskTableView.mj_footer endRefreshingWithNoMoreData];
            }
        });
        
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [taskTableView.mj_header endRefreshing];
            [taskTableView.mj_footer endRefreshing];
        });
//        [self showMessage:error];
    }];
}

//获取加急任务
-(void)getUrgentListData {
    NSString *teamId = kAppCacheInfo.teamId;
    if (!teamId) {
        teamId = @"";
    }
    NSDictionary *params = @{
                              @"pageNum":@"1",
                              @"pageSize":@"3",
                              @"is_express":@"1",
                              @"teamId":teamId
                            };
    
    [[BBRequestManager sharedInstance] getTaskListWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        BBHomeTaskListModel *taskListModel = (BBHomeTaskListModel *)model;
        [self.urgentDataArr removeAllObjects];
        [self.urgentDataArr addObjectsFromArray:taskListModel.list];

        NSMutableArray *imagePathArray = [[NSMutableArray alloc] init];
        NSUInteger count = self.urgentDataArr.count;
        if (count > 3) {
            count = 3;
        }
        //加急任务最多3个
        for (int i = 0; i < count; i++) {
            NSString *path = @"";
            [imagePathArray addObject:path];;
        }
       bannerView.localizationImageNamesGroup = imagePathArray;  //更改图片数
      
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];
}

//需求采集按钮事件
-(void)demandBtnAction{
//    http://data-baker.mikecrm.com/C8hzdK9
    BaseWebViewController *webViewVC = [[BaseWebViewController alloc]init];
    webViewVC.urlStr = @"http://data-baker.mikecrm.com/C8hzdK9";
    webViewVC.webTitle = @"数据工场需求采集表";
    webViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewVC animated:YES];
}

#pragma mark - 轮播代理 -

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (index > 2) {
        //加急任务最多3个
        return;
    }
    BBHomeTaskModel *model = self.urgentDataArr[index];

//    if (model.taskProgress == 1 || model.taskProgress == 2 ||model.taskProgress == 6) {
//        [self showMessage:@"质检中..."];  //用户提交成功
//        return;
//    } else if (model.taskProgress == 3) {
//        [self showMessage:@"该任务已成功采集，快去领取其他任务吧"];
//        return;
//    } else if (model.taskProgress == 4) {
//        [self showMessage:@"审核未通过"];
//        return;
//    } else if (model.taskProgress == 5) {
//        [self showMessage:@"审核未通过"];
//        return;
//    } else if (model.taskProgress == -1) {
//        //未领取，进入采集确认界面
//        BBTaskDetailViewController * controller = [[BBTaskDetailViewController alloc]init];
//        controller.taskId = model.task_id;
//        controller.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:controller animated:YES];
//    } else {
//        //已领取，进入录制任务界面
//        BBTipDetailListViewController *controller = [[BBTipDetailListViewController alloc]init];
//        [controller tag:NoRefer];
//        controller.task_id = model.task_id;
//        controller.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:controller animated:YES];
//    }
    
    if (model.taskProgress == -1) {
        //未领取，进入采集确认界面
        BBTaskDetailViewController * controller = [[BBTaskDetailViewController alloc]init];
        controller.taskId = model.task_id;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else  if (model.taskProgress == 0) {
        //已领取，进入录制任务界面
        BBTipDetailListViewController *controller = [[BBTipDetailListViewController alloc]init];
        [controller tag:NoRefer];
        controller.task_id = model.task_id;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        NSString *message = @"该任务已成功采集\n快去领取其他任务吧";
        TaskToastView *toast = [[TaskToastView alloc] init:message];
        toast.taskBlock = ^{
        };
    }
    
}

- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    return [CarouselsCollectionViewCell class];  //返回自定义CollectionViewCell  框架内部初始化***
}

/* 代理方法中设置自定义Cell的内容 */
- (void)setupCustomCell:(UICollectionViewCell *)cell
               forIndex:(NSInteger)index
        cycleScrollView:(SDCycleScrollView *)view {
    [self setupCarouselCell:cell index:index];
}

- (void)setupCarouselCell:(UICollectionViewCell *)cell index:(NSInteger)index {
    BBHomeTaskModel *model = self.urgentDataArr[index];
    
    carouselCell = (CarouselsCollectionViewCell *)cell;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"banner%li",(long)index+1]];
    carouselCell.imageView.image = image;
    
    if ([model.is_express isEqualToString:@"1"]) {
        carouselCell.promptImageView.image = [UIImage imageNamed:@"加急"];
    }
   
    NSString *title = model.projectName;
    if (title.length > 10) {
        title = [title substringToIndex:10];  //单行显示
    }
    carouselCell.titleLabel.text = title;
    
    NSString *typeText = @"";
    NSString *collectType = model.collectType;
    if ([collectType isEqualToString:@"0"]) {
        typeText  = @"多人采集相同文本";
    } else if ([collectType isEqualToString:@"1"]){
        typeText  = @"多人采集不同文本";
    } else if ([collectType isEqualToString:@"2"]){
        typeText  = @"无文本采集";
    }
    carouselCell.typeLabel.text = typeText;
}

#pragma mark - Tableview DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    BBHomeTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BBHomeTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor colorWithHex:@"#F8F8FB"];
    }
    if (dataArr.count) {
        BBHomeTaskModel *taskModel = dataArr[indexPath.row];
        cell.model = taskModel;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!dataArr.count) {
        return;
    }
    BBHomeTaskModel *model = dataArr[indexPath.row];
    
    if (model.is_receive) {
//        if (model.taskProgress == 1 || model.taskProgress == 2 ||model.taskProgress == 6) {
//            [self showMessage:@"质检中..."];  //用户提交成功
//            return;
//        } else if (model.taskProgress == 3) {
//            [self showMessage:@"该任务已成功采集，快去领取其他任务吧"];
//            return;
//        } else if (model.taskProgress == 4) {
//            [self showMessage:@"审核未通过"];
//            return;
//        } else if (model.taskProgress == 5) {
//            [self showMessage:@"审核未通过"];
//            return;
//        }
        
        if (model.taskProgress == -1) {
            //未领取，进入采集确认界面
            BBTaskDetailViewController * controller = [[BBTaskDetailViewController alloc]init];
            controller.taskId = model.task_id;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        } else  if (model.taskProgress == 0) {
            //已领取，进入录制任务界面
            BBTipDetailListViewController *controller = [[BBTipDetailListViewController alloc]init];
            [controller tag:NoRefer];
            controller.task_id = model.task_id;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            NSString *message = @"该任务已成功采集\n快去领取其他任务吧";
            TaskToastView *toast = [[TaskToastView alloc] init:message];
            toast.taskBlock = ^{
            };
        }
        
        
      
    } else {
        //当前用户未领取任务 进入采集人授权界面
        BBTaskDetailViewController *controller = [[BBTaskDetailViewController alloc]init];
        controller.taskId = model.task_id;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - 上下拉 -

-(void)loadNewData{
    loadDataCount = 0;
    [self getTaskListData];
    [self getUrgentListData];
}

-(void)loadMoreData{
    loadDataCount++;
    [self getTaskListData];
}


@end
