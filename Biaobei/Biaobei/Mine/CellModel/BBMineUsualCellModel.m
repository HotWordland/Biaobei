//
//  BBMineUsualCellModel.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineUsualCellModel.h"
#import "BBMineUsualBeanModel.h"
@implementation BBMineUsualCellModel
-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBMineUsualBeanModel alloc]initWithDictionary:data error:nil];
    }
    return self;
}

-(NSString *)getCellName {
    return @"BBMineUsualCollectionViewCell";
}

-(float)getHeight:(NSInteger)index {
    return 67;
}
@end
