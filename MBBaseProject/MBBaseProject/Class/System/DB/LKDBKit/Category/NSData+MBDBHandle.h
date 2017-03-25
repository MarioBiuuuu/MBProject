//
//  NSData+MBDBHandle.h
//  MBDBKit
//
//  Version 1.0
//

#import <Foundation/Foundation.h>

@interface NSData (MBDBHandle)

- (NSString *)base64String;
/** encrypt */
- (NSData *)aes256EncryptWithKey:(NSString *)key;
/** decrypt */
- (NSData *)aes256DecryptWithKey:(NSString *)key;

@end
