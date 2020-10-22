//
//  BBManagerGroupViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBManagerGroupViewController.h"
#import "BBManagerGroupListViewController.h"
#import "BBCreatGroupViewController.h"

@interface BBManagerGroupViewController ()
@property (nonatomic, strong) UIScrollView * listUnderView;
@property (nonatomic, strong) UIView * tabView;
@property (nonatomic, strong) UILabel * groupTeamerLabel;
@property (nonatomic, strong) UILabel * applayLabel;
@property (nonatomic, strong) UIView * redView;  //红点
@property (nonatomic, strong) UIView * tipView;
@property (nonatomic, strong) BBManagerGroupListViewController * groupTeamController;
@property (nonatomic, strong) BBManagerGroupListViewController * applyListController;
@end

@implementation BBManagerGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //团队名称
    if(self.teamName.length > 10) {
        NSString *subStr = [self.teamName substringToIndex:10];
        self.title = [subStr stringByAppendingString:@"..."];
    }
    self.title = self.teamName;
    [self prepareUI];
}

-(void)setRightNavigationbar {
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 88, 30);
    [rightButton setTitle:@"编辑信息" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(editInfo) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:rgba(37, 194, 155, 1) forState:UIControlStateNormal];
    rightButton.titleLabel.font = kFontRegularSize(17);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)prepareUI {
    self.tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 75)];
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tabView];

    self.groupTeamerLabel = [[UILabel alloc] initWithFrame:CGRectMake( SCREENWIDTH/2.0 - 72 - 16, 30, 72, 16)];
    self.groupTeamerLabel.text = @"团队成员";
    self.groupTeamerLabel.textAlignment = NSTextAlignmentCenter;
    self.groupTeamerLabel.font = kFontRegularSize(16);
    self.groupTeamerLabel.userInteractionEnabled = YES;
    self.groupTeamerLabel.textColor = rgba(37, 194, 155, 1);
    [self.tabView addSubview:self.groupTeamerLabel];
    UITapGestureRecognizer * teamTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGroupTeamButton)];
    [self.groupTeamerLabel addGestureRecognizer:teamTap];

    self.applayLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2.0 + 16, 30, 72, 16)];
    self.applayLabel.text = @"申请成员";
    self.applayLabel.textAlignment = NSTextAlignmentCenter;
    self.applayLabel.font = kFontRegularSize(16);
    self.applayLabel.userInteractionEnabled = YES;
    self.applayLabel.textColor = rgba(148, 153, 161, 1);
    
    //添加红点提示 成员加入
    CGPoint origin = _applayLabel.frame.origin;
    CGFloat w = _applayLabel.frame.size.width;
    CGRect redRect = CGRectMake(origin.x + w, origin.y - 4, 8, 8);
    _redView = [[UIView alloc] initWithFrame:redRect];
    _redView.backgroundColor = [UIColor redColor];
    _redView.layer.masksToBounds = YES;
    _redView.layer.cornerRadius = 4;
    _redView.hidden = YES;
    [self.tabView addSubview:_redView];
    

    [self.tabView addSubview:self.applayLabel];
    UITapGestureRecognizer * applyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapApplyButton)];
    [self.applayLabel addGestureRecognizer:applyTap];

    self.tipView = [[UIView alloc] initWithFrame:CGRectMake(0, self.applayLabel.frame.origin.y + self.applayLabel.frame.size.height + 8, 24, 3)];
    self.tipView.backgroundColor = rgba(37, 194, 155, 1);
    self.tipView.center = CGPointMake(self.groupTeamerLabel.center.x, self.tipView.center.y);
    [self.tabView addSubview:self.tipView];

    self.listUnderView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.tabView.frame.size.height + self.tabView.frame.origin.y, SCREENWIDTH, self.view.frame.size.height - self.tabView.frame.size.height - self.tabView.frame.origin.y)];
    self.listUnderView.scrollEnabled = false;
    self.listUnderView.contentSize = CGSizeMake(SCREENWIDTH * 2, self.listUnderView.frame.size.height);
    [self.view addSubview:self.listUnderView];
    
    
    self.groupTeamController = [[BBManagerGroupListViewController alloc]init];
    self.groupTeamController.teamId = _teamId;
    self.groupTeamController.status = @"1";  //团队成员列表
    [self addChildViewController:self.groupTeamController];
    [self didMoveToParentViewController:self.groupTeamController];
    self.groupTeamController.view.frame = CGRectMake(0, 0, self.listUnderView.frame.size.width, self.listUnderView.frame.size.height);
//    [self.groupTeamController registRefreshName:@"remove"];
    [self.listUnderView addSubview:self.groupTeamController.view];

    self.applyListController = [[BBManagerGroupListViewController alloc]init];
    
    //有新成员时显示红点
    __weak typeof(self)weakSelf = self;
    self.applyListController.newBlock = ^(BOOL have){
        if (have) {
            weakSelf.redView.hidden = NO;
        } else {
            weakSelf.redView.hidden = YES;
        }
    };
    
    self.applyListController.teamId = _teamId;
    self.applyListController.status = @"0";  //申请成员列表
//    [self.applyListController registRefreshName:@"refused"];
//    [self.applyListController registRefreshName:@"access"];
    [self addChildViewController:self.applyListController];
    [self didMoveToParentViewController:self.applyListController];
    self.applyListController.view.frame = CGRectMake(self.listUnderView.frame.size.width, 0, self.listUnderView.frame.size.width, self.listUnderView.frame.size.height);
    [self.listUnderView addSubview:self.applyListController.view];
}

-(void)editInfo {
    BBCreatGroupViewController * groupViewController =[[BBCreatGroupViewController alloc]init];
    groupViewController.isEdit = YES;
    [self.navigationController pushViewController:groupViewController animated:YES];
}

-(void)tapGroupTeamButton {
    [self.groupTeamController reloadData]; //刷新数据
    
    [self.listUnderView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.groupTeamerLabel.textColor = rgba(37, 194, 155, 1);
        self.applayLabel.textColor = rgba(148, 153, 161, 1);
        self.tipView.center = CGPointMake(self.groupTeamerLabel.center.x, self.tipView.center.y);
    }];
}

-(void)tapApplyButton {
    [self.applyListController reloadData];
    
    [self.listUnderView setContentOffset:CGPointMake(self.listUnderView.frame.size.width, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.applayLabel.textColor = rgba(37, 194, 155, 1);
        self.groupTeamerLabel.textColor = rgba(148, 153, 161, 1);
        self.tipView.center = CGPointMake(self.applayLabel.center.x, self.tipView.center.y);
    }];
}

@end
