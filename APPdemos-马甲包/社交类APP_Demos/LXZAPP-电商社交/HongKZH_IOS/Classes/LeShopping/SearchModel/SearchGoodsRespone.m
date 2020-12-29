//
//Created by ESJsonFormatForMac on 18/10/11.
//

#import "SearchGoodsRespone.h"
#import "HKSearchModels.h"
@implementation SearchGoodsRespone

@end

@implementation SearchGoodsData
+ (NSDictionary *)objectClassInArray{
    return @{@"hosts" : [HKSearchModels class],@"historys":[HKSearchModels class]};
}

@end


