//
//  BBManagerGroupteamerCellModel.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBManagerGroupteamerCellModel.h"
#import "BBManagerGroupteamerBeanModel.h"

@implementation BBManagerGroupteamerCellModel

-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBManagerGroupteamerBeanModel alloc]initWithDictionary:data error:nil];
    }
    return self;
}

-(float)getHeight:(NSInteger)index {
    return 78;
}

-(NSString *)getCellName {
    return @"BBManagerGroupTeamerCollectionCell";
}
@end
