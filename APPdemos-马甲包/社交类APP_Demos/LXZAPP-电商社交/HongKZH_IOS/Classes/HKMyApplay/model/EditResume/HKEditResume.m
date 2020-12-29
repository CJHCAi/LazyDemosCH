//
//Created by ESJsonFormatForMac on 18/08/13.
//

#import "HKEditResume.h"
@implementation HKEditResume

@end

@implementation HKEditResumeData

+ (NSDictionary *)objectClassInArray{
    return @{@"imgs" : [HKEditResumeDataImgs class]};
}

@end


@implementation HKEditResumeDataImgs
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

@end


