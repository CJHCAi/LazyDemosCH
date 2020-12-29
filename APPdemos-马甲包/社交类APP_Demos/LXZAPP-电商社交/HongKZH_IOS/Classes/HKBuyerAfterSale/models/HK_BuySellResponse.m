//
//Created by ESJsonFormatForMac on 18/09/05.
//

#import "HK_BuySellResponse.h"
@implementation HK_BuySellResponse

@end

@implementation HK_SaleBaseData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HK_SaleLIstData class]};
}

@end


@implementation HK_SaleLIstData

+ (NSDictionary *)objectClassInArray{
    return @{@"subList" : [HK_SubListSaleData class]};
}

@end


@implementation HK_SubListSaleData

@end


