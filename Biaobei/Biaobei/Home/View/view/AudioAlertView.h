//
//  AudioAlertView.h
//  Biaobei
//
//  Created by 王家辉 on 2019/12/11.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OkBlock)(NSInteger index);

@interface AudioAlertView : UIView
@property (nonatomic, copy) OkBlock okBlock;
-(instancetype)init:(NSString *)imageName
       alertMessage:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
            okTitle:(NSString *)okTitle;
@end

NS_ASSUME_NONNULL_END
