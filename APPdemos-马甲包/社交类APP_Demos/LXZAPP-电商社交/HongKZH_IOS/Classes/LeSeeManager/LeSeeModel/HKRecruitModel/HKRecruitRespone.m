//
//Created by ESJsonFormatForMac on 18/09/14.
//

#import "HKRecruitRespone.h"
@implementation HKRecruitRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation HKRecruitDatas

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [RecruitDataModel class]};
}

@end


@implementation RecruitDataModel

@end


