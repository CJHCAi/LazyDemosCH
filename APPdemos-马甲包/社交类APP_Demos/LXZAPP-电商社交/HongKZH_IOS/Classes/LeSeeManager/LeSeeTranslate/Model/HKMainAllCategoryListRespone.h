//
//Created by ESJsonFormatForMac on 18/11/10.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class MainAllCategoryListData;
@interface HKMainAllCategoryListRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSMutableArray<MainAllCategoryListData *> *data;


@end
@interface MainAllCategoryListData : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, assign) NSInteger imgRank;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *name;

@end

