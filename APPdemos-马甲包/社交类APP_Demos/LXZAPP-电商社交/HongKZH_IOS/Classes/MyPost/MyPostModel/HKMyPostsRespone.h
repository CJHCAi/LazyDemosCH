//
//Created by ESJsonFormatForMac on 18/09/07.
//

#import <Foundation/Foundation.h>

@class HKMypostList,HKMyPostModel,StaticadvModel;
@interface HKMyPostsRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMypostList *data;

@property (nonatomic, copy) NSString* code;

@property (nonatomic,assign) BOOL responeSuc;
@end
@interface HKMypostList : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKMyPostModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKMyPostModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, assign) MyPostType model;

@property (nonatomic, copy) NSString *circleId;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *modelName;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger commitCount;

@property (nonatomic, copy) NSString *postId;

@property (nonatomic, strong) NSArray *imgList;

@property (nonatomic, copy) NSString *modelId;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic,assign) BOOL isShowLabel;

@property (nonatomic, copy) NSString *isPraise;


@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *ppid;

@property (nonatomic, copy) NSString *isNotice;
@property (nonatomic, copy) NSString *isTop;

@property (nonatomic, strong) StaticadvModel *staticAdv;

@property (nonatomic, copy) NSString *isSelected;
@end
@interface StaticadvModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *coverImgHeight;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *vedioLength;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *coverImgWidth;

@property (nonatomic, copy) NSString *imgNote;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imgLinks;

@property (nonatomic, copy) NSString *utype;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *imgRank;

@end


