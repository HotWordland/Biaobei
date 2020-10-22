//
//  UnqualifiedCellModel.m
//  Biaobei
//
//  Created by 王家辉 on 2019/11/14.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "UnqualifiedCellModel.h"
#import "UnqualifiedListBeanModel.h"

@implementation UnqualifiedCellModel

-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[UnqualifiedListBeanModel alloc] init];
    }
    return self;
}

-(float)getHeight:(NSInteger)index {
    UnqualifiedListBeanModel * model = (UnqualifiedListBeanModel *)self.beanModel;
    return  model.detailArray.count * 66 + 12;
}

-(NSString *)getCellName {
    return @"UnqualifiedListCollectionViewCell";
}

@end
