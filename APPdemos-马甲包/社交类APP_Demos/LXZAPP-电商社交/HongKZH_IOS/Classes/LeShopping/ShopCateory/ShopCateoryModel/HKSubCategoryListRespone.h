//
//Created by ESJsonFormatForMac on 18/09/29.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class SubCategoryListDatas,SubCategorysCategorys;
@interface HKSubCategoryListRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) SubCategoryListDatas *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface SubCategoryListDatas : NSObject

@property (nonatomic, strong) NSArray<SubCategorysCategorys *> *categorys;

@property (nonatomic, copy) NSString *imgSrc;


@property (nonatomic, copy)NSString *name;
@end

@interface SubCategorysCategorys : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *categoryId;

@end

