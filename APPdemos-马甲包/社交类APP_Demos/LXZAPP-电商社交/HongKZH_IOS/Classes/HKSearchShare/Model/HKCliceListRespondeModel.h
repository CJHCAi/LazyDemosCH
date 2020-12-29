//
//Created by ESJsonFormatForMac on 18/08/28.
//

#import <Foundation/Foundation.h>
#import "ZSDBBaseModel.h"
@class HKCliceListData,HKClicleListModel;
@interface HKCliceListRespondeModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKCliceListData *> *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;

@end
@interface HKCliceListData : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<HKClicleListModel *> *list;

@end

@interface HKClicleListModel : ZSDBBaseModel

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *userCount;

@property (nonatomic, copy) NSString *circleName;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *circleId;

@property (nonatomic, copy) NSString *letter;

@end

