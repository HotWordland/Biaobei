//
//  PingManager.h
//  PingLib
//
//  Created by 王家辉 on 2019/11/12.
//  Copyright © 2019年 Soc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STSimplePing.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^PingResult)(BOOL);

@interface PingManager : NSObject

+ (PingManager *)startPing:(NSString *)hostname result:(PingResult)result;

@end

NS_ASSUME_NONNULL_END
