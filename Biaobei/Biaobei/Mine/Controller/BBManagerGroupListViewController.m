//
//  BBManagerGroupListViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBManagerGroupListViewController.h"
#import "BBManagerGroupteamerCellModel.h"
#import "BBManagerGroupteamerBeanModel.h"

@interface BBManagerGroupListViewController () {
    int loadDataCount;
}

@end

@implementation BBManagerGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareData];
    [self getListData];
    
    [self addObserver];
}

-(void)reloadData{
    loadDataCount = 0;
    [self getListData];
}

-(void)addObserver {
    if ([_status isEqualToString:@"0"]) {//申请
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refused:) name:@"refused" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(access:) name:@"access" object:nil];
    }else{//管理移除
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remove:) name:@"remove" object:nil];
    }
}

//移除成员
-(void)remove:(NSNotification *)notifacation{
    BBManagerGroupteamerBeanModel * beanModel = notifacation.object;
    
    NSDictionary *params = @{
                              @"teamId":_teamId,
                              @"teamplayerId":beanModel.teamplayerId
                            };
    [SVProgressHUD showWithStatus:@"请求中..."];
    [[BBRequestManager sharedInstance] updateTeamplayerWithStatus:@"3" params:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [SVProgressHUD dismiss];


        int index = beanModel.index.intValue;
        if (self.dataListArray && self.dataListArray > 0) {
            if (index == 0) {
                [self.dataListArray removeObjectAtIndex:index];
            } else {
                [self.dataListArray removeObjectAtIndex:index - 1];
            }
        }
        
        [self refresh];
        [self showMessage:@"移除成功"];
    } failure:^(NSString * _Nonnull error) {
        [self showMessage:@"移除失败"];
    }];
}

/* 拒绝申请 */
-(void)refused:(NSNotification *)notifacation{
    BBManagerGroupteamerBeanModel * beanModel = notifacation.object;
    
    NSDictionary *params = @{
                             @"teamId":_teamId,
                             @"teamplayerId":beanModel.teamplayerId
                             };
    [SVProgressHUD showWithStatus:@"请求中..."];
    [[BBRequestManager sharedInstance] updateTeamplayerWithStatus:@"2" params:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [SVProgressHUD dismiss];

        int index = beanModel.index.intValue;
        if (self.dataListArray && self.dataListArray > 0 ) {
            if (index == 0) {
                [self.dataListArray removeObjectAtIndex:index];
            } else {
                [self.dataListArray removeObjectAtIndex:index - 1];
            }
        }
        [self refresh];
        
        //申请成员列表为空，红点隐藏
        if (self.dataListArray.count == 0) {
            if (self.newBlock) {
                self.newBlock(NO);
            }
        }
        
        [self showMessage:@"拒绝成功"];
    } failure:^(NSString * _Nonnull error) {
        [self showMessage:@"拒绝失败"];
    }];
}

/* 通过 - 同意申请 */
-(void)access:(NSNotification *)notifacation {
    BBManagerGroupteamerBeanModel * beanModel = notifacation.object;
    
    NSDictionary *params = @{ @"teamId":_teamId,
                              @"teamplayerId":beanModel.teamplayerId
                            };
    [SVProgressHUD showWithStatus:@"请求中..."];
    [[BBRequestManager sharedInstance] updateTeamplayerWithStatus:@"1" params:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [SVProgressHUD dismiss];

        int index = beanModel.index.intValue;
        if (self.dataListArray && self.dataListArray > 0 ) {
            if (index == 0) {
                [self.dataListArray removeObjectAtIndex:index];
            } else {
                [self.dataListArray removeObjectAtIndex:index - 1];
            }
        }
        [self refresh];
        
        //申请成员列表为空，红点隐藏
        if (self.dataListArray.count == 0) {
            if (self.newBlock) {
                self.newBlock(NO);
            }
        }
        
        [self showMessage:@"通过成功"];
    } failure:^(NSString * _Nonnull error) {
        [self showMessage:@"通过失败"];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.initList) {
        self.initList = YES;
        [self refresh];
    }
}

-(void)getListData{
    loadDataCount++;
    if (loadDataCount==1) {
        [self.dataListArray removeAllObjects];
    }
    
    NSString *pageNum = [NSString stringWithFormat:@"%d",loadDataCount];
    NSDictionary *params = @{
                             @"pageNum":pageNum,
                             @"pageSize":@"10",
                             @"teamId":_teamId
                             };
    [[BBRequestManager sharedInstance] getTeamPlayerListWithStatus:_status params:params success:^(id  _Nonnull responseObject, JSONModel *model) {
        
        //xcode异常
        NSDictionary *dataDic = responseObject[@"data"];
        BBGroupTeamerModel *groupTeamerModel = [[BBGroupTeamerModel alloc]initWithDictionary:dataDic error:nil];
        
//        BBGroupTeamerModel *groupTeamerModel = (BBGroupTeamerModel *)model;  //model = nil  异常
        
        BOOL hasNextPage = groupTeamerModel.hasNextPage;
        
        NSArray *list = [groupTeamerModel.list copy];
        
        if (list.count > 0) {
            if (self.newBlock) {
                self.newBlock(YES);
            }
        } else {
            if (self.newBlock) {
                self.newBlock(NO);
            }
        }
        
        for (int i=0; i<list.count; i++) {
            BBTeamerInfoModel *teamerInfoModel = list[i];
            BOOL isMember = YES;
            if ([_status isEqualToString:@"0"]) {//申请成员
                isMember = NO;
            }
            NSString *headerUrl = @"";
            if (teamerInfoModel.icon) {
                headerUrl = teamerInfoModel.icon;
            }
            NSDictionary *dataDic = @{
                                      @"headerUrl":headerUrl,
                                      @"name":teamerInfoModel.realName ? teamerInfoModel.realName : @"",
                                      @"phonoNumer":teamerInfoModel.mobile,
                                      @"isMember":@(isMember),
                                      @"index":[NSString stringWithFormat:@"%d",i],
                                      @"teamplayerId":teamerInfoModel.user_id,
                                      @"sex":teamerInfoModel.sex
                                      };
            BBManagerGroupteamerCellModel *teamerCellModel = [[BBManagerGroupteamerCellModel alloc]initWithData:dataDic];
            [self.dataListArray addObject:teamerCellModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refresh];
            
    
            
            [self closePullToRefreshView];
            [self closeLoadMoreRefreshView];
            if (!hasNextPage) {
                [self endRefreshingWithNoMoreData];
            }
        });
        
    } failure:^(NSString * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self closePullToRefreshView];
            [self closeLoadMoreRefreshView];
        });
//        [self showMessage:error];
    }];
}

-(void)insertRowAtTop{
    loadDataCount = 0;
    [self getListData];
}

-(void)insertRowAtBottom{
    [self getListData];
}

-(void)prepareData {
//    BBManagerGroupteamerCellModel * momoCellModel = [[BBManagerGroupteamerCellModel alloc]initWithData:@{@"headerUrl": @"", @"name": @"Momo", @"phonoNumer": @"18310859212", @"isMember": @(YES)}];
//                                                                                                         [self.dataListArray addObject:momoCellModel];
//    BBManagerGroupteamerCellModel * zhaosiCellModel = [[BBManagerGroupteamerCellModel alloc]initWithData:@{@"headerUrl": @"", @"name": @"赵四", @"phonoNumer": @"18310859212", @"isMember": @(NO)}];
//    [self.dataListArray addObject:zhaosiCellModel];
}

//-(void)registRefreshName:(NSString *)name {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:name object:nil];
//}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
