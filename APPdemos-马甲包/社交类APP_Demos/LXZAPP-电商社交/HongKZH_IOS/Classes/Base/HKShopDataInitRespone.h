//
//Created by ESJsonFormatForMac on 18/10/08.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class ShopDatas,AllmediashopcategorysInit,MediaareasInits,SystemshopcategorysInit;
@interface HKShopDataInitRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) ShopDatas *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface ShopDatas : NSObject

@property (nonatomic, strong) NSArray<AllmediashopcategorysInit *> *allMediaShopCategorys;

@property (nonatomic, strong) NSArray<MediaareasInits *> *mediaAreas;

@property (nonatomic, strong) NSArray<SystemshopcategorysInit *> *systemShopCategorys;

@property (nonatomic, strong)NSArray *areasArray;

@end

@interface AllmediashopcategorysInit : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *mediaCategoryId;

@end

@interface MediaareasInits : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) BOOL isNewSelect;
@property (nonatomic, strong)NSMutableArray *provinceArray;
@end

@interface SystemshopcategorysInit : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *ID;

@end

