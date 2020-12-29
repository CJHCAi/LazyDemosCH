//
//Created by ESJsonFormatForMac on 18/08/24.
//

#import <Foundation/Foundation.h>

@class LEFriendSearchModelData,CirclesModel,FriendsModel;
@interface LEFriendSearchModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) LEFriendSearchModelData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface LEFriendSearchModelData : NSObject

@property (nonatomic, strong) NSArray<CirclesModel *> *circles;

@property (nonatomic, strong) NSArray<FriendsModel *> *friends;
@property (nonatomic, strong)NSArray *messages;
@end

@interface CirclesModel : NSObject

@property (nonatomic, assign) NSInteger userCount;

@property (nonatomic, copy) NSString *circleName;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *circleId;

@property (nonatomic, copy) NSString *categoryName;

@end

@interface FriendsModel : NSObject

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@end

