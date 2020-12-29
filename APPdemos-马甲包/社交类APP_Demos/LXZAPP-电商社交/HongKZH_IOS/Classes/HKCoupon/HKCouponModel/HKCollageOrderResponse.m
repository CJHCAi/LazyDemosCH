//
//Created by ESJsonFormatForMac on 18/10/16.
//

#import "HKCollageOrderResponse.h"
@implementation HKCollageOrderResponse

@end

@implementation HKCollageOrderData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKCollageList class]};
}

@end


@implementation HKCollageList

@end


