//
//  NSDate+Addition.h
//  NeiHan
//
//  Created by Charles on 16/9/1.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

/**
 *  获取当前时间戳
 */
+ (NSString *)currentTimeStamp;

/**
 *  判断是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  判断是否为今天
 */
- (BOOL)isToday;

/**
 *  判断是否为今年
 */
- (BOOL)isThisYear;

/**
 *  获取固定格式的时间字符串
 */
- (NSString *)stringFromDateFormat:(NSString *)dateFromat;

/**
 *  通过时间字符串获取时间
 */
+ (NSDate *)dateFromString:(NSString *)dateStr;

/**
 *  与当前时间比较格式化返回，例如：刚刚，5分钟前等 ,传入时间戳
 *
 *  @param compareDate 待比对的时间字符串
 *
 *  @return 比对结果
 */
- (NSString *)compareCurrentTime:(NSString *)compareDate;

/**
 *  与当前时间比较格式化返回，例如：08：56，2016/08/30 08：56等 ,传入时间戳
 *
 *  @param dateStr 待比对的时间字符串
 *
 *  @return 比对结果
 */
- (NSString *)compareDate:(NSString *)dateStr;

/**
 *  判断是不是今天
 *
 *  @param date 带比对时间
 *
 *  @return BOOL值 0/1
 */
- (BOOL)isToday:(NSDate *)date;

/**
 *  判断是不是今天 ,传入标准时间
 *
 *  @param dateString 带比对时间
 *
 *  @return BOOL值 0/1
 */
- (BOOL)isTodayWithString:(NSString *)dateString;

/**
 *  判断是不是今天 ,传入时间戳
 *
 *  @param timeInterval 带比对时间
 *
 *  @return BOOL值 0/1
 */
- (BOOL)isTodayWithTimeInterval:(NSString *)timeInterval;

/**
 *  判断是不是昨天 ,传入标准时间
 *
 *  @param dateString 带比对时间
 *
 *  @return BOOL值 0/1
 */
- (BOOL)isYersterdayWithString:(NSString *)dateString;

/**
 *  判断是不是昨天 ,传入时间戳
 *
 *  @param timeInterval 带比对时间
 *
 *  @return BOOL值 0/1
 */
- (BOOL)isYersterdayWithTimeInterval:(NSString *)timeInterval;

/**
 *  时间戳转为时间
 *
 *  @param timeStamp 时间戳
 *
 *  @param formatter 时间格式
 *
 *  @return 星期
 */
- (NSString *)dateFromTimestamp:(NSString *)timeStamp formatter:(NSString *)formatter;

@end
