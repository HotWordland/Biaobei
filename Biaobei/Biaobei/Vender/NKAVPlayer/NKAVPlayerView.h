//
//  NKAVPlayerView.h
//  NKAVPlayer
//
//  Created by 聂宽 on 2019/1/13.
//  Copyright © 2019年 聂宽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NKAVPlayerControlView.h"

@protocol NKAVPlayerViewDelegate <NSObject>

- (void)finishPlay;
// 0 暂停 1播放
- (void)player:(NSInteger)count;

@end
@interface NKAVPlayerView : UIView
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, assign) float total;
@property (nonatomic, strong) NKAVPlayerControlView *controlView;
// define NO
@property (nonatomic, weak) id <NKAVPlayerViewDelegate> delegate;
@property (nonatomic, assign) BOOL isFullScreen;
/*
 初始化传入item 立即播放
 */
- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem;
- (void)settingPlayerItemWithUrl:(NSURL *)playerUrl;
- (void)settingPlayerItem:(AVPlayerItem *)playerItem;
- (void)playPause;
- (void)stop;
- (void)play;
@end
