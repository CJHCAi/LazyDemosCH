//
//Created by ESJsonFormatForMac on 18/09/20.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class AdvertisementCityData,AdvertisementsCategorys;
@interface HKAdvertisementCityInfo : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) AdvertisementCityData *data;


@end
@interface AdvertisementCityData : NSObject

@property (nonatomic, strong) NSArray<AdvertisementsCategorys *> *categorys;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *traditionalVideo;

@property (nonatomic, copy) NSString *officialCoverImgSrc;

@property (nonatomic, copy) NSString *traditionalCoverImgSrc;

@property (nonatomic, copy) NSString *officialVideo;

@end

@interface AdvertisementsCategorys : NSObject

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *categoryName;

@end

