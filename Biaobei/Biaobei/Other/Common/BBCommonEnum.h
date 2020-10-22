//
//  BBCommonEnum.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/7.
//  Copyright © 2019 文亮. All rights reserved.
//

#ifndef BBCommonEnum_h
#define BBCommonEnum_h
#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    NoRefer = 0,  //未录制  或  未提交
    NoAccess,     //未通过
    Acess,        //通过
    Checking      //质检中
} voiceStates;

#endif /* BBCommonEnum_h */
