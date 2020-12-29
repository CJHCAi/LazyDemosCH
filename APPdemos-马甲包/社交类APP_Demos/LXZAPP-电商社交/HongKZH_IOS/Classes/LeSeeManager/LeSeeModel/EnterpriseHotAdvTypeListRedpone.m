//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import "EnterpriseHotAdvTypeListRedpone.h"
@implementation EnterpriseHotAdvTypeListRedpone

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [EnterpriseHotAdvTypeListModel class]};
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

@implementation EnterpriseHotAdvTypeListModel

@end


