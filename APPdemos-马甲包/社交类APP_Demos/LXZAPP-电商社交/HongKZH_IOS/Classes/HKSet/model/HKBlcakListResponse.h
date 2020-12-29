//
//Created by ESJsonFormatForMac on 18/09/29.
//

#import <Foundation/Foundation.h>

@class HKBlackListData,HKBlackList;
@interface HKBlcakListResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKBlackListData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKBlackListData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKBlackList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKBlackList : NSObject

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *name;

@end

