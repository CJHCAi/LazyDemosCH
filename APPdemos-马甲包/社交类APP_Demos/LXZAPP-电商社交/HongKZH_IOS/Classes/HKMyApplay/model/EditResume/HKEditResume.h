//
//Created by ESJsonFormatForMac on 18/08/13.
//

#import <Foundation/Foundation.h>

@class HKEditResumeData,HKEditResumeDataImgs;
@interface HKEditResume : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKEditResumeData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKEditResumeData : NSObject

@property (nonatomic, copy) NSString *isOpen;

@property (nonatomic, strong) NSArray<HKEditResumeDataImgs *> *imgs;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *complete;

@end

@interface HKEditResumeDataImgs : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *imgSrc;

@end

