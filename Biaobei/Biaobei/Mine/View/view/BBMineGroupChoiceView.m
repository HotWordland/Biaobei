//
//  BBMineGroupChoiceView.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineGroupChoiceView.h"

@interface BBMineGroupChoiceView()
@property (nonatomic,strong) UIView * underView;

@end

@implementation BBMineGroupChoiceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        if (titles.count==2) {
         [self prepareUIWithTitles:titles];
        }
    }
    return self;
}

-(void)prepareUI {
    self.backgroundColor = [UIColor clearColor];
    UIView * coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer * coverTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
    [coverView addGestureRecognizer:coverTap];
    [self addSubview:coverView];
    _underView = [[UIView alloc] initWithFrame:CGRectMake(8, self.frame.size.height, self.frame.size.width - 16, 114)];
    _underView.backgroundColor = [UIColor whiteColor];
    _underView.layer.masksToBounds = YES;
    _underView.layer.cornerRadius = 12;
    [self addSubview:_underView];
    UILabel * creatGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _underView.frame.size.width, 56)];
    creatGroupLabel.textAlignment = NSTextAlignmentCenter;
    creatGroupLabel.font = [UIFont systemFontOfSize:19];
    creatGroupLabel.userInteractionEnabled = YES;
    creatGroupLabel.text = @"申请团队";
    [_underView addSubview:creatGroupLabel];
    UITapGestureRecognizer * creatGroupTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCreatGroup)];
    [creatGroupLabel addGestureRecognizer:creatGroupTap];
    UIView * lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 57, _underView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
    [_underView addSubview:lineView];
    UILabel * joinGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, _underView.frame.size.width, 57)];
    joinGroupLabel.textAlignment = NSTextAlignmentCenter;
    joinGroupLabel.font = [UIFont systemFontOfSize:19];
    joinGroupLabel.userInteractionEnabled = YES;
    joinGroupLabel.text = @"加入团队";
    UITapGestureRecognizer * joinGroupTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapJoinGroup)];
    [joinGroupLabel addGestureRecognizer:joinGroupTap];
    [_underView addSubview:joinGroupLabel];
    [UIView animateWithDuration:0.3 animations:^{
        self.underView.frame = CGRectMake(self.underView.frame.origin.x, self.frame.size.height - self.underView.frame.size.height - 32, self.underView.frame.size.width, self.underView.frame.size.height);
    }];
}

-(void)prepareUIWithTitles:(NSArray *)titles {
    self.backgroundColor = [UIColor clearColor];
    UIView * coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer * coverTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
    [coverView addGestureRecognizer:coverTap];
    [self addSubview:coverView];
    _underView = [[UIView alloc] initWithFrame:CGRectMake(8, self.frame.size.height, self.frame.size.width - 16, 114)];
    _underView.backgroundColor = [UIColor whiteColor];
    _underView.layer.masksToBounds = YES;
    _underView.layer.cornerRadius = 12;
    [self addSubview:_underView];
    UILabel * creatGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _underView.frame.size.width, 56)];
    creatGroupLabel.textAlignment = NSTextAlignmentCenter;
    creatGroupLabel.font = [UIFont systemFontOfSize:19];
    creatGroupLabel.userInteractionEnabled = YES;
    creatGroupLabel.text = titles[0];
    [_underView addSubview:creatGroupLabel];
    UITapGestureRecognizer * creatGroupTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCreatGroup)];
    [creatGroupLabel addGestureRecognizer:creatGroupTap];
    UIView * lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 57, _underView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
    [_underView addSubview:lineView];
    UILabel * joinGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, _underView.frame.size.width, 57)];
    joinGroupLabel.textAlignment = NSTextAlignmentCenter;
    joinGroupLabel.font = [UIFont systemFontOfSize:19];
    joinGroupLabel.userInteractionEnabled = YES;
    joinGroupLabel.text = titles[1];
    UITapGestureRecognizer * joinGroupTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapJoinGroup)];
    [joinGroupLabel addGestureRecognizer:joinGroupTap];
    [_underView addSubview:joinGroupLabel];
    [UIView animateWithDuration:0.3 animations:^{
        self.underView.frame = CGRectMake(self.underView.frame.origin.x, self.frame.size.height - self.underView.frame.size.height - 32, self.underView.frame.size.width, self.underView.frame.size.height);
    }];
}

-(void)tapCreatGroup {
    [UIView animateWithDuration:0.3 animations:^{
        self.underView.frame = CGRectMake(self.underView.frame.origin.x, self.frame.size.height, self.underView.frame.size.width, self.underView.frame.size.height);
    } completion:^(BOOL finished) {
        if (self.choiceGroup) {
            self.choiceGroup(CreatGroup);
        }
        [self removeSelf];
    }];
}

-(void)tapJoinGroup {
    [UIView animateWithDuration:0.3 animations:^{
        self.underView.frame = CGRectMake(self.underView.frame.origin.x, self.frame.size.height, self.underView.frame.size.width, self.underView.frame.size.height);
    } completion:^(BOOL finished) {
        if (self.choiceGroup) {
            self.choiceGroup(JoinGroup);
        }
        [self removeSelf];
    }];
}

-(void)removeSelf {
    [self removeFromSuperview];
}

@end
