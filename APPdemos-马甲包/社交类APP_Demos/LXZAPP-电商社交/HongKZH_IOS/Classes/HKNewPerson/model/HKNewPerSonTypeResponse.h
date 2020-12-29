//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import <Foundation/Foundation.h>

@class HKNewPersonTypeData,HKNewPerSonType,HKNewPesonCorel;
@interface HKNewPerSonTypeResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKNewPersonTypeData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKNewPersonTypeData : NSObject

@property (nonatomic, strong) NSArray<HKNewPerSonType *> *types;

@property (nonatomic, strong) NSArray<HKNewPesonCorel *> *carousels;

@end

@interface HKNewPerSonType : NSObject

@property (nonatomic, copy) NSString *typeId;

@property (nonatomic, assign) NSInteger currentHour;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, assign) NSInteger endDate;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, assign) NSInteger sortDate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger beginDate;

@end

@interface HKNewPesonCorel : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *model;

@property (nonatomic, assign) NSInteger imgRank;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *specialId;

@end

