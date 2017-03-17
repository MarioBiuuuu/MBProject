//
//  NSData+LKDBHandle.h
//  LKDBKit
//
//  Version 1.0
//

#import <Foundation/Foundation.h>

@interface NSData (LKDBHandle)

- (NSString *)base64String;
/** encrypt */
- (NSData *)aes256EncryptWithKey:(NSString *)key;
/** decrypt */
- (NSData *)aes256DecryptWithKey:(NSString *)key;

@end