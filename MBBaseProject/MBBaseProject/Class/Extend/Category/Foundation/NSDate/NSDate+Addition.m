//
//  NSDate+Addition.m
//  NeiHan
//
//  Created by Charles on 16/9/1.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)


+ (NSDate *)dateFromString:(NSString *)dateStr{
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60];
    [format setTimeZone:timeZone];
    NSDate *date = [format dateFromString:dateStr];
    return date;
}

+ (NSDate *)dateFromString:(NSString *)dateStr dateFormat:(NSString *)dateFromat {
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    [format setDateFormat:dateFromat];
    format.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSDate *date = [format dateFromString:dateStr];
    return date;
}


+ (NSString *)currentTimeStamp {
    
    NSString *string = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*1000 + 0];
    NSString *dateString = [[string componentsSeparatedByString:@"."]objectAtIndex:0];
    return dateString;
}

- (NSString *)stringFromDateFormat:(NSString *)dateFromat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFromat];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [dateFormatter setTimeZone:timeZone];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
}

- (BOOL)isYesterday {

    NSDate * now = [NSDate date];
    NSDate *date = self;
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *createdDate = [format stringFromDate:self];
    NSString *nowDate = [format stringFromDate:now];
    date = [format dateFromString:createdDate];
    now = [format dateFromString:nowDate];
    NSCalendar * celendar = [NSCalendar currentCalendar];
    NSDateComponents * Components = [celendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now toDate:date options:0];
    return Components.month == 0 && Components.day == 1 && Components.year == 0;
}

- (BOOL)isToday {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *nowDate = [format stringFromDate:now];
    NSString *createDate = [format stringFromDate:self];
    
    return [nowDate isEqualToString:createDate];
    
}

- (BOOL)isThisYear {
    
    //创建日历进行比对
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //获取当前数据年
    NSDateComponents *created =[calendar components:NSCalendarUnitYear fromDate:self];
    
    NSDateComponents *now =[calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return created.year == now.year;
}

+ (NSString *)compareCurrentTime:(NSString *)compareDate {
    
    if (compareDate.length == 0 || [compareDate isEqualToString:@""] || [compareDate isEqualToString:@"0"]) {
        return @"";
    }
    double unixTimeStamp = compareDate.length >= 13? [[compareDate substringToIndex:compareDate.length -3 ]  doubleValue]: [compareDate doubleValue];
    NSTimeInterval _interval = unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *_date = [_formatter stringFromDate:date];
    NSDate * newdate = [_formatter dateFromString:_date];
    NSTimeInterval  timeInterval = [newdate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    } else if((temp = temp/60) <=24 ){
        result =[self isToday:date]?[NSString stringWithFormat:@"%ld小时前",temp]:[self compareDate:compareDate];
    } else if((temp = temp/24 ) <30){
        result = [self compareDate:compareDate];
    } else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    } else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+ (NSString *)compareDate:(NSString *)compareDate {
    
    double unixTimeStamp = compareDate.length >= 13? [[compareDate substringToIndex:compareDate.length -3 ]  doubleValue]: [compareDate doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *destDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate * localeDate = [date1  dateByAddingTimeInterval: interval];
    
    NSDateFormatter *_formatter1=[[NSDateFormatter alloc]init];
    [_formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *today =localeDate;
    
    NSDate *tomorrow, *yesterday,*qiantianDaty;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    qiantianDaty = [today dateByAddingTimeInterval:-2*secondsPerDay];
    
    NSString * todayString = [[_formatter1 stringFromDate:today] substringToIndex:10];
    
    NSString * dateString = [[_formatter1 stringFromDate:destDate] substringToIndex:10];//接收得时间
    
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"HH:mm"];
    
    if ([dateString isEqualToString:todayString]) {
        [_formatter setDateFormat:@"HH:mm"];
        NSString *_date=[_formatter stringFromDate:destDate];
        return _date;
    } else if ([[dateString substringToIndex:4] isEqualToString:[todayString substringToIndex:4]]) {
        [_formatter setDateFormat:@"MM/dd HH:mm"];
        NSString *_date=[_formatter stringFromDate:destDate];
        return _date;
    } else {
        [_formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *_date=[_formatter stringFromDate:destDate];
        return _date;
    }
    
}
+ (BOOL)isToday:(NSDate *)date {
    
    NSRange range;
    range.length = 10;
    range.location = 0;
    NSString *timeStr = [self getCurrentDateString];
    NSTimeInterval _interval=[timeStr.length >= 13 ? [timeStr substringToIndex:10]:timeStr doubleValue];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setTimeZone:timeZone];
    NSString *dateNewString = [formatter stringFromDate:nowDate];
    NSString *dateOldString = [formatter stringFromDate:date];
    if ([[dateNewString substringWithRange:range] isEqualToString:[dateOldString substringWithRange:range]]) {
        return YES;
    }
    return NO;
    
}
+ (NSString *)getCurrentDateString {
    
    NSString *string = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*1000 + 0];
    NSString *dateString = [[string componentsSeparatedByString:@"."]objectAtIndex:0];
    return dateString;
}

+ (BOOL)isTodayWithString:(NSString *)dateString{
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createDate = [format dateFromString:dateString];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *createDateString = [format stringFromDate:createDate];
    NSDate *now = [NSDate date];
    NSString *nowDate = [format stringFromDate:now];
    return [createDateString isEqualToString:nowDate];
    
}

+ (BOOL)isTodayWithTimeInterval:(NSString *)timeInterval {
    
    double unixTimeStamp = timeInterval.length >= 13? [[timeInterval substringToIndex:timeInterval.length -3 ]  doubleValue]: [timeInterval doubleValue];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:unixTimeStamp];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *createDateString = [format stringFromDate:createDate];
    NSDate *now = [NSDate date];
    NSString *nowDate = [format stringFromDate:now];
    return [createDateString isEqualToString:nowDate];
    
}

