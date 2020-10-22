//
//  BBMineTipBeanModel.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BBMineTipDetailBeanModel

@end

@interface BBMineTipBeanModel : BaseBeanModel
@property (nonatomic, strong) NSArray <BBMineTipDetailBeanModel> * detailModelArray;

@end

@interface BBMineTipDetailBeanModel : BaseBeanModel
@property (nonatomic, strong) NSString<Optional> * imageName;
@property (nonatomic, strong) NSString<Optional> * title;
@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) BOOL tip;
@end

NS_ASSUME_NONNULL_END
