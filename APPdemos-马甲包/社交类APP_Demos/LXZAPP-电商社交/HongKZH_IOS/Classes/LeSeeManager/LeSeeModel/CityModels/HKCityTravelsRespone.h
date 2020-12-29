//
//Created by ESJsonFormatForMac on 18/10/20.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class HKCityTravelsData;
@interface HKCityTravelsRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKCityTravelsData *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface HKCityTravelsData : NSObject

@property (nonatomic, copy) NSString *collectionCount;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *coverImgHeight;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *isweb;

@property (nonatomic, strong) NSArray *products;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *praiseId;

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, copy) NSString *playCount;

@property (nonatomic, copy) NSString *collectionId;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *cityAdvId;

@property (nonatomic, copy) NSString *note;

@property (nonatomic, copy) NSString *collectionState;

@property (nonatomic, copy) NSString *praiseState;

@property (nonatomic, copy) NSString *coverImgWidth;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *utype;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *commentCount;

@property (nonatomic, copy) NSString *rewardCount;

@end

