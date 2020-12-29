//
//Created by ESJsonFormatForMac on 18/09/30.
//

#import <Foundation/Foundation.h>

@class HKRecmendData,HKRecomendList;
@interface HKRecondShopResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKRecmendData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKRecmendData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKRecomendList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKRecomendList : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger couponCount;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *subtitle;

@end

