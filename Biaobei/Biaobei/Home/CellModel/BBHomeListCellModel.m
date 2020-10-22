//
//  BBHomeListCellModel.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeListCellModel.h"
#import "BBHomeListBeanModel.h"
@implementation BBHomeListCellModel

-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBHomeListBeanModel alloc] init];
    }
    return self;
}

-(float)getHeight:(NSInteger)index {
    return 104;
}

-(NSString *)getCellName {
    return @"BBHomeListCollectionViewCell";
}
@end