+ (BOOL)isYersterdayWithString:(NSString *)dateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *now = [NSDate date];
    NSDate *date = [formatter dateFromString:dateString];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *createdDate = [formatter stringFromDate:date];
    NSString *nowDate = [formatter stringFromDate:now];
    date = [formatter dateFromString:createdDate];
    now = [formatter dateFromString:nowDate];
    NSCalendar * celendar = [NSCalendar currentCalendar];
    NSDateComponents * Components = [celendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now toDate:date options:0];
    return Components.month == 0 && Components.day == 1 && Components.year == 0;
    
}

+ (BOOL)isYersterdayWithTimeInterval:(NSString *)timeInterval {
    double unixTimeStamp = timeInterval.length >= 13? [[timeInterval substringToIndex:timeInterval.length -3]  doubleValue]:[timeInterval doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *now = [NSDate date];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimeStamp];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *createdDate = [formatter stringFromDate:date];
    NSString *nowDate = [formatter stringFromDate:now];
    date = [formatter dateFromString:createdDate];
    now = [formatter dateFromString:nowDate];
    
    int unit = NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear;
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:now];
    NSDateComponents *dateComps = [calendar components:unit fromDate:date];
    
    return nowCmps.weekOfYear == dateComps.weekOfYear && nowCmps.yearForWeekOfYear == dateComps.yearForWeekOfYear;
    
}

+ (NSString *)dateFromTimestamp:(NSString *)timeStamp formatter:(NSString *)formatter{
    
    NSTimeInterval interval=[timeStamp doubleValue]/1000.0;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatter];
    NSString *time = [dateFormatter stringFromDate:detaildate];
    return time;
    
}

//时间差
+ (NSInteger)compareTimeIntervalDate:(NSDate *)date otherDate:(NSDate *)otherDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:otherDate options:0];
    
    NSInteger totalSecond = [d hour]*3600+[d minute]*60+[d second];
    
    return totalSecond;
}

@end
