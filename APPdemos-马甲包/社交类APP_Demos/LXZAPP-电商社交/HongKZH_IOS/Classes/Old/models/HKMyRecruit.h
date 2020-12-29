//
//Created by ESJsonFormatForMac on 18/08/16.
//

#import <Foundation/Foundation.h>

@class HKMyRecruitData,HKMyRecruitList;
@interface HKMyRecruit : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyRecruitData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMyRecruitData : NSObject

@property (nonatomic, assign) NSInteger recruitCount;

@property (nonatomic, assign) NSInteger collectionCount;

@property (nonatomic, assign) NSInteger deliveryCount;

@property (nonatomic, copy) NSString *enterpriseId;

@property (nonatomic, strong) NSArray<HKMyRecruitList *> *recruits;

@end

@interface HKMyRecruitList : NSObject

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *recruitId;

@property (nonatomic, copy) NSString *experience;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *state;

@end

