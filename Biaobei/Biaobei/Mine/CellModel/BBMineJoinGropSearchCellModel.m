//
//  BBMineJoinGropSearchCellModel.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineJoinGropSearchCellModel.h"
#import "BBMineJoinGropSearchBeanModel.h"
@implementation BBMineJoinGropSearchCellModel
-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBMineJoinGropSearchBeanModel alloc] initWithDictionary:data error:nil];
    }
    return self;
}

-(float)getHeight:(NSInteger)index {
    return 82;
}

-(NSString *)getCellName {
    return @"BBJoinGroupSearchCollectionViewCell";
}
@end
