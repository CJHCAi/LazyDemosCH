//
//Created by ESJsonFormatForMac on 18/08/06.
//

#import <Foundation/Foundation.h>

@class HKMyVideoData,HKMyVideoList;
@interface HKMyVideo : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyVideoData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMyVideoData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKMyVideoList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKMyVideoList : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *coverImgHeight;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *coverImgWidth;

@property (nonatomic, copy) NSString *imgNote;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *rewardCount;

@property (nonatomic, copy) NSString *coverLink;

@property (nonatomic, copy) NSString *imgLinks;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *imgRank;

@end

