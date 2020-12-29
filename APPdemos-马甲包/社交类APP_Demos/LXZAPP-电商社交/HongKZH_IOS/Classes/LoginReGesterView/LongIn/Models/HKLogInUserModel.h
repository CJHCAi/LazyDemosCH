//
//Created by ESJsonFormatForMac on 18/08/21.
//

#import <Foundation/Foundation.h>

@class HKUserData;

@interface HKLogInUserModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKUserData *data;

@property (nonatomic, assign) NSInteger code;



@end

@interface HKUserData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *occupation;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *loginUid;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *isEnterpriserecRuited;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;



@end

