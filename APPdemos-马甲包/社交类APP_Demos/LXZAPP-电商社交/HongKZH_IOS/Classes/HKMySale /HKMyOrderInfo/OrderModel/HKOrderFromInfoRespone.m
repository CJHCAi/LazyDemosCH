//
//Created by ESJsonFormatForMac on 18/09/01.
//

#import "HKOrderFromInfoRespone.h"
@implementation HKOrderFromInfoRespone

@end

@implementation HKOrderInfoData

+ (NSDictionary *)objectClassInArray{
    return @{@"subList" : [SubModellist class]};
}
-(void)setState:(NSString *)state{
    _state = state;
    if (state.intValue == OrderFormStatue_cnsignment||state.intValue == OrderFormStatue_consignee||state.intValue == OrderFormStatue_finish) {
        self.h = 151;
    }else{
       self.h = 70;
    }
}
@end


@implementation AddressModel
-(NSString *)loginUid{
    return HKUSERLOGINID;
}
@end


@implementation SubModellist

@end


