//
//Created by ESJsonFormatForMac on 18/07/31.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class HKUserProduct;
@interface HK_UserProductList : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKUserProduct *> *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface HKUserProduct : NSObject

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) BOOL isShow;

@end

