//
//Created by ESJsonFormatForMac on 18/10/13.
//

#import "HKMediaInfoResponse.h"
@implementation HKMediaInfoResponse

@end

@implementation HKmediaInfoBaseData

+ (NSDictionary *)objectClassInArray{
    return @{@"follows" : [HKmediaInfoFollows class], @"albums" : [HKMediainfoAlbums class], @"circles" : [HKMediaCicleData class], @"infos" : [HKMediaInfoData class], @"dynamics" : [HKmediaDynamics class],@"labels":[HKUSerTag class]};
}

@end


@implementation HKmediaInfoFollows

@end


@implementation HKMediainfoAlbums

@end


@implementation HKMediaCicleData

@end


@implementation HKMediaInfoData

@end


@implementation HKmediaDynamics

@end
@implementation HKUSerTag




@end


