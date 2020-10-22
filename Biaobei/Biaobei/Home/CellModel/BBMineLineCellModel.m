//
//  BBMineLineCellModel.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineLineCellModel.h"
#import "BBMineLineBeanModel.h"
@implementation BBMineLineCellModel

-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBMineLineBeanModel alloc]init];
    }
    return self;
}

-(float)getHeight:(NSInteger)index {
    return 24;
}

-(NSString *)getCellName {
    return @"BBMineLineViewCollectionViewCell";
}
@end
