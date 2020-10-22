//
//  BBMineGroupChoiceView.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    CreatGroup = 0,
    JoinGroup
} ChoiceGroupType;


typedef void(^ChoiceGroup)(ChoiceGroupType type);

@interface BBMineGroupChoiceView : UIView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@property (nonatomic, strong) ChoiceGroup choiceGroup;  //0 和1  目前这个也只给2个选项
@end

NS_ASSUME_NONNULL_END
