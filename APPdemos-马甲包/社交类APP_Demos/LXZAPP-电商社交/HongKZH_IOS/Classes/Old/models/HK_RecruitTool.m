//
//  HK_RecruitTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_RecruitTool.h"

@implementation HK_RecruitTool

+(void)deliverResumeWithResumeId:(NSString *)resumeId EnterPriseId:(NSString *)entertPriseId SuccessBlock:(void(^)(void))Success fial:(void(^)(NSString *fail))fail {
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:resumeId forKey:@"recruitId"];
    [params setValue:HKUSERLOGINID forKey:kloginUid];
    [params setValue:entertPriseId forKey:@"enterpriseId"];
    [HK_BaseRequest buildPostRequest:get_recruitDeliveryRecruitInfo body:params success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            Success();
        }else {
            fail([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)deleteAllHistorysuccessblock:(void(^)(void))success fial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_HKrecruitemptySearchHistory body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)deleteHistoryStringWithId:(NSString *)historyId successblock:(void(^)(void))success fial:(void(^)(NSString *msg))error {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:LOGIN_UID forKey:kloginUid];
    [dic setValue:historyId forKey:@"historyId"];
    [HK_BaseRequest buildPostRequest:get_HKrecruitDdeleteSearchHistory body:dic success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getCurrentPositionListSuccessBlock:(void(^)(HK_RecriutPosition *infoData))success fial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_RecruitPosition body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
       HK_RecriutPosition *re =[HK_RecriutPosition mj_objectWithKeyValues:responseObject];
        if (re.code) {
           error(re.msg);
        }else {
          success(re);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
/***
 *  请求企业信息
 */
+(void)getRecruitSuccessBlock:(void(^)(HK_RecruitEnterpriseInfoData *infoData))success fial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_RecruitEnterpriseInfo body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] ==0) {
            id  data =[responseObject objectForKey:@"data"];
            HK_RecruitEnterpriseInfoData *res =[HK_RecruitEnterpriseInfoData mj_objectWithKeyValues:data];
            success (res);
        }else {
            error(@"系统错误");
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getEditRecruitmentSuccessBlock:(void(^)(HKEditRecruitment *recuit))success fial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_editRecruitment body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HKEditRecruitment *re =[HKEditRecruitment mj_objectWithKeyValues:responseObject];
        if (re.code) {
             error(re.msg);
        }else {
             success(re);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getRecommendListandPage:(NSInteger)curPage SuccessBlock:(void(^)(HKMyRecruitRecommend * recommend))response fial:(void(^)(NSString * msg))error {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    [dic setObject:[NSString stringWithFormat:@"%ld",curPage] forKey:@"pageNumber"];
    [HK_BaseRequest buildPostRequest:get_usermyTalentCollection body:dic success:^(id  _Nullable responseObject) {
        HKMyRecruitRecommend * rec =[HKMyRecruitRecommend mj_objectWithKeyValues:responseObject];
        if (!rec.code) {
            response(rec);
        }else {
            error(rec.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)pushUserCollectionWithCurrentVc:(UIViewController *)controller {
    HKCollectionRecruitController *cool =[[HKCollectionRecruitController alloc] init];
    [controller.navigationController pushViewController:cool animated:YES];
}

+(void)getResumeStatesWithResumeId:(NSString *)resumeId andRecuitId:(NSString *)recruitId SuccessBlock:(void(^)(void))success fail:(void(^)(NSString *msg))error {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    [dic setObject:resumeId forKey:@"resumeId"];
    [dic setObject:recruitId forKey:@"recruitId"];
    [HK_BaseRequest buildPostRequest:get_notGoodResume body:dic success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getCollectionCanidateWithResumeId:(NSString *)resumeId andCollectionState:(BOOL)collectionStates SuccessBlock:(void(^)(void))success fail:(void(^)(NSString *msg))error {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    [dic setObject:resumeId forKey:@"resumeId"];
    if (collectionStates) {
        [dic setObject:@"1" forKey:@"state"];
    } else {
        [dic setObject:@"0" forKey:@"state"];
    }
    [HK_BaseRequest buildPostRequest:get_resumeCollection body:dic success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)getCandidateListwithRecruitId:(NSString *)recruitId states:(NSString *)state page:(NSInteger)page successBlock:(void(^)(HKMyCandidate * cadite))response fail:(void(^)(NSString *error))msg {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    if (recruitId) {
        [dic setObject:recruitId forKey:@"recruitId"];
    }
    if (state) {
        [dic setObject:state forKey:@"state"];
    }
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"pageNumber"];
    [HK_BaseRequest buildPostRequest:get_myCandidate body:dic success:^(id  _Nullable responseObject) {
        HKMyCandidate * com =[HKMyCandidate mj_objectWithKeyValues:responseObject];
        if (com.code) {
            msg(com.msg);
        }else {
            response(com);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)getOnlineListDataSuccessBlock:(void(^)(HKRecruitOnlineList *list))listData fial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_RecruitByUserId body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HKRecruitOnlineList * obj =[HKRecruitOnlineList mj_objectWithKeyValues:responseObject];
        if (obj.code) {
            error(obj.msg);
        }else {
            listData(obj);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)getOfflineListDataSuccessBlock:(void(^)(HKRecruitOffLineList *list))listData fial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_downRecruitById body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HKRecruitOffLineList * obj =[HKRecruitOffLineList mj_objectWithKeyValues:responseObject];
        if (obj.code) {
            error(obj.msg);
        }else {
            listData(obj);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)refreshOnlineDataById:(NSString *)positionId SuccessBlock:(void (^)(id response))response fial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_updateRecruitById body:@{kloginUid:LOGIN_UID,@"recruitId":positionId} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response(responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)letPositionOnDataById:(NSString *)positionId SuccessBlock:(void (^)(id response))response fial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_upRecruitById body:@{kloginUid:LOGIN_UID,@"recruitId":positionId} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response(responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)DeletePositionOnDataById:(NSString *)positionId SuccessBlock:(void (^)(id response))response fial:(void(^)(NSString *msg))error {
    [HK_BaseRequest buildPostRequest:get_deleteRecruitById body:@{kloginUid:LOGIN_UID,@"recruitId":positionId} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            response(responseObject);
        }else {
            error([responseObject objectForKey:@"msg"]);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
+(void)pushReleaseWithCuRrentVc:(UIViewController *)controller {
    HKUpdateReleaseRecruitViewController *vc = [[HKUpdateReleaseRecruitViewController alloc] init];
    [controller.navigationController pushViewController:vc animated:YES];
}
+(void)pushOnlinePositionWithCuRrentVc:(UIViewController *)controller {
    HKMyRecruitPositionManagerViewController *vc = [[HKMyRecruitPositionManagerViewController alloc] init];
    [controller.navigationController pushViewController:vc animated:YES];
    
}
+(void)getMyrecuitSuccessBlock:(void(^)(HKMyRecruit* recruit))response fial:(void(^)(NSString * msg))error {
    [HK_BaseRequest buildPostRequest:get_myRecruit body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HKMyRecruit * obj =[HKMyRecruit mj_objectWithKeyValues:responseObject];
        if (obj.code) {
            error(obj.msg);
        }else {
            response(obj);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

+(void)getRecommendListWithTilte:(NSString *)curtitle andPage:(NSInteger)curPage SuccessBlock:(void(^)(HKMyRecruitRecommend * recommend))response fial:(void(^)(NSString * msg))error {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    [dic setObject:[NSString stringWithFormat:@"%ld",curPage] forKey:@"pageNumber"];
    //title
    if ([curtitle isEqualToString:@"人才推荐"] ||
         curtitle == nil) {
        
    } else {
        [dic setObject:curtitle forKey:@"title"];
    }
    [HK_BaseRequest buildPostRequest:get_myRecruitRecommend body:dic success:^(id  _Nullable responseObject) {
        HKMyRecruitRecommend * rec =[HKMyRecruitRecommend mj_objectWithKeyValues:responseObject];
        if (!rec.code) {
            response(rec);
        }else {
            error(rec.msg);
        }
    } failure:^(NSError * _Nullable error) {
        
    }];

}

@end
