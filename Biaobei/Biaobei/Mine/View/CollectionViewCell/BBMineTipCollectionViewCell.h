//
//  BBMineTipCollectionViewCell.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBMineTipCollectionViewCell : BaseCollectionViewCell
-(void)giveCellModel:(BaseCellModel *)model withBeanModel:(BaseBeanModel *)beanModel;
@end

NS_ASSUME_NONNULL_END
