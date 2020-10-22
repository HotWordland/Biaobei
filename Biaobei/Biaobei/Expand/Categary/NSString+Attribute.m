//
//  NSString+Attribute.m
//  Biaobei
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "NSString+Attribute.h"

@implementation NSString (Attribute)
-(NSAttributedString *)giveFont:(UIFont *)font giveLineSpace:(int)space textColor:(UIColor *)color {
    NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = space;
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:self];
    [attributeString addAttributes:@{NSParagraphStyleAttributeName: style,NSForegroundColorAttributeName: color, NSFontAttributeName : font,} range:NSMakeRange(0, self.length)];
    return attributeString;
}

@end
