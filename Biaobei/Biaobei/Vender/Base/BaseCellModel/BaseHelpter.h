//
//  BaseAdapter.h
//  WLBaseProject
//  网络请求，可以把存储放在这，下拉刷新成功后，把数据存储，下次请求失败时加载出来；
//  Created by 文亮 on 2019/8/26.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResolver.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BaseHelpterProtocol <NSObject>
-(void)pullRefreshSuccessResponse:(id)data;
-(void)pullRefreshFailResponse:(id)data;
-(void)loadMoreSuccessResponse:(id)data;
-(void)loadMoreFailResponse:(id)data;
@end

@interface BaseHelpter : NSObject
@property(nonatomic, strong) NSDictionary * params;
@property(nonatomic, strong) NSString * url;
@property(nonatomic, weak) id<BaseHelpterProtocol> delegate;
//解析器
@property(nonatomic,strong) BaseResolver * resolver;

//下拉刷新
-(void)startPullRefresh;

//上拉加载
-(void)startReloadMoreData;

//解析数据
-(NSArray *)getArrayFromResponse:(id)data;

//网络请求
-(void)requestNet;

@end

NS_ASSUME_NONNULL_END
