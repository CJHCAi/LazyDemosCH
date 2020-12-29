//
//Created by ESJsonFormatForMac on 18/10/29.
//

#import <Foundation/Foundation.h>

@class HKCompanyData;
@interface HKCompanyResPonse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKCompanyData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKCompanyData : NSObject

@property (nonatomic, copy) NSString *eName;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, assign) NSInteger follows;

@property (nonatomic, copy) NSString *enterpriseId;

@property (nonatomic, copy) NSString *followState;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *followId;

@end

