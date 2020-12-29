//
//Created by ESJsonFormatForMac on 18/09/25.
//

#import <Foundation/Foundation.h>

@class HK_VideosData,HK_DataVideoList;
@interface HK_VideoHReSponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HK_VideosData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HK_VideosData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HK_DataVideoList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HK_DataVideoList : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *createDate;

@end

