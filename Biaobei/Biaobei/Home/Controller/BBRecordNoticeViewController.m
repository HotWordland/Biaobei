//
//  BBRecordNoticeViewController.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/21.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBRecordNoticeViewController.h"
#import <WebKit/WebKit.h>
#import "NKAVPlayerView.h"
#import "AppDelegate.h"
@interface BBRecordNoticeViewController ()
@property (nonatomic, strong)NKAVPlayerView *playerView;
@end

@implementation BBRecordNoticeViewController
{
    UIScrollView *bgScrollView;
    
    NSString *videoUrlStr;
    MLLabel *contentLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"录制注意事项";
    [self createSubViews];
    [self getData];
}

-(void)createSubViews{
    bgScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    
    //1.
//    playerWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/375*212)];
  
    
    //2.
    contentLabel = [[MLLabel alloc]initWithFrame:CGRectMake(24, 20, SCREENWIDTH-47, 30)];
    contentLabel.lineSpacing = 4;
    [bgScrollView addSubview:contentLabel];
}

-(void)updateUIWithDictionary:(NSDictionary *)dataDic{
    videoUrlStr = dataDic[@"videoPath"];
    NSString *noteText = dataDic[@"noteText"];
    //Server返回空地址
    if (String_IsEmpty(videoUrlStr)) {
        //无视频
        contentLabel.top = 20;
    } else {
        if (!self.playerView) {
            //                    [self.playerView playPause];
            //                    self.playerView = nil;
            //                    NSLog(@"dddddd");
            NKAVPlayerView *playerView = [[NKAVPlayerView alloc] init];
            self.playerView = playerView;
            playerView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/375*212);
            [self.view addSubview:playerView];
            
        }
        [self.playerView settingPlayerItemWithUrl:[NSURL URLWithString:videoUrlStr]];
        contentLabel.top = self.playerView.bottom+24;
    }
    
    contentLabel.text = noteText;
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    
    bgScrollView.contentSize = CGSizeMake(SCREENWIDTH, contentLabel.bottom+20+StatusAndNaviHeight);
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.playerView) {
        [self.playerView stop];
    }
}
-(void)getData{
    if (!_taskId) {
        return;
    }
    NSDictionary *params = @{
                             @"taskId":_taskId
                             };
    
    [[BBRequestManager sharedInstance] getTaskDetailNoteWithParams:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        NSDictionary *dataDic = responseObject[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithDictionary:dataDic];
        });
    } failure:^(NSString * _Nonnull error) {
        [self showMessage:@"网络连接错误"];
    }];
    
}


#pragma mark - 事件
-(void)playerPlay{
    if (String_IsEmpty(videoUrlStr)) {
        
    }
}


@end
