//
//Created by ESJsonFormatForMac on 18/06/09.
//

#import "getChinaList.h"
@implementation getChinaList
MJExtensionCodingImplementation

@end

@implementation getChinaListData
MJExtensionCodingImplementation
+ (NSDictionary *)objectClassInArray{
    return @{@"cities" : [getChinaListCities class], @"areas" : [getChinaListAreas class], @"provinces" : [getChinaListProvinces class]};
}


@end


@implementation getChinaListCities
MJExtensionCodingImplementation

@end


@implementation getChinaListAreas

MJExtensionCodingImplementation
@end


@implementation getChinaListProvinces
MJExtensionCodingImplementation

@end


