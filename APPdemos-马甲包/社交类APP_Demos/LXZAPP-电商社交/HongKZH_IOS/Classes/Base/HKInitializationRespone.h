//
//Created by ESJsonFormatForMac on 18/09/14.
//

#import <Foundation/Foundation.h>

@class InitializationDatas,AllmediacategorysModel,AllcategorysModel,RecruitcategorysModel,DictModel,RecruitindustrysModel;
@interface HKInitializationRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) InitializationDatas *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;
@end
@interface InitializationDatas : NSObject

@property (nonatomic, strong) NSMutableArray<AllcategorysModel *> *allCategorys;

@property (nonatomic, strong) NSArray<AllmediacategorysModel *> *allMediaCategorys;

@property (nonatomic, strong) NSArray<RecruitcategorysModel *> *recruitCategorys;

@property (nonatomic, strong) NSArray<DictModel *> *dict;

@property (nonatomic, strong) NSArray<RecruitindustrysModel *> *recruitIndustrys;

@end

@interface AllmediacategorysModel : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, assign) NSInteger imgRank;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *name;

@end

@interface AllcategorysModel : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *parentId;

@end

@interface RecruitcategorysModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *ID;

@end

@interface DictModel : NSObject

@property (nonatomic, copy) NSString *label;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *Description;

@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, copy) NSString *type;

@end

@interface RecruitindustrysModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *ID;

@end

