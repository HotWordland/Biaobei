//
//  BBHomeListBeanModel.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    Urgent = 0,
    Hot,
    New,
    end
} HomeType;


@interface BBHomeListBeanModel : BaseBeanModel
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * summary;
@property (nonatomic, strong) NSAttributedString * tipString;
@property (nonatomic, assign) HomeType type;
@end

NS_ASSUME_NONNULL_END
