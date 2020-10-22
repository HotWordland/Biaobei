//
//  BBHomeTaskTableViewCell.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/19.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBHomeTaskTableViewCell.h"

@implementation BBHomeTaskTableViewCell
{
    UIImageView *taskImgView;
    UILabel *titleLabel;
    UILabel *timeLabel;
    UILabel *descLabel;
    UIImageView *typeImgView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews{
    //1.背景
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(12, 3, SCREENWIDTH-24, 96)];
    bgView.backgroundColor = WhiteColor;
    bgView.layer.cornerRadius = 6;
    
    bgView.layer.shadowColor = [UIColor grayColor].CGColor;
//    bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
//    bgView.layer.shadowColor = [UIColor colorWithHex:@"#0A000000"].CGColor;

    //投影效果
    bgView.layer.shadowOffset = CGSizeMake(0,3);
    bgView.layer.shadowOpacity = 0.5;
    bgView.layer.shadowRadius = 4.0;
    [self addSubview:bgView];
    
//    向左偏移10 （-10，0）
//    向右偏移10 （10，0）
//    向上偏移10 （0，-10）
//    向下偏移10 （0，10）
//    阴影的颜色：imgView.layer.shadowColor = [UIColor blackColor].CGColor;
//    阴影的透明度：imgView.layer.shadowOpacity = 0.4f;
//    阴影的圆角：imgView.layer.shadowRadius = 4.0f;
//    阴影偏移量：imgView.layer.shadowOffset = CGSizeMake(0,0);//Defaults to (0, -3).
    
   
    
    //2.
    taskImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 16, 0, 0)];
    taskImgView.layer.cornerRadius = 2;
    taskImgView.contentMode = UIViewContentModeScaleAspectFill;
    taskImgView.clipsToBounds = YES;
    [bgView addSubview:taskImgView];
    
    titleLabel = [UIFactory createLab:CGRectMake(taskImgView.right+12, 16, bgView.width-taskImgView.right-20, 20) text:@"" textColor:BlackColor textFont:kFontMediumSize(16) textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:titleLabel];
    
    descLabel = [UIFactory createLab:CGRectMake(titleLabel.left, titleLabel.bottom + 8, 247, 16) text:@"" textColor:[UIColor colorWithHex:@"#9499A1"] textFont:kFontRegularSize(13) textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:descLabel];
    
    timeLabel = [UIFactory createLab:CGRectMake(descLabel.left, descLabel.bottom + 7, 247, 13) text:@"" textColor:[UIColor colorWithHex:@"#9499A1"] textFont:kFontRegularSize(13) textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:timeLabel];

    typeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(bgView.width-27, 0, 27, 27)];
    [bgView addSubview:typeImgView];
    typeImgView.image = [UIImage imageNamed:@"Home_needQuickly_english"];
}


-(void)setModel:(BBHomeTaskModel *)model{
    _model = model;
    if (!model) {
        return;
    }
    
//    UIImageView *taskImgView;
    
    titleLabel.text = model.projectName;
    
    NSString *startTime = [NSString day_timestampToString:model.starttime.integerValue];
    NSString *endTime = [NSString day_timestampToString:model.endtime.integerValue];
    timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
    
    NSString *collectType = model.collectType;
    if ([collectType isEqualToString:@"0"]) {
        descLabel.text = @"多人采集  相同文本";
    }else if ([collectType isEqualToString:@"1"]){
        descLabel.text = @"多人采集  不同文本";
    }else if ([collectType isEqualToString:@"2"]){
        descLabel.text = @"无文本采集";
    }
    if ([model.is_express isEqualToString:@"1"]) {
        //加急
        typeImgView.hidden = NO;

    }else {
        typeImgView.hidden = YES;
    }
    
    
    
}

@end
