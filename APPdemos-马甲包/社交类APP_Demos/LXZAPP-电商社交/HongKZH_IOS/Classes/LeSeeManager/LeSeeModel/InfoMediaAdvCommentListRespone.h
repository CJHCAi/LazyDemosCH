//
//Created by ESJsonFormatForMac on 18/09/25.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class InfoMediaAdvCommentListDatas,InfoMediaAdvCommentListModels;
@interface InfoMediaAdvCommentListRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) InfoMediaAdvCommentListDatas *data;


@end
@interface InfoMediaAdvCommentListDatas : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<InfoMediaAdvCommentListModels *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface InfoMediaAdvCommentListModels : NSObject

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

