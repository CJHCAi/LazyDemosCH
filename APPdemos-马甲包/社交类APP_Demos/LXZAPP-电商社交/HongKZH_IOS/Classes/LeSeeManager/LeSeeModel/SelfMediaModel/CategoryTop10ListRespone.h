//
//Created by ESJsonFormatForMac on 18/09/15.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class CategoryTop10ListModel;
@interface CategoryTop10ListRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<CategoryTop10ListModel *> *data;

@end
@interface CategoryTop10ListModel : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *praiseCount;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *uName;
@property (nonatomic, copy)NSString *categoryName;
@end

