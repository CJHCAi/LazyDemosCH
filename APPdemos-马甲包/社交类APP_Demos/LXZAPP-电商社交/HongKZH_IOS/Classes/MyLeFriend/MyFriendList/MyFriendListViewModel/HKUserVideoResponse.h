//
//Created by ESJsonFormatForMac on 18/10/13.
//

#import <Foundation/Foundation.h>

@class HKUserVideoData,HKUserVideoList;
@interface HKUserVideoResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKUserVideoData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKUserVideoData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKUserVideoList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKUserVideoList : NSObject

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *mediaId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *vedioLength;

@property (nonatomic, copy) NSString *playCount;

@property (nonatomic, copy) NSString *coverImgHeight;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *coverImgWidth;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;

@end

