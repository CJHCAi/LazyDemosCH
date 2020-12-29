//
//Created by ESJsonFormatForMac on 18/10/09.
//

#import "HKReconmendBaseResponse.h"
@implementation HKReconmendBaseResponse

@end

@implementation HKRecommendBaseData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKRecommendListData class]};
}

@end

@implementation HKRecommendListData


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


