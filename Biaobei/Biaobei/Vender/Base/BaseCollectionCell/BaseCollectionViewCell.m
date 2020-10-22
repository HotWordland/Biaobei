//
//  BaseCollectionViewCell.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/25.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@interface BaseCollectionViewCell()

@end

@implementation BaseCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        [self layoutUI];
    }
    return self;
}

-(void)prepareUI {

}

-(void)layoutUI {

}

-(void)updateUI {

}

-(void)giveCellModel:(BaseCellModel *)model {
    _cellModel = model;
    _beanModel = model.beanModel;
    [self updateUI];
}
@end
