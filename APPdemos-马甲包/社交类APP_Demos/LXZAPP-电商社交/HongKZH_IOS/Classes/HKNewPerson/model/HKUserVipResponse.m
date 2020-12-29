//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import "HKUserVipResponse.h"
@implementation HKUserVipResponse

@end

@implementation HKUserVipBaseData

+ (NSDictionary *)objectClassInArray{
    return @{@"imgs" : [HKUserVipList class]};
}

@end


@implementation HKUserVipList

@end


