//
//  HK_MyApplyTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_MyApplyTool.h"
#import "HK_BaseRequest.h"
@implementation HK_MyApplyTool

+(void)pushDetailRecruitInfo:(NSString *)recruitId withCurrentVc:(UIViewController *)controller {
    
    HKReseaesInfosViewController * rele =[[HKReseaesInfosViewController alloc] init];
    rele.recruitId = recruitId;
    [controller.navigationController pushViewController:rele animated:YES];
}

+(void)UpdateBaseInfoWithDic:(NSMutableDictionary *)dic  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error {
    [dic setObject:LOGIN_UID forKey:kloginUid];
    [HK_BaseRequest buildPostRequest:get_updateUserBaseInfo body:dic success:^(id  _Nullable responseObject) {
        
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response(responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)getUserEDucInfoSuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_UserEducational body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response(responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getUserWorkInfoSuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error  {
    [HK_BaseRequest buildPostRequest:get_UserExperience body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {

        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response(responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }

    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getUserRecruitInfoSuccessBlock:(void(^)(HK_UserRecruitData * comRes))response andFial:(void(^)(NSString *msg))error  {
    [HK_BaseRequest buildPostRequest:get_recruitUserInfo body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HK_BaseInfoResponse * app =[HK_BaseInfoResponse mj_objectWithKeyValues:responseObject];
        if (app.code) {
            error(app.msg);
        }else {
            response(app.data);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getUserApplyInfoSuccessBlock:(void(^)(HKMyApplyData *applyData))successResponse failed:(void(^)(NSString * error))msg {
    [HK_BaseRequest buildPostRequest:get_myApply body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HKMyApply * app =[HKMyApply mj_objectWithKeyValues:responseObject];
        if (app.code) {
            msg(app.msg);
        }else {
            successResponse(app.data);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getRecommendJobsWithPage:(NSInteger)page SuccessBlock:(void(^)(HK_jobRecResponse *applyData))successResponse failed:(void(^)(NSString * error))msg {

    [HK_BaseRequest buildPostRequest:get_EnterpriseRecruitList body:@{kloginUid:LOGIN_UID,@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        HK_jobRecResponse *res =[HK_jobRecResponse mj_objectWithKeyValues:responseObject];
        if (res.code) {
            msg(res.msg);
        }else {
            successResponse(res);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getEditResumeSuccessBlock:(void(^)(HKEditResumeData *resumeData))successResponse failed:(void(^)(NSString * error))msg {
    [HK_BaseRequest buildPostRequest:get_editResume body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HKEditResume *resume =[HKEditResume mj_objectWithKeyValues:responseObject];
        if (resume.code) {
            msg(resume.msg);
        }else {
            successResponse(resume.data);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)deleteUserEditResumeWithImageId:(NSString *)imagId successBlock:(void(^)(void))response andFail:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_deleteResumeImg body:@{kloginUid:LOGIN_UID,@"id":imagId} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)updateUSerEditResumeIsOpen:(BOOL)isOpen successBlock:(void(^)(void))response andFail:(void(^)(NSString *msg))error {
   
    [HK_BaseRequest buildPostRequest:get_updateReleaseResume body:@{kloginUid:LOGIN_UID,@"isOpen":[NSString stringWithFormat:@"%d",isOpen ? 1 : 0]} success:^(id  _Nullable responseObject) {

        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {

    }];
}
+(void)releaseResumeWithDictionary:(NSMutableDictionary *)dic successBlock:(void(^)(void))response andFail:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_releaseResume body:dic success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];  
}
+(void)getUserShildCompanySuccessBlock:(void(^)(HKShieldCompany * comRes))response andFial:(void(^)(NSString *msg))error  {
    [HK_BaseRequest buildPostRequest:get_shieldCompany body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HKShieldCompany *com =[HKShieldCompany mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response(com);
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)deleteUserShildCompany:(NSString *)companyId SuccessBlock:(void(^)(void))response andFial:(void(^)(NSString *msg))error{
    
    [HK_BaseRequest buildPostRequest:get_deleteShieldCompany body:@{kloginUid:LOGIN_UID,@"companyId":companyId} success:^(id  _Nullable responseObject) {
        HKShieldCompany *com =[HKShieldCompany mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response();
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)addUserShildCompany:(NSString *)companyName SuccessBlock:(void(^)(void))response andFial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_addShieldCompany body:@{kloginUid:LOGIN_UID,@"corporateName":companyName} success:^(id  _Nullable responseObject) {
        HKShieldCompany *com =[HKShieldCompany mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response();
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getMyDeliverWithState:(NSInteger)states andPageNumbers:(NSInteger)page SuccessBlock:(void(^)(HKMyDelivery * deliver))response andFial:(void(^)(NSString *msg))error  {
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    [dic setValue:LOGIN_UID forKey:kloginUid];
    [dic setValue:@(page) forKey:@"pageNumber"];
    if (states) {
        [dic setValue:@(states) forKey:@"state"];
    }
    [HK_BaseRequest buildPostRequest:get_myDelivery body:dic success:^(id  _Nullable responseObject) {
        HKMyDelivery *com =[HKMyDelivery mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response(com);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)getMyResumePreview:(NSString *)resumeId withrecruitId:(NSString *)recruitId andsource:(NSInteger)source  SuccessBlock:(void(^)(HKMyResumePreview * comRes))response andFial:(void(^)(NSString *msg))error {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
        [dic setObject:resumeId forKey:@"resumeId"];
        if (source == 3) {
            [dic setObject:recruitId forKey:@"recruitId"];
        }
    [HK_BaseRequest buildPostRequest:get_myResumePreview body:dic success:^(id  _Nullable responseObject) {
        HKMyResumePreview *com =[HKMyResumePreview mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response(com);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)UpdateCareerWithDic:(NSMutableDictionary *)dic  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error  {
    
    [dic setValue:LOGIN_UID forKey:kloginUid];
    DLog(@"dic==%@",dic);
    [HK_BaseRequest buildPostRequest:get_updateCareerIntentions body:dic success:^(id  _Nullable responseObject) {
        HKMyResumePreview *com =[HKMyResumePreview mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response(com);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];

}

+(void)UpdateEDuWithDic:(NSMutableDictionary *)dic withInfoData:(HK_UserEducationalData *)data  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error {
    if (data) {
        [dic setValue:data.educatioId forKey:@"educatioId"];
    }
        [dic setValue:LOGIN_UID forKey:kloginUid];
    [HK_BaseRequest buildPostRequest:get_updateUserEducational body:dic success:^(id  _Nullable responseObject) {
        HKMyResumePreview *com =[HKMyResumePreview mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response(com);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)DeleteEduWithId:(NSString *)eduId  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error {
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    [dic setValue:LOGIN_UID forKey:kloginUid];
    [dic setValue:eduId forKey:@"educatioId"];
    [HK_BaseRequest buildPostRequest:get_deleteUserEducational body:dic success:^(id  _Nullable responseObject) {
        HKMyResumePreview *com =[HKMyResumePreview mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response(com);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

/***
 *  修改我的工作经历
 */
+(void)UpdateUserEXWithDic:(NSMutableDictionary *)dic withInfoData:(HK_UserExperienceData *)data  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error {
    if (data) {
        [dic setValue:data.experienceId forKey:@"experienceId"];
    }
      [dic setValue:LOGIN_UID forKey:kloginUid];
    [HK_BaseRequest buildPostRequest:get_updateUserExperience body:dic success:^(id  _Nullable responseObject) {
        HKMyResumePreview *com =[HKMyResumePreview mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response(com);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
/***
 *  删除我的工作经历
 */
+(void)DeleteEXWithId:(NSString *)eduId  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error {
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    
    [dic setValue:LOGIN_UID forKey:kloginUid];
    [dic setValue:eduId forKey:@"experienceId"];
    [HK_BaseRequest buildPostRequest:get_deleteUserExperience body:dic success:^(id  _Nullable responseObject) {
        HKMyResumePreview *com =[HKMyResumePreview mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response(com);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
/***
 *  修改自我描述
 */
+(void)UpdateUserContent:(NSString *)content  SuccessBlock:(void(^)(id res))response andFial:(void(^)(NSString *msg))error {
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    [dic setValue:LOGIN_UID forKey:kloginUid];
    [dic setValue:content forKey:@"content"];
    [HK_BaseRequest buildPostRequest:get_updateUserContent body:dic success:^(id  _Nullable responseObject) {
        HKMyResumePreview *com =[HKMyResumePreview mj_objectWithKeyValues:responseObject];
        if (com.code) {
            error(com.msg);
        }else {
            response(com);
        }
    } failure:^(NSError * _Nullable error) {
    }];
}
@end
