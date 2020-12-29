//
//  NSData+AES.h
//  Smile
//
//  Created by 周 敏 on 12-11-24.

//

#import <Foundation/Foundation.h>


@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密


- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;

@end
