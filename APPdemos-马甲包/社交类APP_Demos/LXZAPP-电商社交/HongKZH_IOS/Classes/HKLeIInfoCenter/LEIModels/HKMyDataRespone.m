//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import "HKMyDataRespone.h"
@implementation HKMyDataRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation HKMyInfoModel

@end


