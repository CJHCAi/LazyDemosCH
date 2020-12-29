//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import "HKNewPerSonTypeResponse.h"
@implementation HKNewPerSonTypeResponse

@end

@implementation HKNewPersonTypeData

+ (NSDictionary *)objectClassInArray{
    return @{@"types" : [HKNewPerSonType class], @"carousels" : [HKNewPesonCorel class]};
}

@end


@implementation HKNewPerSonType

@end


@implementation HKNewPesonCorel

@end


