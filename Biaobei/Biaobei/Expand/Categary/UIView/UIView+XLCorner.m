//
//  UIView+XLCorner.m
//  Basetnt
//
//  Created by 文亮 on 2019/7/26.
//  Copyright © 2019 sgq. All rights reserved.
//

#import "UIView+XLCorner.h"

@implementation UIView (XLCorner)
-(UIView *)makeCorner:(float)corner {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:corner];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    self.layer.mask = layer;
    return self;
}
@end
