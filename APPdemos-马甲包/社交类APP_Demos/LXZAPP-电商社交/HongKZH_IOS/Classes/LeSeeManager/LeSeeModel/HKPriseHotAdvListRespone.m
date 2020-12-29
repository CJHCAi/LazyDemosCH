//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import "HKPriseHotAdvListRespone.h"
@implementation HKPriseHotAdvListRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation HKPriseHotAdvListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [PriseHotAdvListModel class]};
}

@end


@implementation PriseHotAdvListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}
@end


