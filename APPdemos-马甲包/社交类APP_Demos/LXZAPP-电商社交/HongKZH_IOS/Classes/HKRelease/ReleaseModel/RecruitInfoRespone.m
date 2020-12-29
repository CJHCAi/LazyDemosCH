//
//Created by ESJsonFormatForMac on 18/09/19.
//

#import "RecruitInfoRespone.h"
@implementation RecruitInfoRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation RecruitInfoDatas

@end


