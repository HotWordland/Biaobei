//
//  BBTaskDetailViewController.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/21.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBTaskDetailViewController : BaseViewController

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, assign) NSInteger status; 

@end

NS_ASSUME_NONNULL_END
