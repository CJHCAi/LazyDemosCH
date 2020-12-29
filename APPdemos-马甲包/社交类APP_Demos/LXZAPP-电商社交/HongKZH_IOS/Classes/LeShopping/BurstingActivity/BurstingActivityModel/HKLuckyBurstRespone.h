//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class LuckyBurstData,LuckyBurstTypes,LuckyBurstCarousels;
@interface HKLuckyBurstRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) LuckyBurstData *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface LuckyBurstData : NSObject

@property (nonatomic, strong) NSArray<LuckyBurstTypes *> *types;

@property (nonatomic, strong) NSArray<LuckyBurstCarousels *> *carousels;

@end

@interface LuckyBurstTypes : NSObject

@property (nonatomic, copy) NSString *typeId;

@property (nonatomic, assign) NSInteger currentHour;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, assign) NSInteger endDate;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, assign) NSInteger sortDate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger beginDate;

@end

@interface LuckyBurstCarousels : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *model;

@property (nonatomic, assign) NSInteger imgRank;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *specialId;

@end

