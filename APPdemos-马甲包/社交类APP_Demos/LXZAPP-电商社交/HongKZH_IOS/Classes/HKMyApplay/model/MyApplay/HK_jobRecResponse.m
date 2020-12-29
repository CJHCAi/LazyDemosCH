//
//Created by ESJsonFormatForMac on 18/09/17.
//

#import "HK_jobRecResponse.h"
@implementation HK_jobRecResponse

@end

@implementation HK_jobList

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HK_jobData class]};
}

@end


@implementation HK_jobData

@end


