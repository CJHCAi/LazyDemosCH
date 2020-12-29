//
//Created by ESJsonFormatForMac on 18/09/08.
//

#import <Foundation/Foundation.h>

@class MyRepliesPostsList,MyRepliesPostsListModel,MyRepliesPostsModel;
@interface HKMyRepliesPostsRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) MyRepliesPostsList *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;
@end
@interface MyRepliesPostsList : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<MyRepliesPostsListModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface MyRepliesPostsListModel : NSObject

@property (nonatomic, copy) NSString *postId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<MyRepliesPostsModel *> *comments;

@end

@interface MyRepliesPostsModel : NSObject

@property (nonatomic, copy) NSString *ruserId;

@property (nonatomic, copy) NSString *postId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *userName;

@end

