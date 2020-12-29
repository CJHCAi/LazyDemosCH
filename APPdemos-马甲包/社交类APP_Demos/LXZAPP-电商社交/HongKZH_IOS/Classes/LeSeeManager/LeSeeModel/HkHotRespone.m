//
//Created by ESJsonFormatForMac on 18/09/12.
//

#import "HkHotRespone.h"
@implementation HkHotRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation HKHotData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKHotModel class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


@implementation HKHotModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


