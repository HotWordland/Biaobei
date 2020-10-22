//
//  NSString+DecimalNumber.m
//  ZhanLuReader
//
//  Created by 黎仕仪 on 2019/5/20.
//  Copyright © 2019 ZLYD. All rights reserved.
//

#import "NSString+DecimalNumber.h"

@implementation NSString (DecimalNumber)

//直接转，项目只保留2位小数，以后有需要额外暴露参数
+(NSString *)getDecimalNumberFromPrice:(NSString *)price{
    return [self getDecimalNumberFromTotalPrice:price subtracting:@"0"];
}

//算差价
+(NSString *)getDecimalNumberFromTotalPrice:(NSString *)totalPrice subtracting:(NSString *)subPrice{
    NSDecimalNumber *totalNumber = [NSDecimalNumber decimalNumberWithString:totalPrice];
    NSDecimalNumber *subNumber   = [NSDecimalNumber decimalNumberWithString:subPrice];
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *newNum = [totalNumber decimalNumberBySubtracting:subNumber withBehavior:roundingBehavior];
    if ([newNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]] == NSOrderedAscending ) {
        newNum = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    NSString *money = [self configPrice:newNum];
    return money;
}

//算总价
+(NSString *)getDecimalNumberFromPrice:(NSString *)onePrice addingOtherPrice:(NSString *)otherPrice{
    NSDecimalNumber *oneNumber   = [NSDecimalNumber decimalNumberWithString:onePrice];
    NSDecimalNumber *otherNumber = [NSDecimalNumber decimalNumberWithString:otherPrice];
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *newNum = [oneNumber decimalNumberByAdding:otherNumber withBehavior:roundingBehavior];
    if ([newNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]] == NSOrderedAscending ) {
        newNum = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    NSString *money = [self configPrice:newNum];
    return money;
}

//算折扣价
+(NSString *)getDecimalNumberFromPrice:(NSString *)price discountRate:(NSString *)rate{
    NSDecimalNumber *priceNumber = [NSDecimalNumber decimalNumberWithString:price];
    NSDecimalNumber *rateNumber  = [NSDecimalNumber decimalNumberWithString:rate];
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *newNum = [priceNumber decimalNumberByMultiplyingBy:rateNumber withBehavior:roundingBehavior];
    if ([newNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]] == NSOrderedAscending ) {
        newNum = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    NSString *money = [self configPrice:newNum];
    return money;
}

//算折扣后的差价
+(NSString *)getPriceDifferenceFromPrice:(NSString *)price discountRate:(NSString *)rate{
    NSDecimalNumber *priceNumber = [NSDecimalNumber decimalNumberWithString:price];
    NSDecimalNumber *rateNumber  = [NSDecimalNumber decimalNumberWithString:rate];
    NSDecimalNumber *ratePriceNumber = [priceNumber decimalNumberByMultiplyingBy:rateNumber];
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *newNum = [priceNumber decimalNumberBySubtracting:ratePriceNumber withBehavior:roundingBehavior];
    if ([newNum compare:[NSDecimalNumber decimalNumberWithString:@"0"]] == NSOrderedAscending ) {
        newNum = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    NSString *money = [self configPrice:newNum];
    return money;
}

+(NSString *)configPrice:(NSDecimalNumber *)decimalNumber{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [formatter setPositiveFormat:@",###.##"];
    NSString *money = [formatter stringFromNumber:decimalNumber];
//    if (![money containsString:@"."]) {
//        money = [money stringByAppendingString:@".00"];
//    }
    NSArray *strArr = [money componentsSeparatedByString:@"."];
    if (strArr.count==1) {//就是元
        money = [money stringByAppendingString:@".00"];
    }else if(strArr.count==2){//圆角分
        NSString *rightStr = strArr[1];
        if (rightStr.length==1) {
            money = [money stringByAppendingString:@"0"];
        }
    }
    
    return money;
}


@end
