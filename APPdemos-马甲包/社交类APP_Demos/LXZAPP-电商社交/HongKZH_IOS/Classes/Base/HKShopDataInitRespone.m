//
//Created by ESJsonFormatForMac on 18/10/08.
//

#import "HKShopDataInitRespone.h"
@implementation HKShopDataInitRespone
MJExtensionCodingImplementation
@end

@implementation ShopDatas
MJExtensionCodingImplementation
+ (NSDictionary *)objectClassInArray{
    return @{@"allMediaShopCategorys" : [AllmediashopcategorysInit class], @"mediaAreas" : [MediaareasInits class], @"systemShopCategorys" : [SystemshopcategorysInit class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
-(void)setMediaAreas:(NSArray<MediaareasInits *> *)mediaAreas{
    _mediaAreas = mediaAreas;
    NSMutableArray*areasArray = [NSMutableArray array];
    for (MediaareasInits*intits in mediaAreas) {
        if ([intits.parentId isEqualToString:@"0"]) {
            [intits.provinceArray removeAllObjects];
            [areasArray addObject:intits];
        }
    }
    for (MediaareasInits*p in mediaAreas) {
        if (![p.parentId isEqualToString:@"0"]) {
            for (MediaareasInits*intits in areasArray) {
                if ([intits.ID isEqualToString:p.parentId]) {
                    [intits.provinceArray addObject:p];
                    break;
                }
            }
        }
    }
    self.areasArray = areasArray;
}
@end


@implementation AllmediashopcategorysInit
MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


@implementation MediaareasInits
MJExtensionCodingImplementation
- (NSMutableArray *)provinceArray
{
    if(_provinceArray == nil)
    {
        _provinceArray = [ NSMutableArray array];
    }
    return _provinceArray;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


@implementation SystemshopcategorysInit
MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


