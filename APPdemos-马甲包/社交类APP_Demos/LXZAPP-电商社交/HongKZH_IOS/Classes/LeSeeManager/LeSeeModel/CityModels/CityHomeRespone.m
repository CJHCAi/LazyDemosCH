//
//Created by ESJsonFormatForMac on 18/09/14.
//

#import "CityHomeRespone.h"
@implementation CityHomeRespone
MJExtensionCodingImplementation
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation CityHomeData
MJExtensionCodingImplementation
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CityHomeModel class]};
}

@end


@implementation CityHomeModel
MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end


