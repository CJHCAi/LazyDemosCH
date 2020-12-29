//
//Created by ESJsonFormatForMac on 18/09/29.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class CategoryProductListPageModel,CategoryProductListModels;
@interface CategoryProductListRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) CategoryProductListPageModel *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface CategoryProductListPageModel : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<CategoryProductListModels *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface CategoryProductListModels : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger couponCount;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) double integral;

@property (nonatomic, copy) NSString *subtitle;

@end

