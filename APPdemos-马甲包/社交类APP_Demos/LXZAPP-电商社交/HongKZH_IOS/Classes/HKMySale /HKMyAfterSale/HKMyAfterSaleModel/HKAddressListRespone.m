//
//Created by ESJsonFormatForMac on 18/09/05.
//

#import "HKAddressListRespone.h"
@implementation HKAddressListRespone

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [HKAddressModel class]};
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

@implementation HKAddressModel


@end


