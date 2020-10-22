//
//  BBMineTaskStatusViewController.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/23.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineTaskStatusViewController.h"
#import "BBMineStatusTaskTableViewCell.h"
#import "BBTipDetailListViewController.h"

@interface BBMineTaskStatusViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UILabel *statusLabel;
    UITableView *taskTableView;
    NSMutableArray *dataArr;
    
    int loadDataCount;
    
    UIView *taskView;  //任务背景图
}

@end

@implementation BBMineTaskStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArr = [[NSMutableArray alloc]init];
    [self getData];
    [self createSubViews];
}

-(void)createSubViews{
    //1.
    statusLabel = [UIFactory createLab:CGRectMake(23, 17, 300, 40) text:@"" textColor:BlackColor textFont:kFontMediumSize(36) textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:statusLabel];
    
    //0 未提交 1质检中 2未通过 3完成
    if ([_status isEqualToString:@"0"]) {//0 未提交
        statusLabel.text = @"未提交";
    }else if ([_status isEqualToString:@"1"]){//1质检中
        statusLabel.text = @"质检中";
    }else if ([_status isEqualToString:@"2"]){//2未通过
        statusLabel.text = @"未通过";
    }else if ([_status isEqualToString:@"3"]){//3完成
        statusLabel.text = @"已通过";
    }
    //2.
    taskTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, statusLabel.bottom+20, SCREENWIDTH, SCREENHEIGHT-StatusAndNaviHeight-statusLabel.bottom-20) style:UITableViewStylePlain];
    taskTableView.delegate = self;
    taskTableView.dataSource = self;
    taskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    taskTableView.backgroundColor = [UIColor colorWithHex:@"#F8F8FB"];
    [self.view addSubview:taskTableView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    taskTableView.mj_header = header;

    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];  //隐藏加载完毕时的提示
    taskTableView.mj_footer = footer;
    
    [self initTaskStyle];  //无任务背景
}

//无任务背景
- (void)initTaskStyle {
    taskView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-150)/2, (SCREENHEIGHT-110)/2-50, 150, 110)];
    taskView.backgroundColor = [UIColor clearColor];
    taskView.hidden = YES;  //初始化时隐藏无任务背景
    [self.view addSubview:taskView];
    
    UIImageView *noImgView = [[UIImageView alloc]initWithFrame:CGRectMake((150-47)/2, 2, 47, 52)];
    noImgView.image = [UIImage imageNamed:@"Combined Shape"];
    [taskView addSubview:noImgView];
    
    UILabel *noLabel = [[UILabel alloc]initWithFrame:CGRectMake(noImgView.left-5, noImgView.bottom+10, 150, 20)];
    noLabel.textColor = [UIColor colorWithHex:@"#8890A9"];
    noLabel.font = kFontRegularSize(14);
    //    noLabel.text = @"暂无任务\n你可以“回到首页”领取";
    noLabel.text = @"暂无数据";
    noLabel.numberOfLines = 0;
    [noLabel sizeToFit];
    noLabel.textAlignment = NSTextAlignmentCenter;
    [taskView addSubview:noLabel];
}

-(void)getData{
    loadDataCount++;
    if (loadDataCount==1) {
        [dataArr removeAllObjects];
    }
    
    NSString *pageNum = [NSString stringWithFormat:@"%d",loadDataCount];
    NSDictionary *params = @{
                              @"pageNum":pageNum,
                              @"pageSize":@"10"
                            };
    [[BBRequestManager sharedInstance] getUserTaskListWithStatus:_status params:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        BBHomeTaskListModel *taskListModel = (BBHomeTaskListModel *)model;
        NSArray *list = taskListModel.list;
        [dataArr addObjectsFromArray:list];
        
        BOOL hasNextPage = taskListModel.hasNextPage;
        dispatch_async(dispatch_get_main_queue(), ^{
           if (dataArr.count == 0) {
                taskView.hidden = NO;  //显示无任务背景图
            } else {
                taskView.hidden = YES;  //显示无任务背景图
            }
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

#pragma mark - tableview dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    BBMineStatusTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BBMineStatusTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor colorWithHex:@"#F8F8FB"];
    }
    BBHomeTaskModel *taskModel = dataArr[indexPath.row];
    cell.status = _status;
    cell.model = taskModel;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BBHomeTaskModel *model = dataArr[indexPath.row];
    if ([_status isEqualToString:@"0"]) {
        //未提交
        NSInteger endNum = model.endtime.integerValue;
        NSInteger sysNum = model.systemtime.integerValue;
        if (sysNum>=endNum || [model.noPowder isEqualToString:@"1"]) {//结束或者无权访问
            return;
        }
        BBTipDetailListViewController * controller = [[BBTipDetailListViewController alloc]init];
        [controller tag:NoRefer];
        controller.task_id = model.task_id;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([_status isEqualToString:@"1"]){
        //质检中
        return;
    } else if ([_status isEqualToString:@"2"]){
        //未通过 - 任务目录：未质检|未通过
        BBTipDetailListViewController * controller = [[BBTipDetailListViewController alloc]init];
        [controller tag:Checking];  //质检  未质检|未通过
        controller.task_id = model.task_id;
//        controller.isNoPass = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([_status isEqualToString:@"3"]){
        //完成
        return;
    }
    
}

#pragma mark - 上下拉
-(void)loadNewData{
    loadDataCount = 0;
    [self getData];
}

-(void)loadMoreData{
    loadDataCount++;
    [self getData];
}

@end
