//
//  BBVolumeView.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/16.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBVolumeView : UIView

-(void)clearView;

-(void)recordStart;

- (void)reRedraw:(CGFloat)power;  //重新绘制波形图

//BBCollectAudioViewController调用的方法
-(void)audioPowerChange:(CGFloat)power;
- (void)removeAudioArray;


@end

NS_ASSUME_NONNULL_END
