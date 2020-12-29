//
//Created by ESJsonFormatForMac on 18/08/27.
//

#import <Foundation/Foundation.h>

@class HKFriendM,FriendList;
@interface HKRecommendFansModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKFriendM *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKFriendM : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<FriendList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface FriendList : NSObject

@property (nonatomic, assign) NSInteger gcount;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) NSInteger fcount;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *name;

@property(nonatomic, assign) int attentionType;
@end

