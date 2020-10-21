//
//  SM2SignMessage.h
//  WXQRCode
//
//  Created by Better on 2018/7/3.
//  Copyright © 2018年 Weconex. All rights reserved.
//


#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger , sm2SignStatus){
    sm2Sign_Success,
    sm2SignError_skEmpty,
    sm2SignError_xpEmpty,
    sm2SignError_ypEmpty,
    sm2SignError_IDEmpty,
    sm2SignError_MessageEmpty,
    sm2SignFail,
};

@interface SM2SignMessage : NSObject
//密钥
@property (nonatomic, copy) NSString *skString;
//ID
@property (nonatomic, copy) NSString *IDString;
//明文数据
@property (nonatomic, copy) NSString *Message;
//随机数k
@property (nonatomic, strong) NSString *k;
//最终结果合并
@property (nonatomic, copy, readonly) NSString *resultRS;

- (sm2SignStatus)sM2Sign;


@end
