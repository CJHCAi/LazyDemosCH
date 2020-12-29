//
//Created by ESJsonFormatForMac on 18/10/08.
//

#import "HKShopNewGoods.h"
@implementation HKShopNewGoods

@end

@implementation HKShopNewGoodData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKShopNewGoodsList class]};
}

@end


@implementation HKShopNewGoodsList

+ (NSDictionary *)objectClassInArray{
    return @{@"products" : [HKShopNewGoodsProduct class]};
}

@end


@implementation HKShopNewGoodsProduct

@end


