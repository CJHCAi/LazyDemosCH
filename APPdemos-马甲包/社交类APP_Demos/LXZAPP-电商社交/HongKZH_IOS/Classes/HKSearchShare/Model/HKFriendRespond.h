//
//Created by ESJsonFormatForMac on 18/08/28.
//

#import <Foundation/Foundation.h>
#import "ZSDBBaseModel.h"
@class HKFriendListModel,HKFriendModel;
@interface HKFriendRespond : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKFriendListModel *> *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;
@end
@interface HKFriendListModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<HKFriendModel *> *list;

@end

@interface HKFriendModel : ZSDBBaseModel

@property (nonatomic, copy) NSString *letter;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@end

