//
//Created by ESJsonFormatForMac on 18/06/09.
//

#import <Foundation/Foundation.h>

@class getChinaListData,getChinaListCities,getChinaListAreas,getChinaListProvinces;
@interface getChinaList : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) getChinaListData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface getChinaListData : NSObject

@property (nonatomic, strong) NSMutableArray<getChinaListCities *> *cities;

@property (nonatomic, strong) NSMutableArray<getChinaListAreas *> *areas;

@property (nonatomic, strong) NSMutableArray<getChinaListProvinces *> *provinces;

@end

@interface getChinaListCities : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *code;

@end

@interface getChinaListAreas : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *code;

@end

@interface getChinaListProvinces : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

