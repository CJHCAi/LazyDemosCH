//
//Created by ESJsonFormatForMac on 18/10/25.
//

#import <Foundation/Foundation.h>

@class HKPostDetailData;
@interface HKPostDetailResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKPostDetailData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKPostDetailData : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *ppid;

@property (nonatomic, copy) NSString *userCount;

@property (nonatomic, copy) NSString *postId;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *isCircleUser;

@property (nonatomic, copy) NSString *isPostUser;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *isSelected;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *isTop;

@property (nonatomic, copy) NSString *usecircle;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, strong) NSArray *imgList;

@property (nonatomic, copy) NSString *circleId;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *isNotice;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *isPraise;

@end

