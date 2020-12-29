//
//Created by ESJsonFormatForMac on 18/09/12.
//

#import <Foundation/Foundation.h>

@class HKMyPraiseData,HkPraiseModel;
@interface HKMyPraiseRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyPraiseData *data;

@property (nonatomic, copy) NSString* code;

@property (nonatomic,assign) BOOL responeSuc;

@end
@interface HKMyPraiseData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HkPraiseModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HkPraiseModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *coverImgHeight;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *coverImgWidth;

@property (nonatomic, copy) NSString *imgNote;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *rewardCount;

@property (nonatomic, copy) NSString *coverLink;

@property (nonatomic, copy) NSString *imgLinks;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *imgRank;

@end

