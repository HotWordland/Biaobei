//
//  BBHomeBannerCellModel.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeBannerCellModel.h"
#import "BBHomeBannerBeanModel.h"

@implementation BBHomeBannerCellModel
-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBHomeBannerBeanModel alloc]initWithDictionary:data error:nil];
    }
    return self;
}

-(float)getHeight:(NSInteger)index {
    return 164;
}

-(NSString *)getCellName {
    return @"BBBanerCollectionViewCell";
}

@end
