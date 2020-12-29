//
//Created by ESJsonFormatForMac on 18/09/27.
//

#import "CommodityDetailsRespone.h"
@implementation CommodityDetailsRespone

@end

@implementation CommodityDetailesData

+ (NSDictionary *)objectClassInArray{
    return @{@"images" : [CommodityDetailsesImages class], @"coupons" : [CommodityDetailsesCoupons class], @"recs" : [CommodityDetailsesRecs class], @"colors" : [CommodityDetailsesColors class], @"skus" : [CommodityDetailsesSkus class], @"specs" : [CommodityDetailsesSpecs class]};
}

@end


@implementation CommodityDetailsesComment

@end


@implementation CommodityDetailsesShop

@end


@implementation CommodityDetailsesImages

@end


@implementation CommodityDetailsesCoupons

@end


@implementation CommodityDetailsesRecs

@end


@implementation CommodityDetailsesColors
-(void)setName:(NSString *)name{
    _name = name;
    CGSize sizeText=[name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}context:nil].size;
    self.w = sizeText.width+38;
}
@end


@implementation CommodityDetailsesSkus

@end


@implementation CommodityDetailsesSpecs
-(void)setName:(NSString *)name{
    _name = name;
    CGSize sizeText=[name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}context:nil].size;
    self.w = sizeText.width+38;
}
@end


