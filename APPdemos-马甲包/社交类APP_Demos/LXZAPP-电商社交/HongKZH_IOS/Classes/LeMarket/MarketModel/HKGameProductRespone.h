//
//Created by ESJsonFormatForMac on 18/10/19.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class HKGameProductData,HKGameProductModel;
@interface HKGameProductRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKGameProductData *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface HKGameProductData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKGameProductModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKGameProductModel : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, assign) NSInteger money;

@property (nonatomic, copy) NSString *isupper;

@end

