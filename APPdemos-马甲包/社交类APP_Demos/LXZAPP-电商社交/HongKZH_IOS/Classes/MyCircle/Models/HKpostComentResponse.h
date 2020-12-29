//
//Created by ESJsonFormatForMac on 18/10/25.
//

#import <Foundation/Foundation.h>

@class HKPostcommetData,HKCommentList;
@interface HKpostComentResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKPostcommetData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKPostcommetData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKCommentList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKCommentList : NSObject

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

