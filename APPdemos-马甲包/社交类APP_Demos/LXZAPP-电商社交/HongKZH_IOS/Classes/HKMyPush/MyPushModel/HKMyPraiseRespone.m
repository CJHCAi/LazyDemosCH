//
//Created by ESJsonFormatForMac on 18/09/12.
//

#import "HKMyPraiseRespone.h"
@implementation HKMyPraiseRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation HKMyPraiseData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HkPraiseModel class]};
}

@end


@implementation HkPraiseModel

@end


