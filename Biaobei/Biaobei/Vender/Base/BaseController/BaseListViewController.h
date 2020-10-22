//
//  BaseListViewController.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/25.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseViewController.h"
#import <IGListKit/IGListKit.h>
#import "BaseResolver.h"
#import "BaseHelpter.h"
#import "BaseSectionController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseListViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray * dataListArray;
@property (nonatomic, strong) IGListAdapter * adapter;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) BaseHelpter * dataHelper;
//请求接口用的字典
@property (nonatomic, strong) NSDictionary * params;
@property (nonatomic, strong) NSString * url;
//解析器
@property (nonatomic, strong) BaseResolver * resolver;
@property (nonatomic, assign) BOOL initList;

/*
 埋两个钩子
 */
//是否可以上拉加载
-(BOOL)canLoadMore;

//是否可以下拉刷新
-(BOOL)canPullRefresh;

//准备解析数据的helper
-(void)initDatahelper;

//初始化collectionView和Adapter
-(void)configCollectionViewAndAdapter;

//获取解析器
-(BaseResolver *)getResolve;

//请求数据
-(id)configRequestData;

//请求url
-(NSString *)configRequestUrl;

//开始下拉刷新
-(void)startPullRefresh;

//下拉刷新
-(void)insertRowAtTop;

//上拉加载
-(void)insertRowAtBottom;

/*
 datas是返回的数据，需要后台统一后，定一个统一的解析模式，如果不统一，只能没个单独解析了
 */
//下拉刷新获取到数据
-(void)reLoadData:(id)data;

//下拉刷新失败
-(void)reloadDataError:(id)data;

//下拉刷新请求到的数据
-(void)reloadDataList:(NSArray *)data;

//上拉加载更多
-(void)loadMoreData:(id)data;

//上啦加载失败
-(void)loadMoreError:(id)data;

//上拉加载请求到的数据
-(void)loadMoreDataList:(NSArray *)data;

//关闭下拉刷新
-(void)closePullToRefreshView;

//关闭上拉加载
-(void)closeLoadMoreRefreshView;

//上拉加载不到更多数据
-(void)endRefreshingWithNoMoreData;

//获取sectionController
-(BaseSectionController *)getSectionController;

-(void)didSelectItemAtSection:(NSInteger)section Indext:(NSInteger)index withModel:(BaseCellModel *)model;

//全部刷新
-(void)refresh;

//刷新局部
-(void)refreshSection:(int)section;

@end

NS_ASSUME_NONNULL_END
