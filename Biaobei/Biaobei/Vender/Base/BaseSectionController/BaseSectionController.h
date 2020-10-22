//
//  BaseSectionController.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/25.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <IGListKit/IGListKit.h>
#import "BaseCellModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol BaseSectionControllerDelegate <NSObject>
-(void)didSelectItemAtSection:(NSInteger)section Indext:(NSInteger)index withModel:(BaseCellModel *)model;
@end

@interface BaseSectionController : IGListSectionController
@property (nonatomic, strong) BaseCellModel * cellModel;
@property (nonatomic, weak) id<BaseSectionControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
