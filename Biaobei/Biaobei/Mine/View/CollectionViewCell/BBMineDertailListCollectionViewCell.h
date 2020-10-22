//
//  BBMineDertailListCollectionViewCell.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "BBMineDetailBeanModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapView)(BBMineDetailBeanModel * model);

@interface BBMineDertailListCollectionViewCell : BaseCollectionViewCell
@property(nonatomic, strong) TapView tapView;
@end

NS_ASSUME_NONNULL_END
