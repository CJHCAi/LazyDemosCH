//
//Created by ESJsonFormatForMac on 18/10/03.
//

#import <Foundation/Foundation.h>

@class HKCollageBaseData,HKCollageBaseList;
@interface HKCollagedResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKCollageBaseData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKCollageBaseData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKCollageBaseList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKCollageBaseList : NSObject

@property (nonatomic, assign) NSInteger orders;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, assign) NSInteger pintegral;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, copy) NSString *collageCouponId;

@property (nonatomic, assign) double integral;;

@property (nonatomic, assign) NSInteger num;

@end

