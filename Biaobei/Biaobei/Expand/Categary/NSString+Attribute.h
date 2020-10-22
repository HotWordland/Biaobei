//
//  NSString+Attribute.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Attribute)

-(NSAttributedString *)giveFont:(UIFont *)font giveLineSpace:(int)space textColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
