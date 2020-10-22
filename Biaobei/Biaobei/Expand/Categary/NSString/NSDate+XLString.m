//
//  NSDate+XLString.m
//  XLWallet
//
//  Created by Yu Fan on 2019/8/6.
//

#import "NSDate+XLString.h"

@implementation NSDate (XLString)


- (NSString *)currentDateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:self];
}

- (NSString *)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:self]integerValue];
    return [NSString stringWithFormat:@"%ld", currentMonth];

//    [formatter setDateFormat:@"yyyy"];
//    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
//    [formatter setDateFormat:@"dd"];
//    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
}


@end
