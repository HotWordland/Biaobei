//
//  NSString+XLDate.m
//  XLWallet
//
//  Created by Yu Fan on 2019/8/7.
//

#import "NSString+XLDate.h"

@implementation NSString (XLDate)

// 2019-08-07T09:05:27.751Z


- (NSString *)formateAsYYYYMM {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    //[dateFormatter setDateFormat:@"yyyy-MM-dd"]; //设定时间的格式
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";//使用带有子字符串'T'的日期格式
    NSDate *tempDate = [dateFormatter dateFromString:self];//将字符串转换为时间对象
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    return [formatter stringFromDate:tempDate];
}

- (NSString *)formateAsMM {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    //[dateFormatter setDateFormat:@"yyyy-MM-dd"]; //设定时间的格式
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";//使用带有子字符串'T'的日期格式
    NSDate *tempDate = [dateFormatter dateFromString:self];//将字符串转换为时间对象
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM"];
    return [formatter stringFromDate:tempDate];
}


+ (NSString *)time_timestampToString:(NSInteger)timestamp{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    
    return string;
    
}

//转成yyyy-MM-dd
+ (NSString *)day_timestampToString:(NSInteger)timestamp{
    timestamp = timestamp/1000;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    
    return string;
}

//传入 秒  得到 xx:xx:xx
+(NSString *)getHHMMSSFromSS:(NSInteger)totalTime{
    
    NSInteger seconds = totalTime;
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

//毫秒
+ (NSString *)getMinute_Second_millisecond:(NSInteger)allSeconds {
    NSString *minute = [NSString stringWithFormat:@"%02ld",(long)((allSeconds / 60) % 60)];
    NSString *second = [NSString stringWithFormat:@"%02ld",(long)allSeconds % 60];
    NSString *millisecond = [NSString stringWithFormat:@"%03ld",(long)allSeconds*1000];
    NSString *time = [NSString stringWithFormat:@"%@:%@:%@", minute, second, millisecond];  //MM:SS:sss
    return time;
}

//根据出生日期返回年龄的方法
+(NSString *)dateToOld:(NSString *)bornDateStr{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-mm-dd";
    NSDate *bornDate = [dateFormatter dateFromString:bornDateStr];
    
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //获得当前系统时间与出生日期之间的时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:bornDate];
    //时间间隔以秒作为单位,求年的话除以60*60*24*356
    int age = ((int)time)/(3600*24*365);
    return [NSString stringWithFormat:@"%d",age];
}

@end
