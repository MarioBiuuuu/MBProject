//
//  NSDate+MBDBHandle.h
//  MBDBKit
//
//  Version 1.0
//

#import <Foundation/Foundation.h>

@interface NSDate (MBDBHandle)

+ (NSDate *)dateWithString:(NSString *)s;
+ (NSString *)stringWithDate:(NSDate *)date;

@end
