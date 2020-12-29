//
//Created by ESJsonFormatForMac on 18/08/29.
//

#import <Foundation/Foundation.h>

@class HKMyGoodsData,HKMyGoodsModel;
@interface HKMyGoodsRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyGoodsData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMyGoodsData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKMyGoodsModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKMyGoodsModel : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, assign) NSInteger daySales;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) NSInteger dayVisitor;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger orderNum;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, assign) NSInteger money;

@property(nonatomic, assign) NSInteger isupper;

@property(nonatomic, assign) BOOL isFormSelf;

@end

