//
//  NSString+LKDBHandle.h
//  LKDBKit
//
//  Version 1.0
//

#import <Foundation/Foundation.h>

@interface NSString (LKDBHandle)

- (NSData *)base64Data;
- (NSString *)encryptWithKey:(NSString *)key;
- (NSString *)decryptWithKey:(NSString *)key;

@end