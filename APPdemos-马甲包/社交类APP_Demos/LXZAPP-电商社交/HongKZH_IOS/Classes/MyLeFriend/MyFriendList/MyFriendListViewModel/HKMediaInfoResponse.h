//
//Created by ESJsonFormatForMac on 18/10/13.
//

#import <Foundation/Foundation.h>

@class HKmediaInfoBaseData,HKmediaInfoFollows,HKMediainfoAlbums,HKMediaCicleData,HKMediaInfoData,HKmediaDynamics,HKUSerTag;
@interface HKMediaInfoResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKmediaInfoBaseData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKmediaInfoBaseData : NSObject

@property (nonatomic, copy) NSString *loginTime;

@property (nonatomic, strong) NSArray <HKUSerTag *>*labels;

@property (nonatomic, strong) NSArray<HKMediainfoAlbums *> *albums;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, assign) NSInteger dynamicCounts;

@property (nonatomic, copy) NSString *constellation;

@property (nonatomic, copy) NSString *loginAddress;

@property (nonatomic, strong) NSArray<HKmediaInfoFollows *> *follows;

@property (nonatomic, assign) NSInteger circleCounts;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger followCounts;

@property (nonatomic, strong) NSArray<HKMediaInfoData *> *infos;

@property (nonatomic, copy) NSString *occupation;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, strong) NSArray<HKMediaCicleData *> *circles;

@property (nonatomic, assign) NSInteger fans;

@property (nonatomic, strong) NSArray<HKmediaDynamics *> *dynamics;

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *located;

@property (nonatomic, copy) NSString *friendId;

@end

@interface HKmediaInfoFollows : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;

@end

@interface HKMediainfoAlbums : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@end

@interface HKMediaCicleData : NSObject

@property (nonatomic, copy) NSString *circleName;

@property (nonatomic, assign) NSInteger circleCount;

@property (nonatomic, copy) NSString *circleId;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *categoryName;

@end

@interface HKMediaInfoData : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *ID;

@end

@interface HKmediaDynamics : NSObject

@property (nonatomic, copy) NSString *coverImgSrc;

@end

@interface HKUSerTag : NSObject

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString *ID;

@end

