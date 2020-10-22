//
//  BBMineDertailListSectionController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineDertailListSectionController.h"
#import "BBMineDertailListCollectionViewCell.h"
#import "BBMineDetailViewController.h"
#import "BBCreatGroupViewController.h"
#import "BBCollectPeopleChildViewController.h"

@implementation BBMineDertailListSectionController
-(UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    BaseCollectionViewCell * cell = [self.collectionContext dequeueReusableCellOfClass:NSClassFromString([self.cellModel getCellName]) forSectionController:self atIndex:index];
    [cell giveCellModel:self.cellModel];
    if ([cell isKindOfClass:BBMineDertailListCollectionViewCell.class]) {
        BBMineDertailListCollectionViewCell * DertailListCollectionViewCell = (BBMineDertailListCollectionViewCell *)cell;
        DertailListCollectionViewCell.tapView = ^(BBMineDetailBeanModel * _Nonnull model) {
            [self selctedCellWithModel:model];
        };
    }
    return cell;
}

-(void)selctedCellWithModel:(BBMineDetailBeanModel *)model {
    if ([self.viewController isKindOfClass:BBMineDetailViewController.class]) {
        BBMineDetailViewController * controller = (BBMineDetailViewController *)self.viewController;
        [controller selctedCellWithModel:model];
    } else if ([self.viewController isKindOfClass:BBCreatGroupViewController.class]) {
        BBCreatGroupViewController * controller = (BBCreatGroupViewController *)self.viewController;
        [controller selctedCellWithModel:model];
    } else if ([self.viewController isKindOfClass:BBCollectPeopleChildViewController.class]) {
        BBCollectPeopleChildViewController * controller = (BBCollectPeopleChildViewController *)self.viewController;
        [controller selctedCellWithModel:model];
    }
}

@end
