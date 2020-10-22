//
//  BBGroupTranslationViewController.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBGroupTranslationViewController.h"
#import "NSString+Attribute.h"
#import "NSAttributedString+CGSize.h"

@interface BBGroupTranslationViewController () {
//    NSString * _groupTip;
//    NSString * _groupTeam;
//    NSString * _joinTime;
//    NSString * _groupName;
    
    BBGroupInfoModel *infoModel;
}

@property (nonatomic, strong) UIView * undeview;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * groupTeamLabel;
@property (nonatomic, strong) UILabel * groupTipLabel;
@property (nonatomic, strong) UIButton * cancelApplyButton;
@property (nonatomic, strong) UIView * backUnderView;
@property (nonatomic, strong) UILabel * creatTimeLabel;
@property (nonatomic, strong) UIButton * exitGroupButton;

@end

@implementation BBGroupTranslationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _groupName = @"标贝科技";
//    _groupTeam = @"团队成员：15人";
//    _groupTip = @"团队简介：成员来自五湖四海，在一起只为改变世界，感谢所有加入的小伙伴，因为有你们我们更强。";
//    _joinTime = @"加入该团队日期：2019-08-22";
    
    
    
    self.title = @"团队名称";
    [self prepareUI];
    [self layoutUI];
    [self getGroupData];
}

-(void)getGroupData{
    if (!_group_id) {
        return;
    }
    NSDictionary *params = @{
                             @"teamId":_group_id
                             };
    [[BBRequestManager sharedInstance] getTeamInfoWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        infoModel = (BBGroupInfoModel *)model;
        [self updateUI];
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];
}

-(void)updateUI{
    if (!infoModel) {
        return;
    }
    self.titleLabel.text = infoModel.teamName;
    self.title = infoModel.teamName;
    self.groupTipLabel.attributedText = [infoModel.teamProfile giveFont:kFontRegularSize(17) giveLineSpace:5 textColor:rgba(51, 57, 76, 1)];
    self.groupTipLabel.numberOfLines = 6;
    [self.groupTipLabel sizeToFit];
    
    NSString *groupCreateTime = [NSString day_timestampToString:[infoModel.createTime integerValue]];
    self.creatTimeLabel.text = [NSString stringWithFormat:@"团队创建日期: %@",groupCreateTime];
}

-(void)prepareUI {
    self.undeview = [UIView new];
    self.undeview.backgroundColor = [UIColor whiteColor];
    self.undeview.layer.masksToBounds = YES;
    self.undeview.layer.cornerRadius = 10;
    [self.view addSubview:self.undeview];

    self.titleLabel = [UILabel new];
    self.titleLabel.font = kFontMediumSize(17);
    [self.undeview addSubview:self.titleLabel];

    self.groupTeamLabel = [UILabel new];
    self.groupTeamLabel.font = kFontRegularSize(17);
    self.groupTeamLabel.textColor = rgba(148, 153, 161, 1);
    self.groupTeamLabel.textAlignment = NSTextAlignmentRight;
//    self.groupTeamLabel.text = _groupTeam;
    [self.undeview addSubview:self.groupTeamLabel];

    self.groupTipLabel = [UILabel new];
    self.groupTipLabel.font = kFontRegularSize(17);
    self.groupTipLabel.numberOfLines = 0;
    self.groupTipLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    self.groupTipLabel.attributedText = [_groupTip giveFont:kFontRegularSize(17) giveLineSpace:5 textColor:rgba(51, 57, 76, 1)];
    [self.undeview addSubview:self.groupTipLabel];

    self.cancelApplyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelApplyButton setTitle:@"取消申请" forState:UIControlStateNormal];
    [self.cancelApplyButton setTitleColor:rgba(37, 194, 155, 1) forState:UIControlStateNormal];
    self.cancelApplyButton.titleLabel.font = kFontRegularSize(18);
    self.cancelApplyButton.backgroundColor = rgba(251, 251, 255, 1);
    [self.undeview addSubview:self.cancelApplyButton];
    [self.cancelApplyButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];

    self.backUnderView = [UIView new];
    self.backUnderView.backgroundColor = rgba(251, 251, 255, 1);
    [self.undeview addSubview:self.backUnderView];

    self.creatTimeLabel = [UILabel new];
    self.creatTimeLabel.font = kFontRegularSize(16);
    self.creatTimeLabel.textColor = rgba(148, 153, 161, 1);
//    self.creatTimeLabel.text = _joinTime;
    [self.backUnderView addSubview:self.creatTimeLabel];

    self.exitGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitGroupButton setTitle:@"退出团队" forState:UIControlStateNormal];
    [self.exitGroupButton setTitleColor:rgba(208, 2, 27, 1) forState:UIControlStateNormal];
    self.exitGroupButton.titleLabel.font = kFontRegularSize(18);
    self.exitGroupButton.layer.masksToBounds = YES;
    self.exitGroupButton.layer.cornerRadius = 27;
    self.exitGroupButton.backgroundColor = [UIColor whiteColor];
    self.exitGroupButton.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.15].CGColor;
    self.exitGroupButton.layer.shadowOffset = CGSizeMake(0,15);
    self.exitGroupButton.layer.shadowOpacity = 1;
    self.exitGroupButton.layer.shadowRadius = 15;
    [self.exitGroupButton addTarget:self action:@selector(exitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitGroupButton];
    if (_isApplaying) {
        _cancelApplyButton.hidden = false;
        _backUnderView.hidden = YES;
        _exitGroupButton.hidden = YES;
        _creatTimeLabel.hidden = YES;
    } else {
        _cancelApplyButton.hidden = YES;
        _backUnderView.hidden = false;
        _exitGroupButton.hidden = false;
        _creatTimeLabel.hidden = NO;
    }
}

-(void)layoutUI {
    [self.undeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(18);
    }];

    [self.groupTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.equalTo(self.titleLabel.mas_height);
    }];

    [self.groupTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
    }];

    [self.backUnderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.groupTipLabel.mas_bottom).offset(18);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(53);
    }];

    [self.creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(18);
        make.height.mas_equalTo(16);
    }];

    [self.cancelApplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.groupTipLabel.mas_bottom).offset(18);
        make.height.mas_equalTo(53);
    }];

    [self.exitGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(54);
        make.bottom.mas_equalTo(-32);
    }];
}

-(void)cancleButtonClick {
    /*
    1 通过  2拒绝
    3移除团队 4 用户取消申请 5 用户退出团队
    */
    NSDictionary *params = @{
                              @"teamId":_group_id,
                              @"teamplayerId":kAppCacheInfo.userId
                            };
    [[BBRequestManager sharedInstance] updateTeamplayerWithStatus:@"4" params:params
      success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [self showMessage:@"取消申请成功" block:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];
}

-(void)exitButtonClick {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(exitButtonClick1) object:nil];
    [self performSelector:@selector(exitButtonClick1) withObject:nil afterDelay:0.3];
    
}

-(void)exitButtonClick1 {
    /*
     1 通过  2拒绝
     3移除团队 4 用户取消申请 5 用户退出团队
     */
    NSDictionary *params = @{
                             @"teamId":_group_id,
                             @"teamplayerId":kAppCacheInfo.userId
                             };
    [[BBRequestManager sharedInstance] updateTeamplayerWithStatus:@"5" params:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        [self showMessage:@"退出团队成功" block:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } failure:^(NSString * _Nonnull error) {
//        [self showMessage:error];
    }];
    
}

@end
