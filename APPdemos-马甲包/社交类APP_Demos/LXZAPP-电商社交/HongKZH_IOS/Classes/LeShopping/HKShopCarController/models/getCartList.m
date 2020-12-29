//
//Created by ESJsonFormatForMac on 18/07/19.
//

#import "getCartList.h"
@implementation getCartList

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [getCartListData class]};
}

-(void)setData:(NSArray<getCartListData *> *)data{
    _data = data;
    for ( NSInteger i=0;i<data.count;i++) {
        getCartListData*listData = data[i];
        listData.randomID = i;
        for (getCartListDataProducts*productM in listData.products) {
            productM.randomID = i;
        }
    }
}
@end

@implementation getCartListData

+ (NSDictionary *)objectClassInArray{
    return @{@"products" : [getCartListDataProducts class]};
}
@synthesize products = _products;
-(NSMutableArray<getCartListDataProducts *> *)products{
    if (!_products) {
        _products = [NSMutableArray array];
    }
    return _products;
}
-(void)setProducts:(NSMutableArray<getCartListDataProducts *> *)products{
    _products = products;
    self.allCouponCount = 0;
    for (getCartListDataProducts*model in products) {
        self.allCouponCount += model.couponCount;
    }
}
@end


@implementation getCartListDataProducts


@end


