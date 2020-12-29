//
//Created by ESJsonFormatForMac on 18/10/11.
//

#import "HKluckyBurstDetailRespone.h"
#import "NSDate+Extend.h"
@implementation HKluckyBurstDetailRespone

@end

@implementation LuckyBurstDetailData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [LuckyBurstListFriend class],@"advs":[LuckyBurstDetaiAdvs class]};
}
-(void)setCurrentTime:(NSString *)currentTime{
    _currentTime = currentTime;
    self.currentTimeStamp = [NSDate dateTimestampWithTimeString:currentTime separatedByString:@":"];
}
@end





@implementation LuckyBurstDetaiAdvs

@end
