//
//Created by ESJsonFormatForMac on 18/08/31.
//

#import <Foundation/Foundation.h>

@class SellerorderListHeadeModel;
@interface HKSellerorderListHeaderPesone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) SellerorderListHeadeModel *data;

@property (nonatomic, assign) NSString* code;

@end
@interface SellerorderListHeadeModel : NSObject

@property (nonatomic, assign) NSInteger salecCount;

@property (nonatomic, assign) NSInteger paymentfCount;

@property (nonatomic, assign) NSInteger shippedCount;

@property (nonatomic, assign) NSInteger deliveryCount;

@end

