//
//  NSObject+MBDBHandle.h
//  MBDBKit
//
//  Version 1.0
//

#import <Foundation/Foundation.h>

@interface NSObject (MBDBHandle)

+ (id)objectWithString:(NSString *)s;
+ (NSString *)stringWithObject:(NSObject *)obj;

@end
