//
//Created by ESJsonFormatForMac on 18/09/14.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class CityMainDatas,CityMainHostModel,CarouselsModel;
@interface CityMainRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) CityMainDatas *data;

@end
@interface CityMainDatas : NSObject

@property (nonatomic, strong) NSArray<CityMainHostModel *> *hots;

@property (nonatomic, strong) NSArray<CarouselsModel *> *carousels;

@end

@interface CityMainHostModel : NSObject

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *subtitle;

@end

@interface CarouselsModel : NSObject

@property (nonatomic, copy) NSString *imgLinks;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, assign) NSInteger imgRank;

@end

