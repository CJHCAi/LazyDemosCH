//
//  HKMyCircleViewModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewModel.h"
#import "HKHKEstablishClicleParameters.h"
#import "HKPostCommentInfoResponse.h"
#import "HKReCommentListResponse.h"
#import "HKCicleProductResponse.h"
@class  HKCliceListRespondeModel,HKCategoryClicleRespone, HKMyCircleData,HKMyCircleRespone,HKCircleCategoryListModel,HKMyPostsRespone,HKPostDetailResponse,HKPostPriseResonse,HKpostComentResponse,HKCommentList;
@interface HKMyCircleViewModel : HKBaseViewModel
+(void)myCircle:(NSDictionary*)parameter success:(void (^)( HKMyCircleRespone* responde))success;
+(void)addGroup:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success;
//退出圈子
+(void)quitCicle:(NSDictionary *)parameter success:(void (^)( HKBaseResponeModel* responde))success;
//解散圈子
+(void)dissMissGroup:(NSDictionary *)parameter success:(void (^)( HKBaseResponeModel* responde))success;
+(void)getCircleList:(NSDictionary*)parameter success:(void (^)( HKCliceListRespondeModel* responde))success;
+(void)circleCategory:(NSDictionary*)parameter success:(void (^)( HKCategoryClicleRespone* responde))success;
+(void)circleCategoryList:(NSDictionary*)parameter success:(void (^)( NSArray* array))success failure:(void (^_Nullable)(NSError *_Nullable error))failure;
+(void)getCirclePost:(NSDictionary*)parameter success:(void (^)( HKMyPostsRespone* responde))success;

+(void)chanageReMindWith:(BOOL)sw cicleId:(NSString *)cicleID success:(void(^)(void))success fail:(void(^)(NSString *error))error;

+(void)createGroup:(NSDictionary*)parameter images:(NSArray*)images success:(void (^)( HKBaseResponeModel* responde))success;

//修改圈子封面
+(void)updateGroupCover:(NSDictionary*)parameter images:(NSArray*)images success:(void (^)( HKBaseResponeModel* responde))success;
//修改圈子频道
+(void)updateGroupChannel:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success;

//修改圈子简介
+(void)updateGroupIntrodution:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success;
//修改圈子名称
+(void)updateGroupName:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success;
//修改圈子上限
+(void)updateGroupLimit:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success;
//修改验证方式
+(void)updateGroupValidate:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success;
//踢出圈子
+(void)kickOutMemberWithUid:(NSString *)uid andCilceId:(NSString *)cicleId success:(void (^)( HKBaseResponeModel* responde))success;
//发布帖子
+(void)publishPostWithCicleId:(NSString *)cicleId postTitle:(NSString *)title withContent:(NSString *)content success:(void (^)( HKBaseResponeModel* responde))success;
//购买展位
+(void)shopBoothWithCicleId:(NSString *)cicleId success:(void (^)( HKBaseResponeModel* responde))success;
//帖子详情
+(void)getPostDetailsWithId:(NSString *)postId success:(void (^)(HKPostDetailResponse * responde))success;
//帖子点赞
+(void)priseOrNotWithState:(NSString *)priseState postId:(NSString *)postId success:(void (^)(HKPostPriseResonse * responde))success;
//帖子评论列表
+(void)getCommentListPostId:(NSString *)postId andPage:(NSInteger)page success:(void (^)(HKpostComentResponse * responde))success;
//设置 取消精选
+(void)setPostSelectdWithState:(NSString *)state andPostId:(NSString *)postId success:(void (^)(HKBaseResponeModel * responde))success;
//设置 置顶 取消
+(void)setPostTopWithState:(NSString *)state andPostId:(NSString *)postId success:(void (^)(HKBaseResponeModel * responde))success;
//设置 公告 取消
+(void)setNoticeWithState:(NSString *)state andPostId:(NSString *)postId success:(void (^)(HKBaseResponeModel * responde))success;
//发表评论
+(void)postCommentWithPostId:(NSString *)postId andContent:(NSString *)content withCommentId:(NSString *)commentId andReuserId:(NSString *)ruserId success:(void (^)(HKBaseResponeModel * responde))success;
//帖子评论点赞
+(void)praiseCommentWithCommentId:(NSString *)commentId andstate:(NSString *)state success:(void (^)(HKPostPriseResonse * responde))success;
//帖子 获取评论详情
+(void)getInfoPostCommentByCommentId:(NSString *)commentId success:(void (^)(HKPostCommentInfoResponse * responde))success;
//帖子评论回复列表
+(void)getReCommentList:(NSString *)commentId pageNumber:(NSInteger)page success:(void (^)(HKReCommentListResponse * responde))success;
//圈子商品详情
+(void)getCicleProductByProductId:(NSString *)productId success:(void (^)(HKCicleProductResponse * responde))success;
//获取购物车数量
+(void)getCarNumberSuccess:(void (^)(id responde))success;

//增加圈子商品
+(void)addCilceProduct:(NSString *)productId cicleId:(NSString *)cicleId success:(void (^)(HKBaseResponeModel * responde))success;
//移除圈子商品
+(void)removeCicleProduct:(NSString *)productId cicleId:(NSString *)cicleId success:(void (^)(HKBaseResponeModel * responde))success;
@end
