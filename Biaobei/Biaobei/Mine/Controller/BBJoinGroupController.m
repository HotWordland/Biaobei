//
//  BBJoinGroupController.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/19.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBJoinGroupController.h"
#import "BBSearchTableViewCell.h"

@interface BBJoinGroupController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *searchTextField;
    UITableView *searchTableView;
    NSMutableArray *dataArr;
    
    int loadDataCount;
}

@end

@implementation BBJoinGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"加入团队";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F8F8FB"];
    dataArr = [[NSMutableArray alloc]init];
    
    [self createSubViews];
    [self resgisterEnditing];
}

-(void)createSubViews{
    //1.
    UIView *searchBgView = [[UIView alloc]initWithFrame:CGRectMake(12, 20, SCREENWIDTH-24, 66)];
    searchBgView.backgroundColor = WhiteColor;
    searchBgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    searchBgView.layer.shadowOffset = CGSizeMake(0,0);
    searchBgView.layer.shadowOpacity = 1;
    searchBgView.layer.shadowRadius = 8;
    searchBgView.layer.cornerRadius = 5;
    [self.view addSubview:searchBgView];
    
    searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, searchBgView.width-60, 66)];
    searchTextField.font = kFontMediumSize(17);
    searchTextField.textColor = BlackColor;
    searchTextField.placeholder = @"请输入团队名称";
    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    [searchBgView addSubview:searchTextField];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(searchBgView.width-60, 0, 50, 66);
    [searchBtn setImage:[UIImage imageNamed:@"Mine_search"] forState:UIControlStateNormal];
    [searchBgView addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //2.
    searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchBgView.bottom+12, SCREENWIDTH, SCREENHEIGHT-StatusAndNaviHeight-searchBgView.bottom-12) style:UITableViewStylePlain];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:searchTableView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    searchTableView.mj_header = header;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    searchTableView.mj_footer = footer;
    searchTableView.mj_footer.hidden = YES;
    
}

#pragma  mark - 事件方法
-(void)getSearchData{
    if (!searchTextField.text.length) {
        [searchTableView.mj_header endRefreshing];
        [searchTableView.mj_footer endRefreshing];
        return;
    }
    
    loadDataCount++;
    if (loadDataCount==1) {
        [dataArr removeAllObjects];
    }
    
    NSString *pageNum = [NSString stringWithFormat:@"%d",loadDataCount];
    
    NSDictionary *params = @{
                             @"pageNum":pageNum,
                             @"pageSize":@"10",
                             @"teamName":searchTextField.text
                             };
    [[BBRequestManager sharedInstance] searchTeamWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        BBSearchGroupModel *searchModel = (BBSearchGroupModel *)model;
        
        BOOL hasNextPage = searchModel.hasNextPage;
        [dataArr addObjectsFromArray:searchModel.list];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchTableView.mj_header endRefreshing];
            [searchTableView.mj_footer endRefreshing];
            [searchTableView reloadData];
            
            if (!hasNextPage) {
                [searchTableView.mj_footer endRefreshingWithNoMoreData];
            }
        });
        
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchTableView.mj_header endRefreshing];
            [searchTableView.mj_footer endRefreshing];
        });
//        [self showMessage:error];
    }];
}

-(void)searchBtnAction{
    searchTableView.mj_footer.hidden = NO;
    
    [searchTextField resignFirstResponder];
    if (!searchTextField.text.length) {
        return;
    }
    
    loadDataCount = 0;
    [self getSearchData];
}

#pragma mark - tableview dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    BBSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BBSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor colorWithHex:@"#F8F8FB"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BBGroupInfoModel *infoModel = dataArr[indexPath.row];
    cell.groupInfoModel = infoModel;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}

#pragma mark - 上下拉
-(void)loadNewData{
    loadDataCount = 0;
    [self getSearchData];
}

-(void)loadMoreData{
    loadDataCount++;
    [self getSearchData];
}


@end
