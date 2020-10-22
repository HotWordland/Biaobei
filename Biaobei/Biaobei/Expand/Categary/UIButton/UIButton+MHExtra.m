//
//  UIButton+MHExtra.m
//  FitnessCoachCenter
//
//  Created by zhrt on 2019/7/6.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import "UIButton+MHExtra.h"
#import <objc/runtime.h>
/**
 *  @brief add action callback to uibutton
 */
@interface UIButton (MHAddCallBackBlock)

- (void)setMHCallBack:(MHButtonActionCallBack)callBack;
- (MHButtonActionCallBack)getMHCallBack;

@end

@implementation UIButton (MHAddCallBackBlock)

static MHButtonActionCallBack _callBack;

- (void)setMHCallBack:(MHButtonActionCallBack)callBack {
    objc_setAssociatedObject(self, &_callBack, callBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MHButtonActionCallBack)getMHCallBack {
    return (MHButtonActionCallBack)objc_getAssociatedObject(self, &_callBack);
}

@end;

@implementation UIButton (MHExtra)
/**
 *  @brief replace the method 'addTarget:forControlEvents:UIControlEventTouchUpInside'
 *  the property 'alpha' being 0.5 while 'UIControlEventTouchUpInside'
 */
- (void)addMHClickAction:(MHButtonActionCallBack)callBack {
    [self addMHCallBackAction:callBack forControlEvents:(UIControlEventTouchUpInside)];
//    [self addTarget:self action:@selector(mhTouchDownAction:) forControlEvents:(UIControlEventTouchDown)];
    [self addTarget:self action:@selector(mhTouchUpAction:) forControlEvents:UIControlEventTouchUpInside ];
}

/**
 *  @brief replace the method 'addTarget:forControlEvents:'
 */
- (void)addMHCallBackAction:(MHButtonActionCallBack)callBack forControlEvents:(UIControlEvents)controlEvents{
    [self setMHCallBack:callBack];
    [self addTarget:self action:@selector(mhButtonAction:) forControlEvents:controlEvents];
}

- (void)mhButtonAction:(UIButton *)btn {
    self.getMHCallBack(btn);
}

- (void)mhTouchDownAction:(UIButton *)btn {
    btn.enabled = YES;
    btn.alpha = 1.0;
}

- (void)mhTouchUpAction:(UIButton *)btn {
    btn.enabled = YES;
    btn.alpha = 1.0f;
}
@end
