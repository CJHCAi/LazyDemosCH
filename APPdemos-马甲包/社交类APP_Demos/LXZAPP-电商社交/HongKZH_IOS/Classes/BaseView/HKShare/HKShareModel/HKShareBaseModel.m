//
//  HKShareBaseModel.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShareBaseModel.h"

#import "HKShareLeFriendPageViewController.h"
#import "HKBurstingActivityShareModel.h"
#import "HKGoodsSendShareModel.h"
#import "ShareMessage.h"
#import "EnterpriseAdvRespone.h"
#import "HKMyCopunDetailResponse.h"
#import "HKCollageResPonse.h"
#import "HKCollageOrderResponse.h"
#import "UrlConst.h"
#import "GetMediaAdvAdvByIdRespone.h"

@implementation HKShareBaseModel

-(void)setPlatform:(SSDKPlatformType)platform{
    _platform = platform;
    
    switch (platform) {
        case SSDKPlatformTypeUnknown://其实是乐小赚好友
        {
            HKShareLeFriendPageViewController*shareVc = [[HKShareLeFriendPageViewController alloc]init];
            shareVc.isPre = YES;
            shareVc.shareM = self;
            shareVc.indexVC = 0;
                  UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:shareVc];
            [self.subVc presentViewController:nav animated:YES completion:nil];
//             [self.subVc.navigationController pushViewController:shareVc animated:YES];
        }
            break;
        case SSDKPlatformTypeSinaWeibo://其实是了小赚圈子
        {
            HKShareLeFriendPageViewController*vc = [[HKShareLeFriendPageViewController alloc]init];
            UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:vc];
            vc.indexVC = 1;
            vc.isPre = YES;
            vc.shareM = self;
             [self.subVc presentViewController:nav animated:YES completion:nil];
        }
            break;
        case SSDKPlatformSubTypeWechatSession:
        {
            [self shareWithPlatformType:SSDKPlatformSubTypeWechatSession];
        }
            break;
        case SSDKPlatformSubTypeWechatTimeline:
        {
            [self shareWithPlatformType:SSDKPlatformSubTypeWechatTimeline];
        }
            break;
        case SSDKPlatformSubTypeQQFriend:
        {
            [self shareWithPlatformType:SSDKPlatformSubTypeQQFriend];
        }
            break;
        default:
            break;
    }
}

