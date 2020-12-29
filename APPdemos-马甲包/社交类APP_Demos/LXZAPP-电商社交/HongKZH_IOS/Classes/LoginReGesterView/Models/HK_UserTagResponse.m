//
//Created by ESJsonFormatForMac on 18/09/12.
//

#import "HK_UserTagResponse.h"
@implementation HK_UserTagResponse

@end

@implementation UserTagData

+ (NSDictionary *)objectClassInArray{
    return @{@"systemlabels" : [HK_Systemlabels class]};
}

@end


@implementation HK_Systemlabels

+ (NSDictionary *)objectClassInArray{
    return @{@"childrenlabels" : [HK_Childrenlabels class]};
}

@end


@implementation HK_Childrenlabels

@end


