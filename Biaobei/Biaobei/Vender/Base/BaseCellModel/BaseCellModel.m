//
//  BaseCellModel.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/25.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseCellModel.h"
#import <IGListKit/IGListKit.h>
@interface BaseCellModel()<IGListDiffable> {

}
@end

@implementation BaseCellModel

//子类重写，将beanModel改为自己的对应的beanModel
-(instancetype)initWithData:(id)data {
    if (self = [super init]) {
        self.beanModel = [[BaseBeanModel alloc]initWithDictionary:data error:nil];
    }
    return self;
}

//cell个数
-(NSInteger)getNumber {
    return 1;
}

//cell的size
-(CGSize)getSize:(NSInteger)index {
    return  CGSizeMake([self getCellWidth:index], [self getHeight:index]);
}

//cell宽度
-(float)getCellWidth:(NSInteger)index {
    return [UIScreen mainScreen].bounds.size.width;
}

//获取cell高度
-(float)getHeight:(NSInteger)index {
    return 0;
}

//获取cell名字，通过反射取得cell
-(NSString *)getCellName {
    return @"";
}

//点击cell
-(void)tapCell {

}

//头视图
-(UICollectionReusableView *)getSectionHeaderView {
    return  nil;
}

//头视图size
-(CGSize)getSectionHeaderViewSize {
    return CGSizeZero;
}

//底部视图
-(UICollectionReusableView *)getSectionFooterView {
    return nil;
}

//底部视图size
-(CGSize)getSectionFooterViewSize {
    return CGSizeZero;
}


- (nonnull id<NSObject>)diffIdentifier {
    return self.beanModel;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return true;
}

@end
