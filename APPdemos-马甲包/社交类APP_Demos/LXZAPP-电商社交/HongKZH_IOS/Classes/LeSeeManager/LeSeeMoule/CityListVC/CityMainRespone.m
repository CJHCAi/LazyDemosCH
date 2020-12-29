//
//Created by ESJsonFormatForMac on 18/09/14.
//

#import "CityMainRespone.h"
@implementation CityMainRespone

@end

@implementation CityMainDatas

+ (NSDictionary *)objectClassInArray{
    return @{@"hots" : [CityMainHostModel class], @"carousels" : [CarouselsModel class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}
@end


@implementation CityMainHostModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}
@end


@implementation CarouselsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}
@end


