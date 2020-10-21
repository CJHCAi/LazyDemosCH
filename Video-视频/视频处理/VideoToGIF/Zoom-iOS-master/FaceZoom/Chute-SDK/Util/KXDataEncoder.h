//
//  KXDataEncoder.h
//  NmaPrivacyPolicy
//
//  Created by Aleksandar Trpeski on 9/18/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@interface KXDataEncoder : NSData

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;

@end
