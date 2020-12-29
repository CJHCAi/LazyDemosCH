//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import "CorporateCategoryResponse.h"
@implementation CorporateCategoryResponse

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CorporateCategoryModel class]};
}
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation CorporateCategoryModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


