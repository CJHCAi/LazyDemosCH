//
//Created by ESJsonFormatForMac on 18/09/25.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class AdvCommentsByCommentIdDatas;
@interface HKAdvCommentsByCommentIdRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) AdvCommentsByCommentIdDatas *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface AdvCommentsByCommentIdDatas : NSObject

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

