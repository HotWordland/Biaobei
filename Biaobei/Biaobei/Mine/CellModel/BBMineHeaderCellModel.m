//
//  BBMineHeaderCellModel.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineHeaderCellModel.h"
#import "BBMineHeaderBeanModel.h"
@implementation BBMineHeaderCellModel
-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBMineHeaderBeanModel alloc] init];
    }
    return self;
}

-(NSString *)getCellName {
    return @"BBMineHeaderCollectionViewCell";
}

-(float)getHeight:(NSInteger)index {
    return 108;
}
@end
