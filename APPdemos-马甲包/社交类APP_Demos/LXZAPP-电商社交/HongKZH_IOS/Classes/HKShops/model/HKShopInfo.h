//
//Created by ESJsonFormatForMac on 18/09/29.
//

#import <Foundation/Foundation.h>

@class HKShopInfoData;
@interface HKShopInfo : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKShopInfoData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKShopInfoData : NSObject

@property (nonatomic, assign) NSInteger products;

@property (nonatomic, assign) NSInteger hots;

@property (nonatomic, assign) NSInteger orders;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, assign) NSInteger news;

@end

