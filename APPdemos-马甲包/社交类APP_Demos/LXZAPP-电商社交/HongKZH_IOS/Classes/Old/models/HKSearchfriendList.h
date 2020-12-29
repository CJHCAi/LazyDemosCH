//
//Created by ESJsonFormatForMac on 18/08/20.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class FriendData;
@interface HKSearchfriendList : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<FriendData *> *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface FriendData : NSObject

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@end

