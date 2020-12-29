//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import "HKRecommendRespone.h"
@implementation HKRecommendRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation HKRecommendData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [RecommendModel class]};
}

@end


@implementation RecommendModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


