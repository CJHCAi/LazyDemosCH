//
//  ANAlipayResultCode.h
//  AlipayDemo
//
//  Created by liuyan on 10/26/15.
//  Copyright © 2015 Candyan. All rights reserved.
//

#ifndef ANAlipayResultCode_h
#define ANAlipayResultCode_h

typedef enum : NSUInteger {
    ANAlipayResultCodePaySuccess = 9000,
    ANAlipayResultCodeProcessing = 8000,
    ANAlipayResultCodePayFailure = 4000,
    ANAlipayResultCodeCancel = 6001,
    ANAlipayResultCodeNetworkError = 6002,
} ANAlipayResultCode;

#endif /* ANAlipayResultCode_h */
