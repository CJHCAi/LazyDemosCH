//
//Created by ESJsonFormatForMac on 18/10/26.
//

#import "HKBaseModelRespone.h"
@class HKFreightListData,HKFreightListSublist;
@interface HKFreightListRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKFreightListData *> *data;


//@property (nonatomic, assign) NSInteger code;

@end
@interface HKFreightListData : NSObject

@property (nonatomic, assign) NSInteger addPiece;

@property (nonatomic, copy) NSString *freightId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, assign) NSInteger addMoney;

@property (nonatomic, copy) NSString *isExcept;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, strong) NSMutableArray<HKFreightListSublist *> *sublist;

@property (nonatomic, assign) NSInteger piece;

@property (nonatomic, assign) NSInteger money;

@property (nonatomic, copy) NSString *isSystem;


@property (nonatomic,assign) BOOL isHasNotInput;


-(void)getParameterSuccess:(void (^)(NSDictionary*parameter,NSMutableArray*uplodaArray))success;
-(NSArray*)allSelectPeovince:(NSString*)idString;
@end

@interface HKFreightListSublist : NSObject

@property (nonatomic, assign) NSInteger addPiece;

@property (nonatomic, copy) NSString *freightId;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, assign) NSInteger addMoney;

@property (nonatomic, copy) NSString *areafreightId;

@property (nonatomic, assign) NSInteger piece;

@property (nonatomic, assign) NSInteger money;

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy)NSString *notInput;

@property (nonatomic,assign) BOOL isHasNotInput;
@end

