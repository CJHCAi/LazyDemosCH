//
//  HK_MyApplyTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKMyApply.h"
#import "HK_jobRecResponse.h"
#import "HKEditResume.h"
#import "HKShieldCompany.h"
#import "HKMyDelivery.h"
#import "HKMyResumePreview.h"
#import "HK_BaseInfoResponse.h"
#import "HK_UserExperienceData.h"
#import "HK_UserEducationalData.h"
#import "HKReseaesInfosViewController.h"
@interface HK_MyApplyTool : NSObject

/***
 *  进入职位详情界面
 */
+(void)pushDetailRecruitInfo:(NSString *)recruitId withCurrentVc:(UIViewController *)controller;
/***
 *  获取我的招聘信息数据
 */
+(void)getUserApplyInfoSuccessBlock:(void(^)(HKMyApplyData *applyData))successResponse failed:(void(^)(NSString * error))msg;

/***
 *  获取职位推荐信息
 */
+(void)getRecommendJobsWithPage:(NSInteger)page SuccessBlock:(void(^)(HK_jobRecResponse *applyData))successResponse failed:(void(^)(NSString * error))msg;


/***
 *  获取编辑简历的基本信息
 */
+(void)getEditResumeSuccessBlock:(void(^)(HKEditResumeData *resumeData))successResponse failed:(void(^)(NSString * error))msg;

/***
 *  删除图片简历附件
 */
+(void)deleteUserEditResumeWithImageId:(NSString *)imagId successBlock:(void(^)(void))response andFail:(void(^)(NSString *msg))error;

/***
 *  更新简历之前没上传文件
 */
+(void)updateUSerEditResumeIsOpen:(BOOL)isOpen successBlock:(void(^)(void))response andFail:(void(^)(NSString *msg))error;

/***
 *  发布有文件上传
 */
+(void)releaseResumeWithDictionary:(NSMutableDictionary *)dic successBlock:(void(^)(void))response andFail:(void(^)(NSString *msg))error;

/***
 *  获取屏蔽的公司
 */
+(void)getUserShildCompanySuccessBlock:(void(^)(HKShieldCompany * comRes))response andFial:(void(^)(NSString *msg))error ;

/***
 *  删除屏蔽的公司
 */
+(void)deleteUserShildCompany:(NSString *)companyId SuccessBlock:(void(^)(void))response andFial:(void(^)(NSString *msg))error ;

/***
 *  删除屏蔽的公司
 */
+(void)addUserShildCompany:(NSString *)companyName SuccessBlock:(void(^)(void))response andFial:(void(^)(NSString *msg))error ;

/***
 *  我的投递
 */
+(void)getMyDeliverWithState:(NSInteger )states andPageNumbers:(NSInteger)page SuccessBlock:(void(^)(HKMyDelivery * deliver))response andFial:(void(^)(NSString *msg))error ;

/***
 *  我的简历预览
 */
+(void)getMyResumePreview:(NSString *)resumeId withrecruitId:(NSString *)recruitId andsource:(NSInteger)source  SuccessBlock:(void(^)(HKMyResumePreview * comRes))response andFial:(void(^)(NSString *msg))error ;
/***
 *  获取用户的更新简历时个人信息
 */
+(void)getUserRecruitInfoSuccessBlock:(void(^)(HK_UserRecruitData * comRes))response andFial:(void(^)(NSString *msg))error ;

/***
 *  获取用户的更新简历时工作经历
 */

+(void)getUserWorkInfoSuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error ;

/***
 *  获取用户的教育经历
 */

+(void)getUserEDucInfoSuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error ;
/***
 *  修改求职意向
 */
+(void)UpdateCareerWithDic:(NSMutableDictionary *)dic  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error ;
/***
 *  修改教育经历
 */
+(void)UpdateEDuWithDic:(NSMutableDictionary *)dic withInfoData:(HK_UserEducationalData *)data  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error ;

/***
 *  删除教育经历
 */
+(void)DeleteEduWithId:(NSString *)eduId  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error ;

/***
 *  修改个人基本信息
 */
+(void)UpdateBaseInfoWithDic:(NSMutableDictionary *)dic  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error ;

/***
 *  修改我的工作经历
 */
+(void)UpdateUserEXWithDic:(NSMutableDictionary *)dic withInfoData:(HK_UserExperienceData *)data  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error ;

/***
 *  删除我的工作经历
 */
+(void)DeleteEXWithId:(NSString *)eduId  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error ;

/***
 *  修改自我描述
 */
+(void)UpdateUserContent:(NSString *)content  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error ;
@end

