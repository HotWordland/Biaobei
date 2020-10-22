//
//  BBManagerGroupListViewController.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseListViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^newBlock)(BOOL);  //成员加入

typedef void(^HotViewBlock)(BOOL isShow);

@interface BBManagerGroupListViewController : BaseListViewController
//-(void)registRefreshName:(NSString *)name;

@property (nonatomic, copy) NSString *status; //0申请成员列表 1团队成员列表
@property (nonatomic, copy) NSString *teamId;

@property (nonatomic, copy) HotViewBlock hotViewShowBlock;

@property (nonatomic, copy) newBlock newBlock;


-(void)reloadData;  //团队成员刷新

@end

NS_ASSUME_NONNULL_END
