//
//  BBCollectPeopleChildViewController.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/7.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseListViewController.h"
#import "BBMineDetailBeanModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BBCollectPeopleChildViewController : BaseListViewController

//传过来详情数据 配置配置信息项
@property (nonatomic, strong) BBTaskDetailModel *detailModel;
@property (nonatomic, strong) NSMutableArray *configArr;

@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentArea;

@property (nonatomic, strong) BBMineDetailBeanModel * nameModel; //姓名
@property (nonatomic, strong) BBMineDetailBeanModel * sexModel;  //性别
@property (nonatomic, strong) BBMineDetailBeanModel * ageModel;  //年龄
@property (nonatomic, strong) BBMineDetailBeanModel * placeModel; //籍贯

-(void)selctedCellWithModel:(BBMineDetailBeanModel *)model ;
@end

NS_ASSUME_NONNULL_END
