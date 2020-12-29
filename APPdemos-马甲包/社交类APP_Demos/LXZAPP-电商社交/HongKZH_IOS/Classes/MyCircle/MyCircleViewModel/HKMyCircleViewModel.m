//
//  HKMyCircleViewModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyCircleViewModel.h"
#import "HKCliceListRespondeModel.h"
#import "HKCategoryClicleRespone.h"
#import "HKMyCircleData.h"
#import "HKMyCircleRespone.h"
#import "HKCircleCategoryListModel.h"
#import "AFNetworking.h"
#import "HK_NetWork.h"
#import "HKDateTool.h"
#import "HKLeCircleDbManage.h"
#import "HKPostDetailResponse.h"
#import "HKPostPriseResonse.h"
#import "HKpostComentResponse.h"
#import "HKLeCircleDbManage.h"
#import "HKCliceListRespondeModel.h"
#import "HKMyCircleData.h"
@implementation HKMyCircleViewModel
+(void)myCircle:(NSDictionary*)parameter success:(void (^)( HKMyCircleRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_groupInfo body:parameter success:^(id  _Nullable responseObject) {
        HKMyCircleRespone *respone = [HKMyCircleRespone mj_objectWithKeyValues:responseObject];
        HKClicleListModel *model = [[HKClicleListModel alloc]init];
        model.circleId = respone.data.ID;
        model.circleName = respone.data.name;
        model.userCount = [NSString stringWithFormat:@"%d",respone.data.userCount];
        model.categoryName = respone.data.categoryName;
        model.coverImgSrc = respone.data.coverImgSrc;
        if (respone.responeSuc) {
            [[HKLeCircleDbManage sharedZSDBManageBaseModel]insertWithFriendArray:@[model] andSuc:^(BOOL isSuc) {
                
            }];
        }
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKMyCircleRespone *respone = [[HKMyCircleRespone alloc]init];
        success(respone);
    }];
}
+(void)addGroup:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success{
    
    [HK_BaseRequest buildPostRequest:get_joinGroup body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)quitCicle:(NSDictionary *)parameter success:(void (^)( HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_frindQuitGroup body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}

+(void)dissMissGroup:(NSDictionary *)parameter success:(void (^)( HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_dissMissGroup body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];

}
+(void)getCircleList:(NSDictionary*)parameter success:(void (^)( HKCliceListRespondeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_circleList body:parameter success:^(id  _Nullable responseObject) {
        HKCliceListRespondeModel *respone = [HKCliceListRespondeModel mj_objectWithKeyValues:responseObject];
        
        if (respone.responeSuc) {
            NSMutableArray *array = [NSMutableArray array];
            for (HKCliceListData*listM in respone.data) {
                for (HKClicleListModel*model in listM.list) {
                    [array addObject:model];
                }
            }
            [[HKLeCircleDbManage sharedZSDBManageBaseModel]insertWithFriendArray:array andSuc:^(BOOL isSuc) {
                
            }];
        }
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKCliceListRespondeModel *respone = [[HKCliceListRespondeModel alloc]init];
        success(respone);
    }];
}
+(void)circleCategory:(NSDictionary*)parameter success:(void (^)( HKCategoryClicleRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_circleCategory body:parameter success:^(id  _Nullable responseObject) {
        HKCategoryClicleRespone *respone = [HKCategoryClicleRespone mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKCategoryClicleRespone *respone = [[HKCategoryClicleRespone alloc]init];
        success(respone);
    }];
}
+(void)circleCategoryList:(NSDictionary*)parameter success:(void (^)( NSArray* array))success failure:(void (^_Nullable)(NSError *_Nullable error))failure{
    [HK_BaseRequest buildPostRequest:get_circleCategoryList body:parameter success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"]intValue]==0) {
            NSArray*dataArray =  [HKCircleCategoryListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            success(dataArray);
        }else{
            failure(nil);
        }
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
         failure(nil);
    }];
}
+(void)getCirclePost:(NSDictionary*)parameter success:(void (^)( HKMyPostsRespone* responde))success{
    [HK_BaseRequest buildPostRequest:get_getCirclePost body:parameter success:^(id  _Nullable responseObject) {
        HKMyPostsRespone *respone = [HKMyPostsRespone mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKMyPostsRespone *respone = [[HKMyPostsRespone alloc]init];
        success(respone);
    }];
}

+(void)chanageReMindWith:(BOOL)sw cicleId:(NSString *)cicleID success:(void(^)(void))success fail:(void(^)(NSString *error))error {
    NSString * value;
    if (sw) {
        value =@"1";
    }else {
        value =@"0";
    }
    [HK_BaseRequest buildPostRequest:get_friendUpdateGroupRemind body:@{kloginUid:HKUSERLOGINID,@"circleId":cicleID,@"remind":value} success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            success();
        }else {
            error([responseObject objectForKey:@"msg"]);
        }

    } failure:^(NSError * _Nullable error) {
        
    }];
    
}
+(void)createGroup:(NSDictionary*)parameter images:(NSArray*)images success:(void (^)( HKBaseResponeModel* responde))success{
    
    [HK_NetWork uploadEditImageURL:get_createGroup parameters:parameter images:images name:@"coverImgSrc" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:@"jpeg" specifications:nil progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(responde);
    
    }];
}
+(void)updateGroupCover:(NSDictionary*)parameter images:(NSArray*)images success:(void (^)( HKBaseResponeModel* responde))success {
    
    [HK_NetWork uploadEditImageURL:get_UpdateGroupCoverImgSrc parameters:parameter images:images name:@"coverImgSrc" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:@"jpeg" specifications:nil progress:^(NSProgress *progress) {
    } callback:^(id responseObject, NSError *error) {
        
        HKBaseResponeModel* responde = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(responde);
        
    }];
}
+(void)updateGroupChannel:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_UpdateGroupCategory body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)updateGroupIntrodution:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_UpdateGroupIntroduction body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)updateGroupName:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_UpdateGroupName body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)updateGroupLimit:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_UpdateGroupUpperLlimit body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)updateGroupValidate:(NSDictionary*)parameter success:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_UpupdateGroupValidate body:parameter success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)kickOutMemberWithUid:(NSString *)uid andCilceId:(NSString *)cicleId success:(void (^)( HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_KickOutGroup body:@{@"uid":uid,@"circleId":cicleId,kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)publishPostWithCicleId:(NSString *)cicleId postTitle:(NSString *)title withContent:(NSString *)content success:(void (^)( HKBaseResponeModel* responde))success{
    [HK_BaseRequest buildPostRequest:get_FriendSavePost body:@{@"title":title,@"content":content,@"circleId":cicleId,kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)shopBoothWithCicleId:(NSString *)cicleId success:(void (^)( HKBaseResponeModel* responde))success {
    [HK_BaseRequest buildPostRequest:get_friendBuyBooth body:@{@"circleId":cicleId,kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
    
}
+(void)getPostDetailsWithId:(NSString *)postId success:(void (^)(HKPostDetailResponse * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendGetPost body:@{@"postId":postId,kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKPostDetailResponse *respone = [HKPostDetailResponse mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKPostDetailResponse *respone = [[HKPostDetailResponse alloc]init];
       success(respone);
    }];
}
+(void)priseOrNotWithState:(NSString *)priseState postId:(NSString *)postId success:(void (^)(HKPostPriseResonse * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendPraisePost body:@{@"postId":postId,kloginUid:HKUSERLOGINID,@"state":priseState} success:^(id  _Nullable responseObject) {
        HKPostPriseResonse *respone = [HKPostPriseResonse mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKPostPriseResonse *respone = [[HKPostPriseResonse alloc]init];
        success(respone);
    }];
}
+(void)getCommentListPostId:(NSString *)postId andPage:(NSInteger)page success:(void (^)(HKpostComentResponse * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendGetInfoPostCommentList body:@{@"postId":postId,kloginUid:HKUSERLOGINID,@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        HKpostComentResponse*respone = [HKpostComentResponse mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKpostComentResponse *respone = [[HKpostComentResponse alloc]init];
        success(respone);
    }];
}
+(void)setPostSelectdWithState:(NSString *)state andPostId:(NSString *)postId success:(void (^)(HKBaseResponeModel * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendSetSelected body:@{@"postId":postId,kloginUid:HKUSERLOGINID,@"state":state} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}

+(void)setPostTopWithState:(NSString *)state andPostId:(NSString *)postId success:(void (^)(HKBaseResponeModel * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendSsetTop body:@{@"postId":postId,kloginUid:HKUSERLOGINID,@"state":state} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}

+(void)setNoticeWithState:(NSString *)state andPostId:(NSString *)postId success:(void (^)(HKBaseResponeModel * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendSetNotice body:@{@"postId":postId,kloginUid:HKUSERLOGINID,@"state":state} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        DLog(@"");
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)postCommentWithPostId:(NSString *)postId andContent:(NSString *)content withCommentId:(NSString *)commentId andReuserId:(NSString *)ruserId success:(void (^)(HKBaseResponeModel * responde))success{
    NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
    [dic setValue:HKUSERLOGINID forKey:kloginUid];
    [dic setValue:postId forKey:@"postId"];
    [dic setValue:content forKey:@"content"];
    if (commentId.length) {
        [dic setValue:commentId forKey:@"commentId"];
    }
    if (ruserId.length) {
        [dic setValue:ruserId forKey:@"ruserId"];
    }
    [HK_BaseRequest buildPostRequest:get_friendPostComment body:dic success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
    
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)praiseCommentWithCommentId:(NSString *)commentId andstate:(NSString *)state success:(void (^)(HKPostPriseResonse * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendPraisePostComment body:@{kloginUid:HKUSERLOGINID,@"commentId":commentId,@"state":state} success:^(id  _Nullable responseObject) {
        HKPostPriseResonse*respone = [HKPostPriseResonse mj_objectWithKeyValues:responseObject];
        success(respone);
        
    } failure:^(NSError * _Nullable error) {
        HKPostPriseResonse *respone = [[HKPostPriseResonse alloc]init];
        success(respone);
    }];
}
+(void)getInfoPostCommentByCommentId:(NSString *)commentId success:(void (^)(HKPostCommentInfoResponse * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendGetInfoPostCommentByCommentId body:@{kloginUid:HKUSERLOGINID,@"commentId":commentId} success:^(id  _Nullable responseObject) {
        HKPostCommentInfoResponse*respone = [HKPostCommentInfoResponse mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKPostCommentInfoResponse *respone = [[HKPostCommentInfoResponse alloc]init];
        success(respone);
    }];
}
+(void)getReCommentList:(NSString *)commentId pageNumber:(NSInteger)page success:(void (^)(HKReCommentListResponse * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendGetInfoPostCommentReplyList body:@{kloginUid:HKUSERLOGINID,@"commentId":commentId,@"pageNumber":@(page)} success:^(id  _Nullable responseObject) {
        HKReCommentListResponse*respone = [HKReCommentListResponse mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKReCommentListResponse *respone = [[HKReCommentListResponse alloc]init];
        success(respone);
    }];
}
+(void)getCicleProductByProductId:(NSString *)productId success:(void (^)(HKCicleProductResponse * responde))success {
    [HK_BaseRequest buildPostRequest:get_shopGetMediaProductById body:@{kloginUid:HKUSERLOGINID,@"productId":productId} success:^(id  _Nullable responseObject) {
        HKCicleProductResponse*respone = [HKCicleProductResponse mj_objectWithKeyValues:responseObject];
        success(respone);
    } failure:^(NSError * _Nullable error) {
        HKCicleProductResponse *respone = [[HKCicleProductResponse alloc]init];
        success(respone);
    }];
}
+(void)getCarNumberSuccess:(void (^)(id responde))success {
    [HK_BaseRequest buildPostRequest:getmediaShopCartCount body:@{kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nullable error) {
    }];
}

+(void)addCilceProduct:(NSString *)productId cicleId:(NSString *)cicleId success:(void (^)(HKBaseResponeModel * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendAddCircleProduct body:@{@"productId":productId,@"circleId":cicleId,kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}
+(void)removeCicleProduct:(NSString *)productId cicleId:(NSString *)cicleId success:(void (^)(HKBaseResponeModel * responde))success {
    [HK_BaseRequest buildPostRequest:get_friendDeleteCircleProduct body:@{@"productId":productId,@"circleId":cicleId,kloginUid:HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel*respone = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        success(respone);
        
    } failure:^(NSError * _Nullable error) {
        HKBaseResponeModel *respone = [[HKBaseResponeModel alloc]init];
        success(respone);
    }];
}

@end
