//
//  BBMineStatusTaskTableViewCell.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/23.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBMineStatusTaskTableViewCell : UITableViewCell

@property (nonatomic, strong) BBHomeTaskModel *model;

@property (nonatomic, copy) NSString *status; //0 未提交 1质检中 2未通过 3完成

@end

NS_ASSUME_NONNULL_END
