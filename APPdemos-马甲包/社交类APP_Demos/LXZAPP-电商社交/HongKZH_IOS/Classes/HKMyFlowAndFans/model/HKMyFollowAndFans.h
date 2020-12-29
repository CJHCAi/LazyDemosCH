//
//Created by ESJsonFormatForMac on 18/08/09.
//

#import <Foundation/Foundation.h>

@class HKMyFollowAndFansData,HKMyFollowAndFansList;
@interface HKMyFollowAndFans : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyFollowAndFansData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMyFollowAndFansData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKMyFollowAndFansList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKMyFollowAndFansList : NSObject

@property (nonatomic, assign) NSInteger gcount;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) NSInteger fcount;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *name;

//private 关注状态
@property (nonatomic, assign, getter=isAttention) BOOL attention;

@end

