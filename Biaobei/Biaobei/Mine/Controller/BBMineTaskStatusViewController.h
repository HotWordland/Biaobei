//
//  BBMineTaskStatusViewController.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/23.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBMineTaskStatusViewController : BaseViewController

@property (nonatomic, copy) NSString *status; //0 未提交 1质检中 2未通过 3完成

@end

NS_ASSUME_NONNULL_END
