//
//Created by ESJsonFormatForMac on 18/08/15.
//

#import <Foundation/Foundation.h>

/**
 简历预览
 */
@class HKMyResumePreviewData,HKMyResumePreviewEducationals,HKMyResumePreviewExperiences,HKMyResumePreviewImgs;
@interface HKMyResumePreview : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMyResumePreviewData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMyResumePreviewData : NSObject

@property (nonatomic, copy) NSString *corporateName;

@property (nonatomic, strong) NSArray<HKMyResumePreviewEducationals *> *educationals;

@property (nonatomic, copy) NSString *salaryName;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *marital;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *locatedName;

@property (nonatomic, copy) NSString *workNatureName;

@property (nonatomic, copy) NSString *salary;

@property (nonatomic, copy) NSString *constellationName;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *workNature;

@property (nonatomic, copy) NSString *workingLife;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *maritalName;

@property (nonatomic, strong) NSArray<HKMyResumePreviewImgs *> *imgs;

@property (nonatomic, copy) NSString *ageName;

@property (nonatomic, strong) NSArray<HKMyResumePreviewExperiences *> *experiences;

@property (nonatomic, copy) NSString *recruitState;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *monthlyIncome;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *sexName;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *height;

@property (nonatomic, copy) NSString *monthlyIncomeName;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *place;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, copy) NSString *collectionState;

@property (nonatomic, copy) NSString *located;

@property (nonatomic, copy) NSString *hobby;

@property (nonatomic, copy) NSString *occupation;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *stateName;

@property (nonatomic, copy) NSString *recruitName;

@property (nonatomic, copy) NSString *placeName;

@property (nonatomic, copy) NSString *timeToPostName;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *functions;

@property (nonatomic, copy) NSString *timeToPost;

@property (nonatomic, copy) NSString *resumeId;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *weight;

@property (nonatomic, copy) NSString *constellation;

@property (nonatomic, copy) NSString *functionsName;

@property (nonatomic, copy) NSString *workingLifeName;

@end

@interface HKMyResumePreviewEducationals : NSObject

@property (nonatomic, copy) NSString *resumeId;

@property (nonatomic, copy) NSString *major;

@property (nonatomic, copy) NSString *educatioId;

@property (nonatomic, copy) NSString *graduate;

@property (nonatomic, copy) NSString *educationName;

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *enrolmentTime;

@property (nonatomic, copy) NSString *graduationTime;

@property (nonatomic, assign) NSInteger lineStyle; //1--首个 2--中间 3--最后一个

@end

@interface HKMyResumePreviewExperiences : NSObject

@property (nonatomic, copy) NSString *resumeId;

@property (nonatomic, copy) NSString *corporateName;

@property (nonatomic, copy) NSString *outDate;

@property (nonatomic, copy) NSString *experienceId;

@property (nonatomic, copy) NSString *job;

@property (nonatomic, copy) NSString *entryDate;

@property (nonatomic, copy) NSString *workContent;

@property (nonatomic, assign) NSInteger lineStyle; //1--首个 2--中间 3--最后一个

@end

@interface HKMyResumePreviewImgs : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@end

