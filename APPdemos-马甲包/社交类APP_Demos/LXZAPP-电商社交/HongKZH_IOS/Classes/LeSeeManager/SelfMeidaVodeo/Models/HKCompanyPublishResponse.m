//
//Created by ESJsonFormatForMac on 18/10/29.
//

#import "HKCompanyPublishResponse.h"
@implementation HKCompanyPublishResponse

@end

@implementation HKCompanyPublishData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKCompanyPublishList class]};
}

@end


@implementation HKCompanyPublishList

@end


