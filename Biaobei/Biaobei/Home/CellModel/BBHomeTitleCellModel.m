//
//  BBHomeTitleCellModel.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeTitleCellModel.h"
#import "BBHomeTitleBeanModel.h"
@implementation BBHomeTitleCellModel
-(instancetype)initWithData:(id)data {
    if (self = [super initWithData:data]) {
        self.beanModel = [[BBHomeTitleBeanModel alloc]initWithDictionary:data error:nil];
    }
    return self;
}

-(float)getHeight:(NSInteger)index {
    BBHomeTitleBeanModel * model = (BBHomeTitleBeanModel *)self.beanModel;
    return model.height;
}

- (NSString *)getCellName {
    return @"BBHomeTitleCollectionViewCell";
}
@end
