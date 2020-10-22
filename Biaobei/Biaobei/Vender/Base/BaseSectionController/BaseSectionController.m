//
//  BaseSectionController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/25.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseSectionController.h"
#import "BaseCollectionViewCell.h"
#import <IGListKit/IGListKit.h>
@interface BaseSectionController()<IGListSupplementaryViewSource> {

}
@end

//这个就类似tableview的一个section
@implementation BaseSectionController

-(void)didUpdateToObject:(id)object {
    self.cellModel = (BaseCellModel *)object;
    if ([self.cellModel getSectionHeaderView] || [self.cellModel getSectionFooterView]) {
        self.supplementaryViewSource = self;
    }
}

-(NSInteger)numberOfItems {
    return [self.cellModel getNumber];
}

-(CGSize)sizeForItemAtIndex:(NSInteger)index {
    return [self.cellModel getSize:index];
}

-(UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    BaseCollectionViewCell * cell = [self.collectionContext dequeueReusableCellOfClass:NSClassFromString([self.cellModel getCellName]) forSectionController:self atIndex:index];
    [cell giveCellModel:self.cellModel];
    return cell;
}

-(void)didSelectItemAtIndex:(NSInteger)index {
    [self.cellModel tapCell];
    if ([self.delegate respondsToSelector: @selector(didSelectItemAtSection:Indext:withModel:)]) {
        [self.delegate didSelectItemAtSection:self.section Indext:index withModel:self.cellModel];
    }
}

-(NSArray<NSString *> *)supportedElementKinds {
    NSMutableArray * array = [[NSMutableArray alloc]init];
    if ([self.cellModel getSectionHeaderView]) {
        [array addObject:UICollectionElementKindSectionHeader];
    }

    if ([self.cellModel getSectionFooterView]) {
        [array addObject:UICollectionElementKindSectionFooter];
    }

    return array;
}

-(UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)elementKind atIndex:(NSInteger)index {

    if ([elementKind isEqual:UICollectionElementKindSectionHeader]) {
        return [self.cellModel getSectionHeaderView];
    } else if ( [elementKind isEqual:UICollectionElementKindSectionFooter]) {
        return [self.cellModel getSectionFooterView];
    }
    return nil;
}

- (CGSize)sizeForSupplementaryViewOfKind:(nonnull NSString *)elementKind atIndex:(NSInteger)index {
    if ([elementKind isEqual:UICollectionElementKindSectionHeader]) {
        return [self.cellModel getSectionHeaderViewSize];
    } else if ( [elementKind isEqual:UICollectionElementKindSectionFooter]) {
        return [self.cellModel getSectionFooterViewSize];
    }
    return CGSizeZero;
}


@end
