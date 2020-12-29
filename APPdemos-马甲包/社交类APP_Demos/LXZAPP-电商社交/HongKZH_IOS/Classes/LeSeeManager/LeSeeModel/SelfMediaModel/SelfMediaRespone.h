//
//Created by ESJsonFormatForMac on 18/09/15.
//

#import "HKBaseModelRespone.h"

@class SelfMediaDatas,SelfMediaModelList,GetMediaAdvAdvByIdRespone;
@interface SelfMediaRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) SelfMediaDatas *data;


@end
@interface SelfMediaDatas : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSMutableArray<SelfMediaModelList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface SelfMediaModelList : NSObject

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

@property (nonatomic, copy)NSString *vodeoPalyId;

@property (nonatomic,assign) BOOL isCity;

@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *respone;

@property (nonatomic,assign) NSInteger totalMoney;

@property (nonatomic,assign) int type;
@end

