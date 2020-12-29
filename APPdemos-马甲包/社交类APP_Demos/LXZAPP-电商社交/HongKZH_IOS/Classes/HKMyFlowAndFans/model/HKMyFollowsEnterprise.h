//
//Created by ESJsonFormatForMac on 18/08/09.
//

#import <Foundation/Foundation.h>

@class HKMyFollowsEnterpriseData,HKMyFollowsEnterpriseList;
@interface HKMyFollowsEnterprise : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyFollowsEnterpriseData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMyFollowsEnterpriseData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKMyFollowsEnterpriseList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKMyFollowsEnterpriseList : NSObject

@property (nonatomic, assign) NSInteger fcount;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *enterpriseId;

//private 关注状态
@property (nonatomic, assign, getter=isAttention) BOOL attention;

@end

