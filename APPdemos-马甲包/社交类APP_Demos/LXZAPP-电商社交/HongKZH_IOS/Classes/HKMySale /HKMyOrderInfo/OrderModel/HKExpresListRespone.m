//
//Created by ESJsonFormatForMac on 18/09/03.
//

#import "HKExpresListRespone.h"
@implementation HKExpresListRespone
MJExtensionCodingImplementation
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [HKExpresModel class]};
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

@implementation HKExpresModel
MJExtensionCodingImplementation
@end


