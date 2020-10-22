//
//  BBTipDetailListViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/7.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBTipDetailListViewController.h"
#import "BBTabView.h"
#import "BBHomeProjectDetailListViewController.h"

@interface BBTipDetailListViewController () {
    voiceStates _tag;
    BBTabView * _tabView;
    NSArray * _titleArray;
}
@property (nonatomic, strong) UIScrollView * listUnderView;
@property (nonatomic, strong) BBHomeProjectDetailListViewController * firstController;
@property (nonatomic, strong) BBHomeProjectDetailListViewController * secondController;

@end

@implementation BBTipDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务目录";
    
    [self prepareUI];
}

-(void)tag:(voiceStates)status {
    _tag = status;
    switch (status) {
        case NoRefer:
            _titleArray = @[@"待录制", @"已录制"];
            break;
        case NoAccess:
            break;
        case Acess:
            break;
        case Checking:
            _titleArray = @[@"未质检", @"未通过"];
            break;
        default:
            break;
    }
}

-(void)prepareUI {
    __weak typeof(BBTipDetailListViewController *) weakSelf = self;
    _tabView = [[BBTabView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 75) WithTitleArray:_titleArray];
    _tabView.tapTab = ^(NSInteger index) {
        [weakSelf slideView:index];
    };
    [self.view addSubview:_tabView];
    self.listUnderView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _tabView.frame.size.height + _tabView.frame.origin.y, SCREENWIDTH, self.view.frame.size.height - _tabView.frame.size.height - _tabView.frame.origin.y-StatusAndNaviHeight)];
    self.listUnderView.scrollEnabled = false;
    self.listUnderView.contentSize = CGSizeMake(SCREENWIDTH * 2, self.listUnderView.frame.size.height);
    [self.view addSubview:self.listUnderView];
    
    
//    NSInteger noRecCount = [kBBDataManager getAllSubTaskCountWithNotHaveUrlTaskID:_task_id];  //未录制数

    self.firstController = [[BBHomeProjectDetailListViewController alloc]init];
    self.firstController.task_id = _task_id;
    
    ////////////////////////////////////////
    if (_tag==Checking) {
        self.firstController.re_rec = YES;
    }
    ////////////////////////////////////////

    
    [self addChildViewController:self.firstController];
    
    [self didMoveToParentViewController:self.firstController];
    self.firstController.view.frame = CGRectMake(0, 0, self.listUnderView.frame.size.width, self.listUnderView.frame.size.height);
    [self.listUnderView addSubview:self.firstController.view];

//    NSInteger hasRecCount = [kBBDataManager getAllSubTaskCountWithHaveUrlTaskID:_task_id];  //已录制数


    self.secondController = [[BBHomeProjectDetailListViewController alloc]init];
    self.secondController.task_id = _task_id;
    
    ////////////////////////////////////////
    if (_tag == Checking) {
        self.secondController.re_rec = YES;
        self.secondController.no_pass = YES;  // 未通过
    } else {
        self.secondController.hasRec = YES;  //未录制 已录制
    }
    ////////////////////////////////////////
    
    [self addChildViewController:self.secondController];
    [self didMoveToParentViewController:self.secondController];
    
    CGFloat width = self.listUnderView.frame.size.width;
    CGFloat height = self.listUnderView.frame.size.height;
    self.secondController.view.frame = CGRectMake(width, 0, width, height);
    [self.listUnderView addSubview:self.secondController.view];
}

-(void)slideView:(NSInteger)index {
    [self.listUnderView setContentOffset:CGPointMake(index * self.listUnderView.frame.size.width, 0) animated:YES];
}

@end
