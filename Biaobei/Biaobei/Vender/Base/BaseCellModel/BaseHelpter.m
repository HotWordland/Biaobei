//
//  BaseAdapter.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/26.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseHelpter.h"

@implementation BaseHelpter

-(instancetype)init {
    if (self = [super init]) {
    
    }
    return self;
}

//下拉刷新
-(void)startPullRefresh {
    [self requestNet];
}

//上拉加载
-(void)startReloadMoreData {
    [self requestNet];
}

//解析数据
-(NSArray *)getArrayFromResponse:(id)data {
    return [self.resolver getDataFromResponse:data];
}

-(void)requestNet {

}

@end
