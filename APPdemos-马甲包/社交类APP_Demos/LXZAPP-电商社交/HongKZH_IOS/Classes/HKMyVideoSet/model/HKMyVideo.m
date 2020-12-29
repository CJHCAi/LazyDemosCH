//
//Created by ESJsonFormatForMac on 18/08/06.
//

#import "HKMyVideo.h"
@implementation HKMyVideo

@end

@implementation HKMyVideoData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKMyVideoList class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


@implementation HKMyVideoList
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


