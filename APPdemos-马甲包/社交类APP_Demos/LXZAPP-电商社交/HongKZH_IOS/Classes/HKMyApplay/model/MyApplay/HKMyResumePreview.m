//
//Created by ESJsonFormatForMac on 18/08/15.
//

#import "HKMyResumePreview.h"
@implementation HKMyResumePreview

@end

@implementation HKMyResumePreviewData

+ (NSDictionary *)objectClassInArray{
    return @{@"educationals" : [HKMyResumePreviewEducationals class], @"experiences" : [HKMyResumePreviewExperiences class], @"imgs" : [HKMyResumePreviewImgs class]};
}

@end


@implementation HKMyResumePreviewEducationals

@end


@implementation HKMyResumePreviewExperiences

@end


@implementation HKMyResumePreviewImgs

@end


