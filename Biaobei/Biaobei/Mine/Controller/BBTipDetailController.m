//
//  BBTipDetailController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBTipDetailController.h"
#import "BBTipDetailChildController.h"
@interface BBTipDetailController ()

@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, copy) NSString * remTitle;
@property (nonatomic, strong) BBTipDetailChildController * childController;

@end

@implementation BBTipDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
}

-(void)prepareUI {
    _titleLabel = [UILabel new];
    _titleLabel.font =[UIFont systemFontOfSize:36];
    _titleLabel.text = self.remTitle;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(120);
        make.top.mas_equalTo(10);
    }];

    self.childController = [[BBTipDetailChildController alloc]init];
    if ([self.remTitle isEqualToString: @"未提交"]) {
        self.childController.status = NoRefer;
    } else if ([self.remTitle isEqualToString: @"未通过"]) {
        self.childController.status = NoAccess;
    } else if ([self.remTitle isEqualToString: @"已通过"]) {
        self.childController.status = Acess;
    } else {//质检中
        self.childController.status = Checking;
    }
    [self addChildViewController:self.childController];
    [self didMoveToParentViewController:self.childController];
    [self.view addSubview:self.childController.view];
    [self.childController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

-(void)giveTitle:(NSString *)title {
    self.remTitle = title;
}

@end
