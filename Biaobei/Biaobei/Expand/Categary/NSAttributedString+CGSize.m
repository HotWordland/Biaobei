//
//  NSAttributedString+CGSize.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "NSAttributedString+CGSize.h"


@implementation NSAttributedString (CGSize)
-(float)getsize:(float)width {
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
    return (float)size.height;
}
@end
