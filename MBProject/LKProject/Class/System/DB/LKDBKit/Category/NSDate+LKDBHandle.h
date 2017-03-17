//
//  NSDate+LKDBHandle.h
//  LKDBKit
//
//  Version 1.0
//

#import <Foundation/Foundation.h>

@interface NSDate (LKDBHandle)

+ (NSDate *)dateWithString:(NSString *)s;
+ (NSString *)stringWithDate:(NSDate *)date;

@end