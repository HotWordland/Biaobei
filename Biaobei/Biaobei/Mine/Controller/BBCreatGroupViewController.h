//
//  BBCreatGroupViewController.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseListViewController.h"
#import "BBMineDetailBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBCreatGroupViewController : BaseListViewController
-(void)selctedCellWithModel:(BBMineDetailBeanModel *)model ;

@property (nonatomic, assign) BOOL isEdit; //是来编辑的
@property (nonatomic, assign) BOOL isNotPass;//未通过进来的页面

@end

NS_ASSUME_NONNULL_END
