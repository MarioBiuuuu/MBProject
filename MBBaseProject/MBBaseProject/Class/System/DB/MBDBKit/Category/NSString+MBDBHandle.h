//
//  NSString+MBDBHandle.h
//  MBDBKit
//
//  Version 1.0
//

#import <Foundation/Foundation.h>

@interface NSString (MBDBHandle)

- (NSData *)base64Data;
- (NSString *)encryptWithKey:(NSString *)key;
- (NSString *)decryptWithKey:(NSString *)key;

@end
