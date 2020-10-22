//
//  BBMineDetailViewController.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseListViewController.h"
#import "BBMineDetailBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBMineDetailViewController : BaseListViewController

@property (nonatomic, strong) BBUserInfoModel *userInfoModel;

-(void)isRegist;
-(void)selctedCellWithModel:(BBMineDetailBeanModel *)model ;
@end

NS_ASSUME_NONNULL_END
