//
//Created by ESJsonFormatForMac on 18/08/11.
//

#import <Foundation/Foundation.h>

@class HKMyApplyData;
@interface HKMyApply : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyApplyData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMyApplyData : NSObject

@property (nonatomic, copy) NSString *isOpen;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *resumeId;

@property (nonatomic, copy) NSString *corporateName;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, copy) NSString *sexName;

@property (nonatomic, copy) NSString *functionsName;

@property (nonatomic, copy) NSString *functions;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *name;

@end

