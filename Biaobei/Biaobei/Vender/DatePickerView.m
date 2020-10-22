//
//  DatePickerView.m
//  库存管理
//
//  Created by liuyang on 2017/7/12.
//  Copyright © 2017年 同牛科技. All rights reserved.
//

#import "DatePickerView.h"
@interface DatePickerView ()
@property (nonatomic, strong) NSString *selectDate;

@end

@implementation DatePickerView

+(id)datePickerView
{
    return [[self alloc] initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * toolView = [[UIView alloc]init];
        [self addSubview:toolView];
        toolView.frame = CGRectMake(0, 0, SCREENWIDTH, 42);
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(SCREENWIDTH-18-33, 10, 33, 22);
        [toolView addSubview:_sureBtn];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitleColor:SixColor forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        _cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cannelBtn.frame = CGRectMake(18, 10, 33, 22);
        [toolView addSubview:_cannelBtn];
        
        [_cannelBtn addTarget:self action:@selector(cannelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cannelBtn setTitleColor:SixColor forState:UIControlStateNormal];
        [_cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cannelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        UILabel * titleLab = [[UILabel alloc]init];
        [toolView addSubview:titleLab];
        titleLab.frame = CGRectMake((SCREENWIDTH-130)/2, 12, 130, 17);
        titleLab.text = @"选择日期";
        titleLab.font = [UIFont systemFontOfSize:17];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = BlackColor;
       
        UIView * lineView = [[UIView alloc]init];
        [self addSubview:lineView];
        lineView.frame = CGRectMake(0, 42, SCREENWIDTH, 0.5);
        lineView.backgroundColor = NineColor;
        
        
        _datePickerView = [[UIDatePicker alloc]init];
         [_datePickerView setDatePickerMode:UIDatePickerModeDate];
        _datePickerView.maximumDate = [NSDate date];
        _datePickerView.locale = [[NSLocale alloc]
                             initWithLocaleIdentifier:@"zh_CN"];
        _datePickerView.frame = CGRectMake(0, 52, SCREENWIDTH, 195);
        [self addSubview:_datePickerView];
        
        
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (NSString *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}


-(void)cannelBtnClick{
    [self.delegate cancelSelectDate];
    
    CGRect ownFrame = self.frame;
    ownFrame.origin.y = SCREENHEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = ownFrame;
    }];
}

-(void)sureBtnClick
{
    self.selectDate = [self timeFormat];
    //delegate
    [self.delegate getSelectDate:self.selectDate type:self.type];
    
    CGRect ownFrame = self.frame;
    ownFrame.origin.y = SCREENHEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = ownFrame;
    }];
}

@end