-(void)setGoodsModel:(HKMyGoodsModel *)goodsModel{
    _goodsModel = goodsModel;
    self.shareType = SHARE_Type_GOODS;
    self.title = @"分享商品";
    self.text =goodsModel.title;
    self.videoDescription = goodsModel.createDate;
    self.imageName = goodsModel.imgSrc;
    self.webpageUrl =[NSString stringWithFormat:@"%@purchase/goodsDetails?productId=%@&type=1&loginUid=%@",host_share,goodsModel.productId,HKUSERLOGINID];
    HKGoodsSendShareModel* model = [[HKGoodsSendShareModel alloc]init];
    if (goodsModel.isFormSelf) {
        model.shareType = SHARE_Type_SELFGOOD;
    }else{
        model.shareType = SHARE_Type_GOODS;
    }

    model.webpageUrl = self.webpageUrl;
    model.imgSrc = self.imageName;
    model.title = self.title;
    model.modelId = goodsModel.productId;
    model.msgText = @"分享商品";
    model.source = @"乐购";
    self.message = model;
}
-(void)setBurstListData:(LuckyBurstDetailData *)burstListData{
    _burstListData = burstListData;
    self.shareType = SHARE_Type_Burst;
    self.title =@"邀请好友助力";
    self.text =burstListData.title;
    self.videoDescription = [NSString stringWithFormat:@"商品原价¥ %.2lf",burstListData.integral];
    self.imageName = burstListData.imgSrc;
    self.webpageUrl =[NSString stringWithFormat:@"%@purchase/burstingActivity?type=3&orderNumber=%@&loginUid=%@",host_share,burstListData.u.orderNumber,HKUSERLOGINID];
    
    HKBurstingActivityShareModel*shareModel = [[HKBurstingActivityShareModel alloc]init];
    shareModel.shareType = SHARE_Type_Burst;
    shareModel.msgText = @"好友助力";
    shareModel.modelId = burstListData.u.orderNumber;
    shareModel.pintegral = [NSString stringWithFormat:@"%.2lf",burstListData.integral];
    shareModel.imgSrc = burstListData.imgSrc;
    shareModel.title = burstListData.title;
    shareModel.discount = [NSString stringWithFormat:@"%ld",(long)burstListData.discount];
    shareModel.webpageUrl = self.webpageUrl;
    shareModel.source = @"爆款活动";
    self.message = shareModel;
}
//拼团详情..
-(void)setCopun:(HKCollageOrderResponse *)copun{
    _copun = copun;
    self.shareType = SHARE_Type_Collage;
    self.title = @"邀请好友拼团";
    self.text =copun.data.title;
    self.videoDescription = [NSString stringWithFormat:@"商品原价¥ %.2lf",copun.data.integral];
    self.imageName = copun.data.imgSrc;
    self.webpageUrl =[NSString stringWithFormat:@"%@purchase/collageAdd?orderNumber=%@",host_share,copun.data.orderNumber];
    HKBurstingActivityShareModel*shareModel = [[HKBurstingActivityShareModel alloc]init];
    shareModel.shareType = SHARE_Type_Collage;
    shareModel.msgText = @"拼团";
    shareModel.modelId = copun.data.orderNumber;
    shareModel.pintegral = [NSString stringWithFormat:@"%ld",(long)copun.data.integral];
    shareModel.imgSrc = copun.data.imgSrc;
    shareModel.title = copun.data.title;
    shareModel.discount = [NSString stringWithFormat:@"%ld",(long)copun.data.discount];
    shareModel.webpageUrl = self.webpageUrl;
    shareModel.source = @"拼团";
    //self.message.type =self.shareType;
    self.message = shareModel;
}
-(void)setPostModel:(HKMyPostModel *)postModel{
    _postModel = postModel;
    self.shareType = SHARE_Type_POST;
    self.title = @"分享帖子";
    self.text =postModel.title;
    self.imageName = postModel.headImg;
    self.webpageUrl =[NSString stringWithFormat:@"%@friend/postDetails?postId=%@&uid=%@",host_share,postModel.postId,postModel.uid];
    ShareMessage*shareModel = [[ShareMessage alloc]init];
    shareModel.shareType = SHARE_Type_POST;
    shareModel.msgText = @"分享帖子";
    shareModel.source = postModel.modelName;
    shareModel.sex = @"1";
    shareModel.level = @"1";
    shareModel.modelId = postModel.postId;
//    shareModel.imgSrc = @[[UIImage imageNamed:@""]];
    shareModel.title = postModel.title;
    shareModel.webpageUrl = self.webpageUrl;
    shareModel.source = [NSString stringWithFormat:@"圈子好友、、、：%@",postModel.uName];
    self.message = shareModel;
}
-(void)setAdvM:(EnterpriseAdvRespone *)advM{
    _advM = advM;
    self.shareType = SHARE_Type_EnterpriseAdvertisement;
    self.title =@"分享视频";
    self.text =advM.data.title;
    self.imageName = advM.data.coverImgSrc;
    self.webpageUrl =[NSString stringWithFormat:@"%@see/adDetails?id=%@&loginUid=                               %@",host_share,advM.data.ID,HKUSERLOGINID];
    ShareMessage*shareModel = [[ShareMessage alloc]init];
    shareModel.shareType = SHARE_Type_EnterpriseAdvertisement;
    shareModel.msgText = @"分享视频";
    shareModel.imgSrc = advM.data.coverImgSrc;
    shareModel.modelId = advM.data.ID;
    //    shareModel.imgSrc = @[[UIImage imageNamed:@""]];
    shareModel.title = advM.data.title;
    shareModel.webpageUrl = self.webpageUrl;
    shareModel.source = @"企业广告";
    self.message = shareModel;
}
-(void)setFriendM:(HKFriendModel *)friendM{
    _friendM = friendM;
    self.shareType = SHARE_Type_User;
    self.title =@"推荐好友";
    self.text =friendM.name;
    
    self.imageName = friendM.headImg;
    self.webpageUrl =[NSString stringWithFormat:@"%@friend/getUserInfoByUid?uid=%@&loginUid=                               %@",host_share,friendM.uid,HKUSERLOGINID];
    ShareMessage*shareModel = [[ShareMessage alloc]init];
    shareModel.shareType = SHARE_Type_User;
    shareModel.msgText = @"推荐好友";
    shareModel.imgSrc = friendM.headImg;
    shareModel.modelId = friendM.uid;
    //    shareModel.imgSrc = @[[UIImage imageNamed:@""]];
    shareModel.title = friendM.name;
    shareModel.webpageUrl = self.webpageUrl;
    shareModel.source = @"乐友";
    self.message = shareModel;
}
-(void)setCircleM:(HKClicleListModel *)circleM{
    _circleM = circleM;
    self.shareType = SHARE_Type_User;
    self.title =@"分享视频";
    self.text = circleM.circleName;
    self.imageName = circleM.coverImgSrc;
        self.webpageUrl =[NSString stringWithFormat:@"%@friend/getGroupInfo?icircleId=%@&loginUid=                               %@",host_share,circleM.circleId,HKUSERLOGINID];
    ShareMessage*shareModel = [[ShareMessage alloc]init];
    shareModel.shareType = SHARE_Type_User;
    shareModel.msgText = @"推荐圈子";
    shareModel.imgSrc = circleM.coverImgSrc;
    shareModel.modelId = circleM.circleId;
    //    shareModel.imgSrc = @[[UIImage imageNamed:@""]];
    shareModel.title = circleM.circleName;
    shareModel.webpageUrl = self.webpageUrl;
    shareModel.source = [NSString stringWithFormat:@"圈子%@",circleM.circleName];
    self.message = shareModel;
}
-(void)setMediaModel:(GetMediaAdvAdvByIdRespone *)mediaModel{
    _mediaModel = mediaModel;
    self.shareType = SHARE_Type_SELFAdvertisement;
    self.title =@"分享视频";
    self.text =mediaModel.data.title;
    self.imageName = mediaModel.data.coverImgSrc;
    self.webpageUrl =[NSString stringWithFormat:@"%@mediaAdv/adDetails?igetMediaAdvAdvById=%@&loginUid=                               %@",host_share,mediaModel.data.ID,HKUSERLOGINID];
    ShareMessage*shareModel = [[ShareMessage alloc]init];
    shareModel.shareType = SHARE_Type_SELFAdvertisement;
    shareModel.msgText = @"分享视频";
    shareModel.imgSrc = mediaModel.data.coverImgSrc;
    shareModel.modelId = mediaModel.data.ID;
    //    shareModel.imgSrc = @[[UIImage imageNamed:@""]];
    shareModel.title = mediaModel.data.title;
    shareModel.webpageUrl = self.webpageUrl;
    shareModel.source = [NSString stringWithFormat:@"%@的自媒体",mediaModel.data.uName];
    self.message = shareModel;
}
-(SendMessageToWXReq *)req{
    if (!_req) {
        _req = [[SendMessageToWXReq alloc]init];
    }
    return _req;
}
-(void)shareWithPlatformType:(SSDKPlatformType)plattype {
    NSArray* imageArray;
    if (self.image) {
        imageArray = @[self.image];
    }else{
        imageArray = @[self.imageName];
    }
    //分享参数配置
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.title
                                     images:imageArray
                                        url:[NSURL URLWithString:self.webpageUrl]
                                      title:self.text
                                       type:SSDKContentTypeWebPage];
    
    [ShareSDK share:plattype parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
                [EasyShowTextView showText:@"分享成功"];
                break;
            case  SSDKResponseStateFail:
                [EasyShowTextView showText:@"分享失败"];
                break;
            case SSDKResponseStateCancel:
                [EasyShowTextView showText:@"取消分享"];
                break;
            default:
                break;
        }
    }];
}

-(NSString *)webpageUrl{
    if (!_webpageUrl) {
        _webpageUrl = @"www.baidu.com";
    }
    return _webpageUrl;
}

@end
