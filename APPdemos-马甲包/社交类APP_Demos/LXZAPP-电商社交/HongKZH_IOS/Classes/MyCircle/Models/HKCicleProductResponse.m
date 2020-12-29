//
//Created by ESJsonFormatForMac on 18/10/30.
//

#import "HKCicleProductResponse.h"
@implementation HKCicleProductResponse

@end

@implementation HKCicleData

+ (NSDictionary *)objectClassInArray{
    return @{@"images" : [HKCicleIMage class], @"skus" : [HKCicleSku class]};
}

@end


@implementation HKCicleUserData
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end


@implementation HKCicleIMage

@end


@implementation HKCicleSku

@end


