//
//  UnqualifiedListCollectionViewCell.m
//  Biaobei
//
//  Created by 王家辉 on 2019/11/14.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "UnqualifiedListCollectionViewCell.h"
#import "UnqualifiedListBeanModel.h"
#import "UnqualifiedView.h"

@interface UnqualifiedListCollectionViewCell ()
@property (nonatomic, strong) UIView * underView;
@end

@implementation UnqualifiedListCollectionViewCell

-(void)prepareUI {
    self.underView = [UIView new];
    self.underView.backgroundColor = [UIColor whiteColor];
    self.underView.layer.masksToBounds = YES;
    self.underView.layer.cornerRadius = 8;
    self.underView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    self.underView.layer.shadowOffset = CGSizeMake(0,0);
    self.underView.layer.shadowOpacity = 1;
    self.underView.layer.shadowRadius = 8;
    [self.contentView addSubview:self.underView];
}

-(void)layoutUI {
    [self.underView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(6);
        make.bottom.mas_equalTo(-6);
    }];
}

-(void)updateUI {
    for (UIView * view in self.underView.subviews) {
        [view removeFromSuperview];
    }
    UnqualifiedListBeanModel * beanModel = (UnqualifiedListBeanModel *)self.beanModel;
    UnqualifiedView * detailview = nil;
    for (int i =0; i< beanModel.detailArray.count; i++) {
        UnqualifiedView * view = [[UnqualifiedView alloc]init];
        view.userInteractionEnabled = YES;
        view.tag = 100 + i;
        UnqualifiedBeanModel *detailBeanModel = beanModel.detailArray[i];
        view.model = detailBeanModel;
        [_underView addSubview:view];
        if (detailview) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.equalTo(detailview.mas_bottom);
                make.height.equalTo(detailview.mas_height);
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(0);
                make.height.mas_equalTo(66);
            }];
        }
        detailview = view;
        if (detailBeanModel.noTap) {//不要手势，直接走代理

        } else {
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCellWtihModel:)];
            [detailview addGestureRecognizer:tap];
        }
    }
}

-(void)tapCellWtihModel:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 100;
    UnqualifiedListBeanModel * beanModel = (UnqualifiedListBeanModel *)self.beanModel;
    UnqualifiedBeanModel * model = beanModel.detailArray[index];
    if (self.tapView) {
        self.tapView(model);
    }
}

@end
