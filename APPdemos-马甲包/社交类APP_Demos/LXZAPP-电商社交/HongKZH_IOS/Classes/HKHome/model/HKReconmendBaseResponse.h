//
//Created by ESJsonFormatForMac on 18/10/09.
//

#import <Foundation/Foundation.h>

@class HKRecommendBaseData,HKRecommendListData;
@interface HKReconmendBaseResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKRecommendBaseData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKRecommendBaseData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKRecommendListData *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKRecommendListData : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *coverImgHeight;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *coverImgWidth;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *rewardCount;

@property (nonatomic, assign) NSInteger advType;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, assign)NSInteger type;

@property (nonatomic,assign) NSInteger  totalMoney;
@end

