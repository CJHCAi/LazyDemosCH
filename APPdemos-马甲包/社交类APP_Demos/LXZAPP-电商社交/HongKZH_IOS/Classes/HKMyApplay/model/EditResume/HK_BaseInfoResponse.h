//
//Created by ESJsonFormatForMac on 18/09/17.
//

#import <Foundation/Foundation.h>

@class HK_UserRecruitData;
@interface HK_BaseInfoResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HK_UserRecruitData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HK_UserRecruitData : NSObject

@property (nonatomic, copy) NSString *salaryName;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *marital;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *locatedName;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *workNatureName;

@property (nonatomic, copy) NSString *workNature;

@property (nonatomic, copy) NSString *constellationName;

@property (nonatomic, copy) NSString *workingLife;

@property (nonatomic, copy) NSString *maritalName;

@property (nonatomic, copy) NSString *ageName;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *monthlyIncome;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *sexName;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *height;

@property (nonatomic, copy) NSString *monthlyIncomeName;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, copy) NSString *place;

@property (nonatomic, copy) NSString *located;

@property (nonatomic, copy) NSString *placeName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *occupation;

@property (nonatomic, copy) NSString *hobby;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *stateName;

@property (nonatomic, copy) NSString *timeToPostName;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *functions;

@property (nonatomic, copy) NSString *timeToPost;

@property (nonatomic, copy) NSString *resumeId;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *weight;

@property (nonatomic, copy) NSString *constellation;

@property (nonatomic, copy) NSString *workingLifeName;

@property (nonatomic, copy) NSString *functionsName;

@property (nonatomic, assign, readonly) NSString *completeProgress;
@end

