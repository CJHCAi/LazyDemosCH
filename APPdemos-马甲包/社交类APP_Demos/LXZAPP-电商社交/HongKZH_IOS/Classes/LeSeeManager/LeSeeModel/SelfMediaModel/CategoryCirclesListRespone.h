//
//Created by ESJsonFormatForMac on 18/09/15.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class CategoryCirclesListDatas,CategoryCirclesListModel;
@interface CategoryCirclesListRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) CategoryCirclesListDatas *data;

@end
@interface CategoryCirclesListDatas : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<CategoryCirclesListModel *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface CategoryCirclesListModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *userCount;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *circleId;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *coverImgHeight;

@property (nonatomic, copy) NSString *coverImgWidth;

@property (nonatomic, copy) NSString *uName;

@end

