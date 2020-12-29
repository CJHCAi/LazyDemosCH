//
//Created by ESJsonFormatForMac on 18/09/13.
//

#import <Foundation/Foundation.h>

@class HKMyInfoModel;
@interface HKMyDataRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyInfoModel *data;

@property (nonatomic, copy) NSString* code;
@property (nonatomic,assign) BOOL responeSuc;

@end
@interface HKMyInfoModel : NSObject

@property (nonatomic, assign) NSInteger follows;

@property (nonatomic, assign) NSInteger jobs;

@property (nonatomic, assign) NSInteger afterService;

@property (nonatomic, assign) NSInteger enoughLevelNum;

@property (nonatomic, assign) NSInteger answer;

@property (nonatomic, assign) NSInteger sells;

@property (nonatomic, assign) NSInteger dayIncome;

@property (nonatomic, assign) NSInteger collections;

@property (nonatomic, assign) NSInteger praises;

@property (nonatomic, assign) NSInteger currentLevelNum;

@property (nonatomic, assign) NSInteger orders;

@property (nonatomic, assign) NSInteger fans;

@property (nonatomic, assign) NSInteger carts;

@property (nonatomic, assign) NSInteger task;

@end

