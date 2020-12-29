//
//Created by ESJsonFormatForMac on 18/09/25.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class MediaAdvCommentReplyListDatas,MediaAdvCommentReplyListModels;
@interface MediaAdvCommentReplyListRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) MediaAdvCommentReplyListDatas *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface MediaAdvCommentReplyListDatas : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<MediaAdvCommentReplyListModels *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface MediaAdvCommentReplyListModels : NSObject

@property (nonatomic, copy) NSString *ruName;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *commentId;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *createDate;

@end

