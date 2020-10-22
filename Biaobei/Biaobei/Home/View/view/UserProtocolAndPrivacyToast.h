//
//  UserProtocolAndPrivacyToast.h
//  Biaobei
//
//  Created by yanming niu on 2019/11/27.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserProtocolAndPrivacyToast : UIView
@property (nonatomic, copy)void(^agreeBlock)(BOOL agree);
@property (nonatomic, copy)void(^procolBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
