//
//Created by ESJsonFormatForMac on 18/09/03.
//

#import <Foundation/Foundation.h>

@class HKExpresModel;
@interface HKExpresListRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKExpresModel *> *data;

@property (nonatomic, copy) NSString* code;

@property (nonatomic,assign) BOOL responeSuc;
@end
@interface HKExpresModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *abbreviation;

@property (nonatomic, copy)NSString *expresNum;
@end

