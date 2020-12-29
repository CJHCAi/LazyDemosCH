//
//Created by ESJsonFormatForMac on 18/09/12.
//

#import "HKUserCategoryListRespone.h"
@implementation HKUserCategoryListRespone
MJExtensionCodingImplementation
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [HKUserCategoryListModel class]};
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

@implementation HKUserCategoryListModel
MJExtensionCodingImplementation
@end


