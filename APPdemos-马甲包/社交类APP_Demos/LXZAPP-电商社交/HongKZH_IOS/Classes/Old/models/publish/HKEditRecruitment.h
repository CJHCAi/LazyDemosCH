//
//Created by ESJsonFormatForMac on 18/08/17.
//

#import <Foundation/Foundation.h>

@class HKEditRecruitmentData;
@interface HKEditRecruitment : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKEditRecruitmentData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKEditRecruitmentData : NSObject

@property (nonatomic, copy) NSString *enterpriseId;

@property (nonatomic, copy) NSString *coverImgSrc;

@end

