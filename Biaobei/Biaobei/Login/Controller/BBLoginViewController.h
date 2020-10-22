//
//  BBLoginViewController.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseViewController.h"

@interface BBLoginModel : BaseBeanModel

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, copy) NSString *refresh_token;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *token_type;
@property (nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BBLoginViewController : BaseViewController

@end

NS_ASSUME_NONNULL_END
