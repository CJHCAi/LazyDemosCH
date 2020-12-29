//
//Created by ESJsonFormatForMac on 18/10/27.
//

#import <Foundation/Foundation.h>

@class HKCommentInfoData;
@interface HKPostCommentInfoResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKCommentInfoData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKCommentInfoData : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *commentCount;

@property (nonatomic, copy) NSString *praiseId;

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *commentId;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *praiseState;

@end

