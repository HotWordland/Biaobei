//
//  PromptAlertView.m
//  FitnessCoachCenter
//
//  Created by ZhijunHu on 2019/7/4.
//  Copyright © 2019 胡志军. All rights reserved.
//

#import "PromptAlertView.h"
#import "BaseViewController.h"
CGFloat PromptAlertDefaultDelay = 1.5f;

#define rgba(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
#define rab(R,G,B) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1]

@implementation PromptAlertView
{
    NSString * _message;
}
- (instancetype)initWithMessage:(NSString *)message{
    if (self = [super init]) {
        _message = message;
        [self setUI];
        self.backgroundColor = rgba(111, 111, 111, 111);
        kViewRadius(self, 4);

    }
    return self;
}
- (void)setUI{
    CGFloat width = [_message getWidthWithFont:[UIFont systemFontOfSize:15]] + 20;
    if (width > 250) {
        width = 250;
    }
    CGFloat height = [_message getHeightWithWidth:width - 20 title:_message font:[UIFont systemFontOfSize:15]] + 15;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - 20, height)];
    [self addSubview:label];
    label.font = [UIFont systemFontOfSize:15];
    label.text = _message;
//    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = WhiteColor;
    if ([BaseViewController topViewController].navigationController.navigationBarHidden) {
        self.frame = CGRectMake(SCREENWIDTH/2 - width, SCREENHEIGHT/2 - height/2, width, height);
    }else {
          self.frame = CGRectMake(SCREENWIDTH/2 - width, SCREENHEIGHT/2 - height/2 - StatusAndNaviHeight, width, height);
    }
    
}
+ (instancetype)alertWithMessage:(NSString *)message {
  return   [self alertWithMessage:message successBlock:nil];
}
+ (instancetype)alertWithMessage:(NSString *)message successBlock:( void (^)(void))block{
    PromptAlertView * alertView = [[PromptAlertView alloc] initWithMessage:message];
    CGPoint center = CGPointMake([BaseViewController topViewController].view.center.x, [BaseViewController topViewController].view.center.y-StatusAndNaviHeight);
    alertView.center = center;
    [[BaseViewController topViewController].view addSubview:alertView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            alertView.hidden = YES;
        } completion:^(BOOL finished) {
            if (block) {
                block();
            }
            [alertView removeFromSuperview];

        }];
    });
    return alertView;
}

@end
