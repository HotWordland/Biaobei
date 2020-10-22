//
//  BBMineTipCellModel.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineTipCellModel.h"
#import "BBMineTipBeanModel.h"
@implementation BBMineTipCellModel
-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBMineTipBeanModel alloc]init];
    }
    return self;
}

-(NSString *)getCellName {
    return @"BBMineTipCollectionViewCell";
}

-(NSInteger)getNumber {
    return 4;
}

-(float)getHeight:(NSInteger)index {
    return 88;
}

-(float)getCellWidth:(NSInteger)index {
    float usualWidth = (([UIScreen mainScreen].bounds.size.width - 64) - (4 * 42))/3.0;
    if (index == 0 || index == 3) {
        return 74 + usualWidth/2.0;
    } else {
        return 42 + usualWidth;
    }
}

@end
