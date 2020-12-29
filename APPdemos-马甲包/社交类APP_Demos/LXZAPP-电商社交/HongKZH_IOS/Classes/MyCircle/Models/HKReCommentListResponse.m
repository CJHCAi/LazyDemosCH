//
//Created by ESJsonFormatForMac on 18/10/27.
//

#import "HKReCommentListResponse.h"
@implementation HKReCommentListResponse

@end

@implementation HKReCommentData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKReCommentList class]};
}

@end


@implementation HKReCommentList

@end


