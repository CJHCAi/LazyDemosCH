//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import <Foundation/Foundation.h>

@class HKPriseHotAdvListData,PriseHotAdvListModel;
@interface HKPriseHotAdvListRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKPriseHotAdvListData *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;

@end
@interface HKPriseHotAdvListData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<PriseHotAdvListModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface PriseHotAdvListModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *imgRank;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, assign) NSInteger integralCount;

@property (nonatomic, assign) NSInteger playCount;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *vedioLength;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, assign) NSInteger percentage;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *showType;

@property (nonatomic, assign) NSInteger costCount;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, assign) NSInteger lastCount;

@end

