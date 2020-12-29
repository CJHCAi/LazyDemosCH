//
//Created by ESJsonFormatForMac on 18/10/13.
//

#import "HKUserVideoResponse.h"
@implementation HKUserVideoResponse

@end

@implementation HKUserVideoData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKUserVideoList class]};
}

@end


@implementation HKUserVideoList

@end


