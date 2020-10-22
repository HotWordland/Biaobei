//
//  BBTabView.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapTab)(NSInteger index);
@interface BBTabView : UIView
@property (nonatomic, copy) TapTab tapTab;
-(instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)titleArray;
@end

NS_ASSUME_NONNULL_END
