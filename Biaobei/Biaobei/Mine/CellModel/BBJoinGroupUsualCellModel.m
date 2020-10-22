//
//  BBJoinGroupUsualCellModel.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBJoinGroupUsualCellModel.h"
#import "BBMineDetailListBeanModel.h"

@implementation BBJoinGroupUsualCellModel
-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBMineDetailListBeanModel alloc]init];
    }
    return self;
}

-(float)getHeight:(NSInteger)index {
    return 280;
}

-(NSString *)getCellName {
    return @"BBJoinGroupUsualCollectionViewCell";
}
@end
