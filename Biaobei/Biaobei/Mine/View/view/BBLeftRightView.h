//
//  BBLeftRightView.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/19.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBLeftRightView : UIView

-(instancetype)initWithFrame:(CGRect)frame leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr;

@property (nonatomic, copy)NSString *leftStr;
@property (nonatomic, copy)NSString *rightStr;

@end

NS_ASSUME_NONNULL_END
