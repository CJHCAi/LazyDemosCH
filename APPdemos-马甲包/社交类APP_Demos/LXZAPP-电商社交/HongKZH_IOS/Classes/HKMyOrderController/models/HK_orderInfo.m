//
//Created by ESJsonFormatForMac on 18/08/29.
//

#import "HK_orderInfo.h"
@implementation HK_orderInfo


@end

@implementation HK_orderDetailModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"subList" : [orderSubMitModel class]};
}


@end


@implementation orderAddressModel


@end


@implementation orderSubMitModel


@end


