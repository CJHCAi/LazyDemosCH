//
//Created by ESJsonFormatForMac on 18/09/21.
//

#import "EnterpriseAdvRespone.h"
@implementation EnterpriseAdvRespone


@end

@implementation EnterpriseAdvDatas

+ (NSDictionary *)objectClassInArray{
    return @{@"recommends" : [RecommendModle class],@"products":[HKAdvDetailsProducts class]};
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

@end


@implementation RecommendModle


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

@end
@implementation HKAdvDetailsProducts

@end

