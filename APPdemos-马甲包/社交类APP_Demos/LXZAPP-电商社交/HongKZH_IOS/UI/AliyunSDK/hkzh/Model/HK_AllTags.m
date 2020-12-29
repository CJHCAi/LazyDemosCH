//
//Created by ESJsonFormatForMac on 18/07/27.
//

#import "HK_AllTags.h"
@implementation HK_AllTags

@end

@implementation HK_AllTagsData

+ (NSDictionary *)objectClassInArray{
    return @{@"his" : [HK_AllTagsHis class], @"circles" : [HK_AllTagsCircles class], @"recommends" : [HK_AllTagsRecommends class]};
}

@end


@implementation HK_AllTagsHis

@end


@implementation HK_AllTagsCircles

@end


@implementation HK_AllTagsRecommends

@end


