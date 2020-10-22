//
//  UnqualifiedListCollectionViewCell.h
//  Biaobei
//
//  Created by 王家辉 on 2019/11/14.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "UnqualifiedBeanModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapView)(UnqualifiedBeanModel * model);

@interface UnqualifiedListCollectionViewCell : BaseCollectionViewCell
@property(nonatomic, strong) TapView tapView;

@end

NS_ASSUME_NONNULL_END
