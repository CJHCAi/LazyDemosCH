//
//Created by ESJsonFormatForMac on 18/09/28.
//

#import <Foundation/Foundation.h>

@class HKAccountData;
@interface HKAccountResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKAccountData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKAccountData : NSObject

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *weixin;

@property (nonatomic, copy) NSString *qq;

@end

