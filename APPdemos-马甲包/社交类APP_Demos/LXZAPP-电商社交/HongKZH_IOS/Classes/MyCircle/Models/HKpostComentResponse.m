//
//Created by ESJsonFormatForMac on 18/10/25.
//

#import "HKpostComentResponse.h"
@implementation HKpostComentResponse

@end

@implementation HKPostcommetData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKCommentList class]};
}

@end


@implementation HKCommentList

@end


