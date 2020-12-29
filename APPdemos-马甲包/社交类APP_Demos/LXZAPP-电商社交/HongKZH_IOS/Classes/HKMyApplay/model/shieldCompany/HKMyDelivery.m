//
//Created by ESJsonFormatForMac on 18/08/15.
//

#import "HKMyDelivery.h"
@implementation HKMyDelivery

@end

@implementation HKMyDeliveryData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKMyDeliveryList class]};
}

@end


@implementation HKMyDeliveryList

+ (NSDictionary *)objectClassInArray{
    return @{@"logs" : [HKMyDeliveryLogs class]};
}

@end


@implementation HKMyDeliveryLogs

@end


