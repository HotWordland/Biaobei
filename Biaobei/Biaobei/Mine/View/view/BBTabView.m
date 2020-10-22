//
//  BBTabView.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBTabView.h"

@interface BBTabView()
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) UIView * tabView;
@property (nonatomic, strong) UILabel * groupTeamerLabel;
@property (nonatomic, strong) UILabel * applayLabel;
@property (nonatomic, strong) UIView * tipView;
@end

@implementation BBTabView

-(instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)titleArray {
    if (self = [super initWithFrame:frame]) {
        self.titleArray = titleArray;
        [self prepareUI];
    }
    return self;
}

-(void)prepareUI {
    self.tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 75)];
    self.tabView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tabView];

    self.groupTeamerLabel = [[UILabel alloc] initWithFrame:CGRectMake( SCREENWIDTH/2.0 - 72 - 16, 30, 72, 16)];
    self.groupTeamerLabel.text = self.titleArray[0];
    self.groupTeamerLabel.textAlignment = NSTextAlignmentCenter;
    self.groupTeamerLabel.font = kFontRegularSize(16);
    self.groupTeamerLabel.userInteractionEnabled = YES;
    self.groupTeamerLabel.textColor = rgba(37, 194, 155, 1);
    [self.tabView addSubview:self.groupTeamerLabel];
    UITapGestureRecognizer * teamTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGroupTeamButton)];
    [self.groupTeamerLabel addGestureRecognizer:teamTap];

    self.applayLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2.0 + 16, 30, 72, 16)];
    self.applayLabel.text = self.titleArray[1];
    self.applayLabel.textAlignment = NSTextAlignmentCenter;
    self.applayLabel.font = kFontRegularSize(16);
    self.applayLabel.userInteractionEnabled = YES;
    self.applayLabel.textColor = rgba(148, 153, 161, 1);
    [self.tabView addSubview:self.applayLabel];
    UITapGestureRecognizer * applyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapApplyButton)];
    [self.applayLabel addGestureRecognizer:applyTap];

    self.tipView = [[UIView alloc] initWithFrame:CGRectMake(0, self.applayLabel.frame.origin.y + self.applayLabel.frame.size.height + 8, 24, 3)];
    self.tipView.backgroundColor = rgba(37, 194, 155, 1);
    self.tipView.center = CGPointMake(self.groupTeamerLabel.center.x, self.tipView.center.y);
    [self.tabView addSubview:self.tipView];
}

-(void)tapGroupTeamButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.groupTeamerLabel.textColor = rgba(37, 194, 155, 1);
        self.applayLabel.textColor = rgba(148, 153, 161, 1);
        self.tipView.center = CGPointMake(self.groupTeamerLabel.center.x, self.tipView.center.y);
    }];
    if (self.tapTab) {
        self.tapTab(0);
    }
}

-(void)tapApplyButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.applayLabel.textColor = rgba(37, 194, 155, 1);
        self.groupTeamerLabel.textColor = rgba(148, 153, 161, 1);
        self.tipView.center = CGPointMake(self.applayLabel.center.x, self.tipView.center.y);
    }];
    if (self.tapTab) {
        self.tapTab(1);
    }
}

@end
