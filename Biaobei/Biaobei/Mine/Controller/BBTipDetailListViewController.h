//
//  BBTipDetailListViewController.h
//  Biaobei
//  未提交，未通过，已通过，质检中的下级页面
//  Created by 文亮 on 2019/9/7.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseListViewController.h"
#import "BBMineViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BBTipDetailListViewController : BaseListViewController

@property (nonatomic, copy) NSString *task_id;
@property (nonatomic, assign) BOOL isNoPass;  //未通过

-(void)tag:(voiceStates)status;
-(void)prepareUI;

@end

NS_ASSUME_NONNULL_END
