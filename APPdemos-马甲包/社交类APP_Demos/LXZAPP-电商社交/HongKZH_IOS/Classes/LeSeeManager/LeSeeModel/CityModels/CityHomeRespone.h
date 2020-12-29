//
//Created by ESJsonFormatForMac on 18/09/14.
//

#import <Foundation/Foundation.h>

@class CityHomeData,CityHomeModel;
@interface CityHomeRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) CityHomeData *data;

@property (nonatomic, copy) NSString* code;

@property (nonatomic,assign) BOOL responeSuc;

@end
@interface CityHomeData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<CityHomeModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface CityHomeModel : NSObject

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *coverImgHeight;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *coverImgWidth;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *rewardCount;

@property (nonatomic, copy) NSString *utype;

@property (nonatomic, assign) NSInteger advType;

@property (nonatomic, copy) NSString *cityAdvId;

@property (nonatomic, copy) NSString *isweb;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *ID;

@property(nonatomic, assign) NSInteger type;

@property(nonatomic, assign) NSInteger totalMoney;
@end

