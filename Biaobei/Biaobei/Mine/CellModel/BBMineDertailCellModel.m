//
//  MineDertailCellModel.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineDertailCellModel.h"
#import "BBMineDetailListBeanModel.h"

@implementation BBMineDertailCellModel
-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBMineDetailListBeanModel alloc]init];
    }
    return self;
}

-(float)getHeight:(NSInteger)index {
    BBMineDetailListBeanModel * model = (BBMineDetailListBeanModel *)self.beanModel;
    return model.detailArray.count * 66 + 12;
}

-(NSString *)getCellName {
    return @"BBMineDertailListCollectionViewCell";
}

@end
