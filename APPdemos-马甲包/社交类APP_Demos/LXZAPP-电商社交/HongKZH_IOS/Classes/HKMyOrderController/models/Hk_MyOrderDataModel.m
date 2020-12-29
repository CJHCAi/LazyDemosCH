//
//Created by ESJsonFormatForMac on 18/08/27.
//

#import "Hk_MyOrderDataModel.h"
@implementation Hk_MyOrderDataModel

@end

@implementation Hk_shopOrder

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HK_shopOrderList class]};
}

@end

@implementation HK_shopOrderList

+ (NSDictionary *)objectClassInArray{
    return @{@"subList" : [Hk_subOrderList class]};
}

@end


@implementation Hk_subOrderList

@end


