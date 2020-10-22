//
//  BBMineStatusTaskTableViewCell.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/23.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineStatusTaskTableViewCell.h"

@implementation BBMineStatusTaskTableViewCell

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
    bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    bgView.layer.shadowOpacity = 1;
    bgView.layer.shadowRadius = 8;
    [self addSubview:bgView];
    
    //2.
    taskImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 16, 0, 0)];
    taskImgView.layer.cornerRadius = 2;
    taskImgView.contentMode = UIViewContentModeScaleAspectFill;
    taskImgView.clipsToBounds = YES;
    [bgView addSubview:taskImgView];
    
    titleLabel = [UIFactory createLab:CGRectMake(taskImgView.right+12, 16, bgView.width-taskImgView.right-20, 20) text:@"" textColor:BlackColor textFont:kFontMediumSize(16) textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:titleLabel];
    
    descLabel = [UIFactory createLab:CGRectMake(titleLabel.left, titleLabel.bottom+8, titleLabel.width, 15) text:@"" textColor:[UIColor colorWithHex:@"#9499A1"] textFont:kFontRegularSize(13) textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:descLabel];
    
    timeLabel = [UIFactory createLab:CGRectMake(descLabel.left, descLabel.bottom+10, descLabel.width, 16) text:@"" textColor:[UIColor colorWithHex:@"#9499A1"] textFont:kFontRegularSize(13) textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:timeLabel];
    
    //3.
    typeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(bgView.width-27, 0, 27, 27)];
    [bgView addSubview:typeImgView];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    //重新设置lable默认状态与默认值
    timeLabel = [UIFactory createLab:CGRectMake(descLabel.left, descLabel.bottom+10, descLabel.width, 16)
                                text:@""
                           textColor:[UIColor
                        colorWithHex:@"#9499A1"]
                            textFont:kFontRegularSize(13)
                       textAlignment:NSTextAlignmentLeft];
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

    NSString *allNum = model.total?model.total:@"0";
    NSInteger noRec = [kBBDataManager getAllSubTaskCountWithNotHaveUrlTaskID:model.task_id];
    
    //距离任务结束时间富文本显示

    CGFloat endNum = model.endtime.doubleValue;
    CGFloat sysNum = model.systemtime.doubleValue;
    CGFloat dayDouble = (endNum-sysNum)/1000/24/60/60;  //ceil(x)返回不小于x的最小整数值（然后转换为double型）

    NSInteger day = (NSInteger)ceilf(dayDouble);  //例：不足8天向上取整8天

    if (day == 0) {
        day = 1;  //不足1天显示1天，不显示0天
    }
  
    //0 未提交 1质检中 2未通过 3完成
    NSInteger status = self.status.integerValue;
    if (status == 0) {
       descLabel.text = [NSString stringWithFormat:@"总条目%@ 未录制%ld",allNum,noRec];

       if (sysNum >= endNum) {
            timeLabel.text = @"该任务已结束";
            timeLabel.textColor = [UIColor colorWithHex:@"#E23246"];
        } else {
            NSUInteger range = 0;
            if (day >= 0 && day < 10) {
                range = 1;
            } else if (day >= 10 && day < 100) {
                range = 2;
            } else if (day >= 100 && day < 1000) {
                range = 3;
            } else if (day >= 1000 && day < 10000) {
                range = 4;
            }  else if (day >= 10000 && day < 100000) {
                range = 5;
            }
            
            if (range >= 1 && range < 6) {
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距离%@任务结束还有 %ld 天", endTime, (long)day]];
                NSInteger location = attrStr.length - 2 - range;
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(location, range)];
                timeLabel.attributedText = attrStr;
            } else {
                timeLabel.text = [NSString stringWithFormat:@"距离%@任务结束还有 %ld 天",endTime,(long)day];
            }
        }
        if ([model.noPowder isEqualToString:@"1"]) {
            timeLabel.text = @"你无权访问该任务";
            timeLabel.textColor = [UIColor colorWithHex:@"#E23246"];  //Red
        }
        
    } else if (status==1){
        descLabel.text = [NSString stringWithFormat:@"总条目%@",allNum];
        timeLabel.text = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
    } else if (status==2){
        descLabel.text = [NSString stringWithFormat:@"总条目%@",allNum];
        timeLabel.text = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
    } else if (status==3){
        descLabel.text = [NSString stringWithFormat:@"总条目%@",allNum];
        timeLabel.text = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
    }
    
    
    typeImgView.image = [UIImage imageNamed:@"Home_needQuickly_english"];
    if ([model.is_express isEqualToString:@"1"]) {
        //加急
        typeImgView.hidden = NO;
        
    } else {
        typeImgView.hidden = YES;
    }
}



@end
