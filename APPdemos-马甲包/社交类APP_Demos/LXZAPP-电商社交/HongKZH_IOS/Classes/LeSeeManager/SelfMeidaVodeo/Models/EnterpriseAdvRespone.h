//
//Created by ESJsonFormatForMac on 18/09/21.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class EnterpriseAdvDatas,RecommendModle,HKAdvDetailsProducts;
@interface EnterpriseAdvRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) EnterpriseAdvDatas *data;

@property (nonatomic,assign) NSInteger videoTime;


@property(nonatomic, assign) BOOL isOpen;
@end
@interface EnterpriseAdvDatas : NSObject

@property (nonatomic, assign) double integral;;

@property (nonatomic, strong) NSArray *recommends;

@property (nonatomic, copy) NSString *circle;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) double integralCount;

@property (nonatomic, copy) NSString *coverLink;

@property (nonatomic, copy) NSString *imgRank;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, assign) NSInteger integra;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, strong) NSMutableArray<HKAdvDetailsProducts *> *products;

@property (nonatomic, copy) NSString *follows;

@property (nonatomic, copy) NSString *officiaVideo;

@property (nonatomic, copy) NSString *imgLinks;

@property (nonatomic, copy) NSString *playCount;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *praiseId;

@property (nonatomic, copy) NSString *collectionId;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *collectionState;

@property (nonatomic, copy) NSString *currencyType;

@property (nonatomic, copy) NSString *praiseState;

@property (nonatomic, copy) NSString *imgNote;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *imgSrc1;

@property (nonatomic, copy) NSString *historyId;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *officiaImgSrc;
@end

@interface RecommendModle : NSObject

@property (nonatomic, copy) NSString *coverLink;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *vedioLength;

@property (nonatomic, copy) NSString *playCount;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *utype;

@end
@interface HKAdvDetailsProducts : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) double integral;;

@end
