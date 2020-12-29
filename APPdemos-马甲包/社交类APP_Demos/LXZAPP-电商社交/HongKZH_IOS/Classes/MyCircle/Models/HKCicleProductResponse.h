//
//Created by ESJsonFormatForMac on 18/10/30.
//

#import <Foundation/Foundation.h>

@class HKCicleData,HKCicleUserData,HKCicleIMage,HKCicleSku;
@interface HKCicleProductResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKCicleData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKCicleData : NSObject

@property (nonatomic, strong) NSArray<HKCicleIMage *> *images;

@property (nonatomic, copy) NSString *freightId;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *mediaUserId;

@property (nonatomic, assign) NSInteger freight;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) HKCicleUserData *user;

@property (nonatomic, copy) NSString *descript;

@property (nonatomic, assign) double integral;;

@property (nonatomic, strong) NSArray<HKCicleSku *> *skus;

@end

@interface HKCicleUserData : NSObject

@property (nonatomic, copy) NSString *loginTime;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *name;

@end

@interface HKCicleIMage : NSObject

@property (nonatomic, copy) NSString *imgId;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *productId;

@end

@interface HKCicleSku : NSObject

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *model;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *skuId;

@end

