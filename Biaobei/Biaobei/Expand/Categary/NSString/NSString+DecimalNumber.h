//
//  NSString+DecimalNumber.h
//  ZhanLuReader
//
//  Created by 黎仕仪 on 2019/5/20.
//  Copyright © 2019 ZLYD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DecimalNumber)

/**
 * 将price转成高精度并保留2位小数
 *
 * @param price 原price
 */
+(NSString *)getDecimalNumberFromPrice:(NSString *)price;

/**
 * 算差价  总价减现价
 *
 * @param totalPrice 总price
 * @param subPrice   现price
 */
+(NSString *)getDecimalNumberFromTotalPrice:(NSString *)totalPrice subtracting:(NSString *)subPrice;

/**
 * 算总价
 *
 * @param onePrice     价格1
 * @param otherPrice   价格2
 */
+(NSString *)getDecimalNumberFromPrice:(NSString *)onePrice addingOtherPrice:(NSString *)otherPrice;

/**
 * 算折扣价   原价*折扣率
 *
 * @param price   原价
 * @param rate    折扣率
 */
+(NSString *)getDecimalNumberFromPrice:(NSString *)price discountRate:(NSString *)rate;

/**
 * 算折扣后的差价   原价-原价*折扣率
 *
 * @param price   原价
 * @param rate    折扣率
 */
+(NSString *)getPriceDifferenceFromPrice:(NSString *)price discountRate:(NSString *)rate;


@end

NS_ASSUME_NONNULL_END
