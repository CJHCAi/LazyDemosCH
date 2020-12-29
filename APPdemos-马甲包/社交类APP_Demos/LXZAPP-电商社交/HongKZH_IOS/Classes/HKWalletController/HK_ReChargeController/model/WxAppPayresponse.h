//
//Created by ESJsonFormatForMac on 18/10/30.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class WxPayResultData;
@interface WxAppPayresponse : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) WxPayResultData *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface WxPayResultData : NSObject

@property (nonatomic, copy) NSString *partnerid;

@property (nonatomic, copy) NSString *nonceStr;

@property (nonatomic, assign) NSInteger timeStamp;

@property (nonatomic, copy) NSString *package;

@property (nonatomic, copy) NSString *codeurl;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *appid;

@property (nonatomic, copy) NSString *prepayid;

@end

