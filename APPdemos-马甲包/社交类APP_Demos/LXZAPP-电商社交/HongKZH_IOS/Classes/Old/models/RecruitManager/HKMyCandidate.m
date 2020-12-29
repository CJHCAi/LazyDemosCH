//
//Created by ESJsonFormatForMac on 18/08/20.
//

#import "HKMyCandidate.h"
@implementation HKMyCandidate

@end

@implementation HKMyCandidateData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKMyCandidateList class]};
}

@end


@implementation HKMyCandidateList

@end


