//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import <Foundation/Foundation.h>

@class HKRecommendData,RecommendModel;
@interface HKRecommendRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKRecommendData *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;
@end
@interface HKRecommendData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<RecommendModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface RecommendModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *playCount;

@property (nonatomic, copy) NSString *vedioLength;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *imgNote;

@property (nonatomic, assign) HKSowingModelType type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *coverLink;

@property (nonatomic, copy) NSString *staticAdv;

@property (nonatomic, copy) NSString *utype;

@property (nonatomic, copy) NSString *imgLinks;

@property (nonatomic, copy) NSString *showType;

@property (nonatomic, assign) NSInteger lastIntegralCount;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *imgRank;

@end

