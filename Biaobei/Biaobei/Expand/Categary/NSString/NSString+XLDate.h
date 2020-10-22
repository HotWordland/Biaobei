//
//  NSString+XLDate.h
//  XLWallet
//
//  Created by Yu Fan on 2019/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XLDate)
- (NSString *)formateAsYYYYMM;
- (NSString *)formateAsMM;

//根据出生日期返回年龄的方法
+(NSString *)dateToOld:(NSString *)bornDateStr;

//转成yyyy-MM-dd HH:mm
+ (NSString *)time_timestampToString:(NSInteger)timestamp;

//转成yyyy-MM-dd
+ (NSString *)day_timestampToString:(NSInteger)timestamp;

//传入 秒  得到 xx:xx:xx
+(NSString *)getHHMMSSFromSS:(NSInteger)totalTime;

//MM-SS-sss
+ (NSString *)getMinute_Second_millisecond:(NSInteger)allSeconds;

@end

NS_ASSUME_NONNULL_END
