//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class LuckyBurstListData,LuckyBurstListFriend;
@interface HKLuckyBurstListRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) LuckyBurstListData *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface LuckyBurstListData : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, assign) NSInteger userCount;

@property (nonatomic, assign) NSInteger activityStocks;

@property (nonatomic, strong) LuckyBurstListFriend *u;

@property (nonatomic, assign) NSInteger pintegral;

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, copy) NSString *burstCouponId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy)NSMutableArray<LuckyBurstListFriend*>* list;

@property (nonatomic, assign) NSInteger lastStocks;

@property (nonatomic,assign) NSInteger sortDate;
@property (nonatomic,assign) NSInteger currentHour;

@property (nonatomic, copy)NSString *currentTime;
@property (nonatomic,assign) NSInteger currentTimeStamp;
@property (nonatomic,assign) NSInteger beginDate;
@property (nonatomic,assign) NSInteger endDate;

@end

@interface LuckyBurstListFriend : NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *num;
@property (nonatomic, copy)NSString *ranking;
@property (nonatomic, copy)NSString *headImg;
@property (nonatomic, copy)NSString *orderNumber;
@end
