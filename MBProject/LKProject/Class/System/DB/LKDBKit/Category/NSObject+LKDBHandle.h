//
//  NSObject+LKDBHandle.h
//  LKDBKit
//
//  Version 1.0
//

#import <Foundation/Foundation.h>

@interface NSObject (LKDBHandle)

+ (id)objectWithString:(NSString *)s;
+ (NSString *)stringWithObject:(NSObject *)obj;

@end
