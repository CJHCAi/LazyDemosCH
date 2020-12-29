//
//Created by ESJsonFormatForMac on 18/09/12.
//

#import <Foundation/Foundation.h>
@class HKSubCategoryListRespone;
@class HKUserCategoryListModel;
@interface HKUserCategoryListRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSMutableArray<HKUserCategoryListModel *> *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;

@end
@interface HKUserCategoryListModel : NSObject

@property (nonatomic, assign) NSInteger imgRank;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong)HKSubCategoryListRespone *subCategory;
@end

