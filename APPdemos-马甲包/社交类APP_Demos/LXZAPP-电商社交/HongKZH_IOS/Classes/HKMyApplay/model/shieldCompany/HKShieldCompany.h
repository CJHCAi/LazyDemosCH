//
//Created by ESJsonFormatForMac on 18/08/13.
//

#import <Foundation/Foundation.h>

/**
 屏蔽公司
 */
@class HKShieldCompanyData;
@interface HKShieldCompany : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKShieldCompanyData *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKShieldCompanyData : NSObject

@property (nonatomic, copy) NSString *corporateName;

@property (nonatomic, copy) NSString *companyId;

@end

