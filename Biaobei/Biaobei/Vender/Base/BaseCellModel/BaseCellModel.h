//
//  BaseCellModel.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/8/25.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseBeanModel.h"
#import <UIKit/UIKit.h>


@interface BaseCellModel : NSObject
@property(nonatomic,strong) BaseBeanModel * beanModel;

//初始化，带着beanModel的数据
-(instancetype)initWithData:(id)data;

//获取行高
-(float)getHeight:(NSInteger)index;

//获取行宽
-(float)getCellWidth:(NSInteger)index;

//获取Cell名字
-(NSString *)getCellName;

//点击事件
-(void)tapCell;

//获取个数
-(NSInteger)getNumber;

//获取size
-(CGSize)getSize:(NSInteger)index;

//头视图
-(UICollectionReusableView *)getSectionHeaderView;

//头视图size
-(CGSize)getSectionHeaderViewSize;

//底部视图
-(UICollectionReusableView *)getSectionFooterView;

//底部视图size
-(CGSize)getSectionFooterViewSize;


@end

