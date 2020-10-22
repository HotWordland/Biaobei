//
//  BaseWebViewController.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/23.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseWebViewController : BaseViewController

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *webTitle;
@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, assign) BOOL noDelegate;

@end

NS_ASSUME_NONNULL_END
