//
//Created by ESJsonFormatForMac on 18/08/27.
//

#import "HK_orderListModel.h"
@implementation HK_orderListModel

@end

@implementation OrderData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [OrderList class]};
}

@end


@implementation OrderList

+ (NSDictionary *)objectClassInArray{
    return @{@"subList" : [Sublist class]};
}

@end


@implementation Sublist

@end


