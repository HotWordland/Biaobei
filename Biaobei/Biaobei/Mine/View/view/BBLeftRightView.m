//
//  BBLeftRightView.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/19.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBLeftRightView.h"

@implementation BBLeftRightView
{
    UILabel *leftLabel;
    UILabel *rightLabel;
}

-(instancetype)initWithFrame:(CGRect)frame leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr{
    self = [super initWithFrame:frame];
    if (self) {
        float width = frame.size.width;
        float height = frame.size.height;
        
        leftLabel = [UIFactory createLab:CGRectMake(20, 0, 100, height) text:leftStr textColor:BlackColor textFont:kFontMediumSize(17) textAlignment:NSTextAlignmentLeft];
        [self addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.bottom.mas_equalTo(self);
        }];
        
        rightLabel = [UIFactory createLab:CGRectMake(120, 0, width-140, height) text:rightStr textColor:BlackColor textFont:kFontRegularSize(16) textAlignment:NSTextAlignmentRight];
        [self addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftLabel.mas_right).offset(10);
            make.right.mas_equalTo(-20);
            make.top.bottom.mas_equalTo(self);
        }];
        
        
    }
    
    return self;
}

-(void)setLeftStr:(NSString *)leftStr{
    _leftStr = leftStr;
    leftLabel.text = leftStr;
}

-(void)setRightStr:(NSString *)rightStr{
    _rightStr = rightStr;
    rightLabel.text = rightStr;
}

@end
