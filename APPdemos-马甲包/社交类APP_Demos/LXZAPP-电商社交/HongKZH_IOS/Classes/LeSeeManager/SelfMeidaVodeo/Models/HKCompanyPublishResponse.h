//
//Created by ESJsonFormatForMac on 18/10/29.
//

#import <Foundation/Foundation.h>

@class HKCompanyPublishData,HKCompanyPublishList;
@interface HKCompanyPublishResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKCompanyPublishData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKCompanyPublishData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKCompanyPublishList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKCompanyPublishList : NSObject

@property (nonatomic, copy) NSString *advId;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *vedioLength;

@property (nonatomic, copy) NSString *playCount;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *createDate;

@end

