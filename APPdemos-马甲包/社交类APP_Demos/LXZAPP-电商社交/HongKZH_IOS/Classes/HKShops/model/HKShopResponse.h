//
//Created by ESJsonFormatForMac on 18/09/29.
//

#import <Foundation/Foundation.h>

@class HKShopData;
@interface HKShopResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKShopData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKShopData : NSObject

@property (nonatomic, strong) NSArray *carousels;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger orderCount;

@property (nonatomic, assign) NSInteger collectCount;

@property (nonatomic, assign) NSInteger  isCollect;

@end

