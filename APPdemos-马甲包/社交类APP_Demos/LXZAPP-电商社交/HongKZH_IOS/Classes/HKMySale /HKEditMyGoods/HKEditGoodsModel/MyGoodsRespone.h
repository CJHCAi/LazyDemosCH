//
//Created by ESJsonFormatForMac on 18/08/29.
//

#import <Foundation/Foundation.h>

@class MyGoodsInfo,ImagesModel,SkusModel;
@interface MyGoodsRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) MyGoodsInfo *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface MyGoodsInfo : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *freightName;

@property (nonatomic, copy) NSString *freightId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *descript;

@property (nonatomic, strong) NSMutableArray<SkusModel *> *skus;

@property (nonatomic, strong) NSMutableArray<ImagesModel *> *images;
@property (nonatomic, strong)NSMutableArray<ImagesModel *> *deleteImage;
@property (nonatomic, strong)NSMutableArray *addImage;
@property (nonatomic, strong)NSMutableArray *deleteSku;
@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *mediaUserId;

@property (nonatomic, copy) NSString *categoryId;
-(NSDictionary*)getPostParameter;
@end

@interface ImagesModel : NSObject

@property (nonatomic, copy) NSString *imgId;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, strong)UIImage *image;
@end

@interface SkusModel : NSObject

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *model;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *skuId;

@end

