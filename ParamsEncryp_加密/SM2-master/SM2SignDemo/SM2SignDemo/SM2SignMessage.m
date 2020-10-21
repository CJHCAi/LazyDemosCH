//
//  SM2SignMessage.m
//  WXQRCode
//
//  Created by Better on 2018/7/3.
//  Copyright © 2018年 Weconex. All rights reserved.
//

#import "SM2SignMessage.h"
#import "sm2Sign.h"

#define sm2_K @"6CB28D99385C175C94F94E934817663FC176D925DD72B727260DBAAE1FB2F96F"

@interface SM2SignMessage ()

@property (nonatomic, copy, readwrite) NSString *resultRS;

@end

@implementation SM2SignMessage

- (sm2SignStatus)sM2Sign
{
    if (!self.skString) return sm2SignError_skEmpty;
    
    if (!self.IDString) return sm2SignError_IDEmpty;
    
    if (!self.Message) return sm2SignError_MessageEmpty;
    
    
    const char *sk = [self.skString UTF8String];
    const char *ID = [self.IDString UTF8String];
    const char *M  = [self.Message UTF8String];
    
    const char *k  =  (self.k) ? [self.k UTF8String] : [sm2_K UTF8String];
    
    char *ret = sm2_sign(sk, ID, M, k);
   
    NSString *result = [NSString stringWithFormat:@"%s",ret];
    
    if (![result isEqualToString:@"fail"]) {
        
        self.resultRS = result;
        return sm2Sign_Success;
    }
    return sm2SignFail;
}

@end
