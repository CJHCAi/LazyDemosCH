//
//Created by ESJsonFormatForMac on 18/08/31.
//

#import "HKSellerorderListRespone.h"
@implementation HKSellerorderListRespone

@end

@implementation HKSellerorderListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKSellerorderModel class]};
}

@end


@implementation HKSellerorderModel

+ (NSDictionary *)objectClassInArray{
    return @{@"subList" : [SubModel class]};
}

@end


@implementation SubModel

@end


