//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import "HKLuckyBurstListRespone.h"
#import "NSDate+Extend.h"
@implementation HKLuckyBurstListRespone

@end

@implementation LuckyBurstListData
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [LuckyBurstListFriend class]};
}
-(void)setCurrentTime:(NSString *)currentTime{
    _currentTime = currentTime;
    self.currentTimeStamp = [NSDate dateTimestampWithTimeString:currentTime separatedByString:@":"];
}
@end
@implementation LuckyBurstListFriend

@end


