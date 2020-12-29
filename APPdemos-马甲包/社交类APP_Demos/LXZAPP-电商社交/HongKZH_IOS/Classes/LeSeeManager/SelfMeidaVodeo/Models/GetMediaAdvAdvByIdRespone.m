//
//Created by ESJsonFormatForMac on 18/09/19.
//

#import "GetMediaAdvAdvByIdRespone.h"
@implementation GetMediaAdvAdvByIdRespone
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}
@end

@implementation GetMediaAdvAdvByIdsData

+ (NSDictionary *)objectClassInArray{
    return @{@"photographys" : [Photographys class], @"tags" : [GetMediaAdvAdvByIdTags class], @"albums" : [GetMediaAdvAdvByIdsAlbums class], @"products" : [GetMediaAdvAdvByIdProducts class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}
@end


@implementation Photographys

@end


@implementation GetMediaAdvAdvByIdTags

@end


@implementation GetMediaAdvAdvByIdsAlbums

@end


@implementation GetMediaAdvAdvByIdProducts

@end


