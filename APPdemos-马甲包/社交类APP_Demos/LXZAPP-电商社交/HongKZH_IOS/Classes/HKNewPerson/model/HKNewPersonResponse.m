//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import "HKNewPersonResponse.h"
@implementation HKNewPersonResponse

@end

@implementation HKNewPersonData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKNewPersonList class]};
}

@end


@implementation HKNewPersonList

@end


