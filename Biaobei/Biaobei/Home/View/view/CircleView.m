//
//  CircleView.m
//  进度条究极版
//
//  Created by 孙昊 on 16/7/12.
//  Copyright © 2016年 sunhao. All rights reserved.
//

#import "CircleView.h"
#import "UIColor+Hex.h"

#define MAS_SHORTHAND_GLOBALS
//#import "Masonry.h"//;
@interface CircleView ()
@property (nonatomic,strong) UILabel *numbLb;
@property (nonatomic,assign) CGFloat progressFlag;
@property (nonatomic,assign) NSInteger progressValue;
@property (nonatomic,strong) CAGradientLayer *grain;
@end
@implementation CircleView

- (void)circleWithProgress:(NSInteger)progress andIsAnimate:(BOOL)animate{
    if (animate) {
        _progressFlag = 0;
        _progressValue = progress;
 
        //顺时针
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2 - _strokelineWidth startAngle:M_PI * 1.5 endAngle:M_PI * 4 clockwise:YES];
    
        self.backgroundLine.path = path.CGPath;
        self.mainLine.path = path.CGPath;
        [self.grain setMask:_mainLine];  //设置渐变色
        
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnima.duration = progress/100.0f;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnima.toValue = [NSNumber numberWithFloat:progress/100.f];
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = NO;
        
        [_mainLine addAnimation:pathAnima forKey:@"strokeEndAnimation"];
        
        //进度百分比
        __weak typeof(self)weakSelf = self;
        if (progress > 0){
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                weakSelf.labelTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(NameLbChange) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] run];
            });
        }
    }
}

- (void)NameLbChange{
    __weak typeof(self)weakSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        self.numbLb.text = [self labelStytle:weakSelf.progressFlag];
    });
    
    if (_progressFlag == _progressValue) {
        [_labelTimer invalidate];
        _labelTimer = nil;
    }
    _progressFlag++;
}


-(NSString *)labelStytle:(NSInteger)value{
    NSString *pace=[NSString stringWithFormat:@"%ld%@",(long)value,@"%"];
    return pace;
}


- (UILabel *)numbLb {
    if(_numbLb == nil) {
        _numbLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _numbLb.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
        _numbLb.textAlignment = NSTextAlignmentCenter;
        int fontNum = self.bounds.size.width/6;
        _numbLb.font = [UIFont boldSystemFontOfSize:fontNum + 2 ];
        _numbLb.text = @"0";
        //        _numbLb.backgroundColor = [UIColor redColor];
        [self addSubview:_numbLb];
    }
    return _numbLb;
}
- (CAShapeLayer *)backgroundLine {
    if(_backgroundLine == nil) {
        _backgroundLine = [[CAShapeLayer alloc] init];
        _backgroundLine.fillColor = [UIColor clearColor].CGColor;
        _backgroundLine.strokeColor = [UIColor lightGrayColor].CGColor;
        _backgroundLine.lineWidth = _strokelineWidth;
        [self.layer addSublayer:_backgroundLine];
    }
    return _backgroundLine;
}

//设置渐变色的圆环
- (CAShapeLayer *)mainLine {
    if(_mainLine == nil) {
        _mainLine = [[CAShapeLayer alloc] init];
        _mainLine.fillColor = [UIColor clearColor].CGColor;
        _mainLine.strokeColor = [UIColor redColor].CGColor;
        _mainLine.lineWidth = _strokelineWidth;
        [self.layer addSublayer:_mainLine];

    }
    return _mainLine;
}


//设置渐变颜色 -  #FF6800FF  #FF25C29B
- (CAGradientLayer *)grain {
    if(_grain == nil) {
        _grain = [[CAGradientLayer alloc] init];
        _grain.frame = CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height);
        id color1 = (id)[[UIColor colorWithHex:@"f31414"] CGColor];
        id color2 = (id)[[UIColor colorWithHex:@"f27200"] CGColor];
        id color3 = (id)[[UIColor colorWithHex:@"ffff00"] CGColor];
        id color4 = (id)[[UIColor colorWithHex:@"2bee22"] CGColor];
        id color5 = (id)[[UIColor colorWithHex:@"32a7eb"] CGColor];

        [_grain setColors:[NSArray arrayWithObjects:color1, color2, color3, color4, color5, nil]];
        [_grain setLocations:@[@0, @0.3, @0.7, @1]];
        [_grain setStartPoint:CGPointMake(0, 0)];
        [_grain setEndPoint:CGPointMake(1, 0)];
        _grain.type = kCAGradientLayerAxial;
        [self.layer addSublayer:_grain];
    }
    return _grain;
}


@end
