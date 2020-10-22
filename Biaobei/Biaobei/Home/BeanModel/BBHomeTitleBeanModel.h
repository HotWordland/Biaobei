//
//  BBHeaderBeanModel.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBHomeTitleBeanModel : BaseBeanModel
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) int bottomDistance;
@property (nonatomic, assign) int topDistance;
@property (nonatomic, assign) int leftDistance;
@property (nonatomic, assign) int font;
@property (nonatomic, assign) int height;
@end

NS_ASSUME_NONNULL_END
