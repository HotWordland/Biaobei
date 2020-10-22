//
//  BBConfigTableViewCell.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/23.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBConfigTableViewCell.h"

@implementation BBConfigTableViewCell
{
    UILabel *configLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews{
    configLabel = [UIFactory createLab:CGRectMake(0, 0, SCREENWIDTH, 50) text:@"" textColor:BlackColor textFont:kFontMediumSize(18) textAlignment:NSTextAlignmentCenter];
    [self addSubview:configLabel];
}

-(void)setConfigStr:(NSString *)configStr{
    _configStr = configStr;
    
    configLabel.text = configStr;
}

@end
