//
//  BBMineApplyPeopleView.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ChangeButtonClick)(void);
typedef void(^SureButtonClick)(void);

@interface BBMineApplyPeopleView : UIView
@property (nonatomic, copy) ChangeButtonClick change;
@property (nonatomic, copy) SureButtonClick sure;

@end

NS_ASSUME_NONNULL_END
