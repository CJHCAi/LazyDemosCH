//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import "HKDisCutResponse.h"
@implementation HKDisCutResponse

@end

@implementation HKDisCutData

@end


@implementation HKDisCutRecord

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKDisCutList class]};
}

@end


@implementation HKDisCutList

@end


