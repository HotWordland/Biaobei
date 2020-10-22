//
//  BBHomeProjectDetailListViewController.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/7.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBHomeProjectDetailListViewController : BaseListViewController

@property (nonatomic, copy) NSString *task_id;
@property (nonatomic, assign) BOOL hasRec;  //有录音


@property (nonatomic, assign) BOOL re_rec; //是否可以重录，yes代表未通过未质检
@property (nonatomic, assign) BOOL no_pass; //未通过  另一个则是未质检

@end

NS_ASSUME_NONNULL_END
