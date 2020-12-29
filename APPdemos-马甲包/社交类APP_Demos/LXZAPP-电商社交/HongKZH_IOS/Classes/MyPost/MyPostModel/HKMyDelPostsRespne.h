//
//Created by ESJsonFormatForMac on 18/09/08.
//

#import <Foundation/Foundation.h>

@class HKMyDelPostsData,HKMyDelPostsModel;
@interface HKMyDelPostsRespne : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyDelPostsData *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;
@end
@interface HKMyDelPostsData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKMyDelPostsModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKMyDelPostsModel : NSObject

@property (nonatomic, copy) NSString *postId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *createDate;

@end

