//
//  BaseListViewController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/25.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseListViewController.h"
#import <MJRefresh/MJRefresh.h>


@interface BaseListViewController ()<IGListAdapterDataSource, BaseSectionControllerDelegate,BaseHelpterProtocol> {
    
}


@end

@implementation BaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareSetting];
}

//开始下拉刷新
-(void)startPullRefresh {
    [self.collectionView.mj_header beginRefreshing];
}

-(void)prepareSetting {
    self.dataListArray = [[NSMutableArray alloc]init];
    [self initDatahelper];
    [self configCollectionViewAndAdapter];
}

//准备解析数据的helper
-(void)initDatahelper {
    self.dataHelper = [[BaseHelpter alloc] init];
    self.dataHelper.delegate = self;
}

-(void)initResolver {
    self.resolver = [[BaseResolver alloc]init];
    self.dataHelper.resolver = self.resolver;
}

-(void)viewDidLayoutSubviews {
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

//初始化collectionView和Adapter
-(void)configCollectionViewAndAdapter {
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[IGListCollectionViewLayout alloc] initWithStickyHeaders:YES topContentInset:0 stretchToEdge:false]];
    _collectionView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248.0/255 blue:251.0/255 alpha:1];
    
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    _adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self workingRangeSize:0];
    if ([self canPullRefresh]) {
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(insertRowAtTop)];
    }

    if ([self canLoadMore]) {
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(insertRowAtBottom)];
    }
    _collectionView.userInteractionEnabled = YES;
    _collectionView.alwaysBounceVertical = YES;
    _adapter.collectionView = _collectionView;
    _adapter.dataSource = self;
}

//请求数据
-(id)configRequestData {
    return self.params;
}

//请求url
-(NSString *)configRequestUrl {
    return _url;
}

//获取解析器
-(BaseResolver *)getResolve {
    return self.resolver;
}

//下拉刷新
-(void)insertRowAtTop {
    self.dataHelper.url = [self configRequestUrl];
    self.dataHelper.params = [self configRequestData];
    self.dataHelper.resolver = [self getResolve];
    [self.dataHelper startPullRefresh];
}

//上拉加载
-(void)insertRowAtBottom {
    self.dataHelper.url = [self configRequestUrl];
    self.dataHelper.params = [self configRequestData];
    self.dataHelper.resolver = [self getResolve];
    [self.dataHelper startReloadMoreData];
}

/*
 datas是返回的数据，需要后台统一后，定一个统一的解析模式，如果不统一，只能没个单独解析了
 */
//下拉刷新获取到数据
-(void)reLoadData:(id)data {
    [self reloadDataList:[self.dataHelper getArrayFromResponse:data]];
}

//下拉刷新失败
-(void)reloadDataError:(id)data {
    [self closePullToRefreshView];
}

//下拉刷新请求到的数据
-(void)reloadDataList:(NSArray *)data {
    [self.dataListArray removeAllObjects];
    [self.dataListArray addObjectsFromArray:data];
    [self refresh];
    [self closePullToRefreshView];
}

//上拉加载更多
-(void)loadMoreData:(id)data {
    [self loadMoreDataList:[self.dataHelper getArrayFromResponse:data]];
}

//上啦加载失败
-(void)loadMoreError:(id)data {
    //缺一个失败提示

    [self closeLoadMoreRefreshView];
}

//上拉加载请求到的数据
-(void)loadMoreDataList:(NSArray *)data {
    [self.dataListArray addObjectsFromArray:data];
    [self refresh];
    [self closeLoadMoreRefreshView];
}

//关闭下拉刷新
-(void)closePullToRefreshView {
    [self.collectionView.mj_header endRefreshing];
}

//关闭上拉加载
-(void)closeLoadMoreRefreshView {
    [self.collectionView.mj_footer endRefreshing];
}

//上拉加载不到更多数据
-(void)endRefreshingWithNoMoreData{
    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
}

-(BaseSectionController *)getSectionController {
    BaseSectionController * sectionController = [[BaseSectionController alloc]init];
    sectionController.delegate = self;
    return sectionController;
}

-(void)refresh {
    [self.adapter performUpdatesAnimated:YES completion:nil];
}

-(void)refreshSection:(int)section {
    NSArray * array = [[NSArray alloc] initWithObjects:self.dataListArray[section], nil];
    [self.adapter reloadObjects:array];
}

/*
 埋两个钩子
 */
//是否可以上拉加载
-(BOOL)canLoadMore {
    return YES;
}

//是否可以下拉刷新
-(BOOL)canPullRefresh {
    return YES;
}

//这里做适配，方便controller作为childController添加
-(void)viewWillLayoutSubviews {
//    self.collectionView.frame = self.view.bounds;
}

- (nonnull IGListSectionController *)listAdapter:(nonnull IGListAdapter *)listAdapter sectionControllerForObject:(nonnull id)object {
    return  [self getSectionController];
}

-(NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return _dataListArray;
}

-(UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

-(void)didSelectItemAtSection:(NSInteger)section Indext:(NSInteger)index withModel:(BaseCellModel *)model {

}

- (void)loadMoreFailResponse:(nonnull id)data {
    [self loadMoreFailResponse:data];
}

- (void)loadMoreSuccessResponse:(nonnull id)data {
    [self loadMoreData:data];
}

- (void)pullRefreshFailResponse:(nonnull id)data {
    [self pullRefreshFailResponse:data];
}

- (void)pullRefreshSuccessResponse:(nonnull id)data {
    [self reLoadData:data];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
