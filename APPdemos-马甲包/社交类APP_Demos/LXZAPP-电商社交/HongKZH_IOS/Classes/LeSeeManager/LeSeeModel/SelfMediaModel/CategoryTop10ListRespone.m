//
//Created by ESJsonFormatForMac on 18/09/15.
//

#import "CategoryTop10ListRespone.h"
@implementation CategoryTop10ListRespone

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [CategoryTop10ListModel class]};
}

@end

@implementation CategoryTop10ListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


