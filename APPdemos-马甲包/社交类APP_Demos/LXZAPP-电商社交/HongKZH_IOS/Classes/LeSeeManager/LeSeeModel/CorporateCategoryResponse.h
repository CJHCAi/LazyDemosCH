//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import <Foundation/Foundation.h>

@class CorporateCategoryModel;
@interface CorporateCategoryResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSMutableArray<CorporateCategoryModel *> *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;
@property (nonatomic,assign) BOOL isOpen;
@end
@interface CorporateCategoryModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy)NSString *labelColor;
@end

