//
//Created by ESJsonFormatForMac on 18/10/11.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
#import "HKLuckyBurstListRespone.h"
@class LuckyBurstDetailData,LuckyBurstDetaiAdvs;
@interface HKluckyBurstDetailRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) LuckyBurstDetailData *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface LuckyBurstDetailData : NSObject

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *burstCouponId;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, strong) NSArray<LuckyBurstDetaiAdvs*> *advs;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) NSInteger totalNum;

@property (nonatomic, assign) NSInteger pintegral;

@property (nonatomic, assign) NSInteger userCount;

@property (nonatomic, assign) double integral;;

@property (nonatomic,assign) NSInteger sortDate;
@property (nonatomic,assign) NSInteger currentHour;

@property (nonatomic, copy)NSString *currentTime;
@property (nonatomic,assign) NSInteger currentTimeStamp;
@property (nonatomic,assign) NSInteger beginDate;
@property (nonatomic,assign) NSInteger endDate;
@property (nonatomic, strong) NSArray<LuckyBurstListFriend *> *list;

@property (nonatomic, strong) LuckyBurstListFriend *u;

@property (nonatomic, assign) NSInteger activityStocks;

@property (nonatomic, assign) NSInteger lastStocks;

@end





@interface LuckyBurstDetaiAdvs : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *imgSrc;
@property (nonatomic, copy)NSString *luckyBurstAdvId;
@property (nonatomic, copy)NSString *coverImgSrc;
 //标题 imgSrc 视频文件 luckyBurstAdvId 广告id coverImgSrc 封面
@end
