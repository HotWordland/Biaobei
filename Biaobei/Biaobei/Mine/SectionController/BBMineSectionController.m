//
//  BBMineSectionController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineSectionController.h"
#import "BBMineTipCollectionViewCell.h"
#import "BBMineTipCellModel.h"
#import "BBMineTipBeanModel.h"

@implementation BBMineSectionController
-(UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    if (self.section == 1) {
        BBMineTipCollectionViewCell * cell = (BBMineTipCollectionViewCell *)[self.collectionContext dequeueReusableCellOfClass:NSClassFromString([self.cellModel getCellName]) forSectionController:self atIndex:index];
        BBMineTipCellModel * cellModel = (BBMineTipCellModel *)self.cellModel;
        BBMineTipBeanModel * beanModel = (BBMineTipBeanModel *)cellModel.beanModel ;
        [cell giveCellModel:self.cellModel withBeanModel:beanModel.detailModelArray[index]];
        return cell;
    }
    return [super cellForItemAtIndex:index];

}
@end
