//
//  HK_RecruitTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_BaseRequest.h"
//********  企业招聘主页 *********//
#import "HKMyRecruitOperationCell.h"
#import "HKMyRecruitRecommendCell.h"
#import "HKChoosePositionView.h"
#import "HKUpdateReleaseRecruitViewController.h"
#import "HKMyRecruitPositionManagerViewController.h"
#import "HKMyRecruit.h"
#import "HKMyRecruitRecommend.h"
#import "HKRecruitOffLineList.h"
#import "HKRecruitOnlineList.h"
#import "HKMyCandidate.h"
#import "HKCollectionRecruitController.h"
#import "HKMyResumePreviewViewController.h"
#import "HKEditRecruitment.h"
#import "HK_RecruitEnterpriseInfoData.h"
#import "HK_RecriutPosition.h"
#import "HK_searchResponse.h"
@interface HK_RecruitTool : NSObject

/***
 *  投递简历
 */
+(void)deliverResumeWithResumeId:(NSString *)resumeId EnterPriseId:(NSString *)entertPriseId SuccessBlock:(void(^)(void))Success fial:(void(^)(NSString *fail))fail;


/***
 *  清空全部删除
 */
+(void)deleteAllHistorysuccessblock:(void(^)(void))success fial:(void(^)(NSString *msg))error;

/***
 *  删除职位搜索历史(传ID删除)
 */
+(void)deleteHistoryStringWithId:(NSString *)historyId successblock:(void(^)(void))success fial:(void(^)(NSString *msg))error;
/***
 *  请求当前职位列表
 */
+(void)getCurrentPositionListSuccessBlock:(void(^)(HK_RecriutPosition *infoData))success fial:(void(^)(NSString *msg))error;

/***
 *  请求企业信息
 */
+(void)getRecruitSuccessBlock:(void(^)(HK_RecruitEnterpriseInfoData *infoData))success fial:(void(^)(NSString *msg))error;

/***
 *  请求编辑简历数据
 */
+(void)getEditRecruitmentSuccessBlock:(void(^)(HKEditRecruitment *recuit))success fial:(void(^)(NSString *msg))error;

/***
 *  简历不符合
 */
+(void)getResumeStatesWithResumeId:(NSString *)resumeId andRecuitId:(NSString *)recruitId SuccessBlock:(void(^)(void))success fail:(void(^)(NSString *msg))error;

/***
 *  收藏简历/不收藏
 */
+(void)getCollectionCanidateWithResumeId:(NSString *)resumeId andCollectionState:(BOOL)collectionStates SuccessBlock:(void(^)(void))success fail:(void(^)(NSString *msg))error;
/***
 *  候选人列表
 */
+(void)getCandidateListwithRecruitId:(NSString *)recruitId states:(NSString *)state page:(NSInteger)page successBlock:(void(^)(HKMyCandidate * cadite))response fail:(void(^)(NSString *error))msg;

/***
 *  招聘中
 */
+(void)getOnlineListDataSuccessBlock:(void(^)(HKRecruitOnlineList *list))listData fial:(void(^)(NSString *msg))error;

/***
 *  下线
 */
+(void)getOfflineListDataSuccessBlock:(void(^)(HKRecruitOffLineList *list))listData fial:(void(^)(NSString *msg))error;

/***
 *  刷新职位
 */
+(void)refreshOnlineDataById:(NSString *)positionId SuccessBlock:(void (^)(id response))response fial:(void(^)(NSString *msg))error;

/***
 *  职位上线
 */
+(void)letPositionOnDataById:(NSString *)positionId SuccessBlock:(void (^)(id response))response fial:(void(^)(NSString *msg))error;

/***
 *  职位删除
 */
+(void)DeletePositionOnDataById:(NSString *)positionId SuccessBlock:(void (^)(id response))response fial:(void(^)(NSString *msg))error;

/***
 *  获取我的企业招聘信息
 */
+(void)getMyrecuitSuccessBlock:(void(^)(HKMyRecruit* recruit))response fial:(void(^)(NSString * msg))error;

/***
 *  企业招聘人才推荐
 */
+(void)getRecommendListWithTilte:(NSString *)curtitle andPage:(NSInteger)curPage SuccessBlock:(void(^)(HKMyRecruitRecommend * recommend))response fial:(void(^)(NSString * msg))error;
/***
 *  人才收藏
 */
+(void)getRecommendListandPage:(NSInteger)curPage SuccessBlock:(void(^)(HKMyRecruitRecommend * recommend))response fial:(void(^)(NSString * msg))error;
/***
 *  跳转到发布界面
 */
+(void)pushReleaseWithCuRrentVc:(UIViewController *)controller;

/***
 *  跳转在线职位
 */
+(void)pushOnlinePositionWithCuRrentVc:(UIViewController *)controller;
/***
 *  人才收藏
 */
+(void)pushUserCollectionWithCurrentVc:(UIViewController *)controller;


@end
