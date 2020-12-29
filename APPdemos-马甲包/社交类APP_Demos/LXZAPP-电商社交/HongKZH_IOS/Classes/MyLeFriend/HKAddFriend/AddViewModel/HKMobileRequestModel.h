//
//Created by ESJsonFormatForMac on 18/08/27.
//

#import <Foundation/Foundation.h>

@class HKMobileModel;
@interface HKMobileRequestModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKMobileModel *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMobileModel : NSObject

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *mobile;

@end

