//
//Created by ESJsonFormatForMac on 18/10/13.
//

#import <Foundation/Foundation.h>

@class HKFriendShopData,HKFrindShopList;
@interface HKFrindShopResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKFriendShopData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKFriendShopData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKFrindShopList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKFrindShopList : NSObject

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, copy) NSString *createDate;

@end

