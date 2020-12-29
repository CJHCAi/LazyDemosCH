//
//Created by ESJsonFormatForMac on 18/10/27.
//

#import <Foundation/Foundation.h>

@class HKReCommentData,HKReCommentList;
@interface HKReCommentListResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKReCommentData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKReCommentData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKReCommentList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKReCommentList : NSObject

@property (nonatomic, copy) NSString *ruName;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *commentId;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *createDate;
//一级评论内容
@property (nonatomic, copy) NSString * ucontent;


@end

