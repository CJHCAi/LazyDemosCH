//
//  HK_CladlyChattesView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/5/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_CladlyChattesView.h"
#import "HKShareCell.h"
#import "ShareMessage.h"
#import "HKMyFriendListViewModel.h"
#import "HKBurstingActivityShareModel.h"
#import "HKBKShareCell.h"
#import "HKGoodsSendShareModel.h"
#import "HKBurstingActivityInfoViewController.h"
#import "HKMyCircleViewModel.h"
#import "HKMyCircleViewController.h"
#import "HKCollageDetailVc.h"
#import "HKPostDetailViewController.h"
#import "HKDetailsPageViewController.h"
#import "HKChatSetVc.h"
#import "HK_FriendUserVc.h"
#import "HKFrindMainVc.h"
#import "HKMyFollowAndFans.h"
#import "HKFreindCollageVc.h"
#import "PhotoBroswerVC.h"
#import "SelfMediaRespone.h"
#import "HKSelfMeidaVodeoViewController.h"
#import "HKCorporateAdvertisingInfoViewController.h"
#import "HKPriseHotAdvListRespone.h"
@interface HK_CladlyChattesView ()

@end

@implementation HK_CladlyChattesView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    self.conversationMessageCollectionView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [RCIM sharedRCIM].enablePersistentUserInfoCache = NO;
    [self registerClass:[HKShareCell class] forMessageClass:[ShareMessage class]];
    [self registerClass:[HKBKShareCell class] forMessageClass:[HKBurstingActivityShareModel class]];
     [self registerClass:[HKShareCell class] forMessageClass:[HKGoodsSendShareModel class]];
    [SystemNavBar lt_setBackgroundColor:[UIColor whiteColor]];
    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;//头像圆形
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //默认输入类型为语音,这里修改为默认显示加号区域
//    self.defaultInputType = RCChatSessionInputBarInputExtention;
    [self.navigationController setNavigationBarHidden:NO];
}

//头像
-(void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *textcell = (RCTextMessageCell *)cell;
        UILabel *textL = (UILabel *)textcell.textLabel;
        
        textL.textColor = UICOLOR_RGB_Alpha(0x000000, 1);
//        textL.font = [UIFont systemFontOfSize:16];//不建议修改字体大小影响布局
    }
    UILabel *textL = (UILabel *)cell.messageTimeLabel;
    textL.backgroundColor = [UIColor clearColor];
    textL.font = [UIFont systemFontOfSize:10];
    textL.textColor =UICOLOR_RGB_Alpha(0x7b7b7b, 1);

}
//点击头像 回调..
- (void)didTapCellPortrait:(NSString *)userId {
    HKMyFollowAndFansList *list =[[HKMyFollowAndFansList alloc] init];
    list.name =@"";
    list.uid = userId;
    list.headImg = @"";
    [AppUtils pushUserDetailInfoVcWithModel:list andCurrentVc:self];
}
//点击cell
- (void)didTapMessageCell:(RCMessageModel *)model {
    if (![model.content isKindOfClass:[HKRLShareSendModel class]]) {
        
        if ([model.content isKindOfClass:[RCImageMessage class]]) {
         RCImageMessage*imageMessage =  (RCImageMessage*) model.content;
            [PhotoBroswerVC show:self type:PhotoBroswerVCTypeModal index:0 photoModelBlock:^NSArray *{
                PhotoModel*photoM = [[PhotoModel alloc]init];
                photoM.mid = 1;
                if (imageMessage.localPath) {
                   photoM.image = [[UIImage alloc]initWithContentsOfFile:imageMessage.localPath];
                }else{
                   photoM.image_HD_U = imageMessage.imageUrl;
                }
                
                
                UIImageView*imageView = [[UIImageView alloc]init];
                photoM.sourceImageView = imageView;
                NSArray*imageArray = @[photoM];
                return imageArray;
            }];
        }
        return;
    }
    //点击图片..
    if ([model.content isKindOfClass:[RCImageMessage class]]) {
       
        [self presentImagePreviewController:model];
        return;
    }
    HKBurstingActivityShareModel*shareM = (HKBurstingActivityShareModel*)model.content;
    //如果发送者是自己不进行操作
    if (model.senderUserId.integerValue ==[LoginUserData sharedInstance].chatId.integerValue) {
        return;
    }
    switch (shareM.type.integerValue) {
    
        case SHARE_Type_Burst:
        {
            
            HKBurstingActivityInfoViewController*vc = [[HKBurstingActivityInfoViewController alloc]init];
            HKBurstingActivityShareModel*bM = (HKBurstingActivityShareModel*)model.content;
            if (bM.modelId.length>0) {
                vc.orderNumber =bM.modelId;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"没有订单号，请试试其他分享订单"];
            }
        }
            break;
        case SHARE_Type_Collage:
        {
            HKFreindCollageVc*vc = [[HKFreindCollageVc alloc]init];
            HKBurstingActivityShareModel*bM = (HKBurstingActivityShareModel*)model.content;
            if (bM.modelId.length>0) {
                vc.orderNumber =bM.modelId;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"没有订单号，请试试其他分享订单"];
            }
        }
            break;
        case SHARE_Type_POST:
        {
            
            HKPostDetailViewController*vc = [[HKPostDetailViewController alloc]init];
            ShareMessage*bM = (ShareMessage*)model.content;
            if (bM.modelId.length>0) {
                vc.postID =bM.modelId;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"没有订单号，请试试其他分享订单"];
            }
        }
            break;
        case SHARE_Type_GOODS:
        {
            
            HKDetailsPageViewController*vc = [[HKDetailsPageViewController alloc]init];
            ShareMessage*bM = (ShareMessage*)model.content;
            if (bM.modelId.length>0) {
                vc.productId =bM.modelId;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"没有订单号，请试试其他分享订单"];
            }
        }
            break;
        case SHARE_Type_User:
        {
            
            ShareMessage*bM = (ShareMessage*)model.content;
            if (bM.modelId.length>0) {
                HKFrindMainVc*vc = [[HKFrindMainVc alloc]init];
                
                HKMyFollowAndFansList*listM = [[HKMyFollowAndFansList alloc]init];
                listM.uid = bM.modelId;
                listM.headImg = bM.imgSrc;
                listM.name = bM.title;
                vc.listModel = listM;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"没有订单号，请试试其他分享订单"];
            }
        }
            break;
        case SHARE_Type_SELFAdvertisement:
        {
            
            ShareMessage*bM = (ShareMessage*)model.content;
            if (bM.modelId.length>0) {
                
                SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
                listM.title = bM.title;
                listM.coverImgSrc = bM.imgSrc;
                //    listM.
                listM.praiseCount = @"";
                listM.rewardCount = @"";
                listM.isCity = NO;
                listM.ID = bM.modelId;
                HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
                vc.dataArray = [NSMutableArray arrayWithObject:listM];
                vc.selectRow = 0;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"没有订单号，请试试其他分享订单"];
            }
        }
            break;
        case SHARE_Type_EnterpriseAdvertisement:
        {
            
            ShareMessage*bM = (ShareMessage*)model.content;
            if (bM.modelId.length>0) {
                HKCorporateAdvertisingInfoViewController*vc = [[HKCorporateAdvertisingInfoViewController alloc]init];
                PriseHotAdvListModel*model = [[PriseHotAdvListModel alloc]init];
                model.ID = bM.modelId;
                model.title = bM.title;
                model.coverImgSrc = bM.imgSrc;
                vc.ID = model.ID;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"没有订单号，请试试其他分享订单"];
            }
        }
            break;
        default:
            break;
    }

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)initNav
{
    if (@available(iOS 11.0, *)) {
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBtnPressed:) image:[UIImage imageNamed:@"selfMediaClass_back"]];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBtnPressed:) image:[UIImage imageNamed:@"buy_more"]];
    }
    else
    {
        UIButton *backButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        /**
         *  设置frame只能控制按钮的大小
         */
        backButton.frame= CGRectMake(0, 0, 62, 36);
        [backButton setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -5;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
        
        
        
        UIButton *rightButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        /**
         *  设置frame只能控制按钮的大小
         */
        rightButton.frame= CGRectMake(0, 0, 36, 36);
        [rightButton setBackgroundImage:[UIImage imageNamed:@"buy_more"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btn_right_right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        UIBarButtonItem *rightnegativeSpacer = [[UIBarButtonItem alloc]
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -5;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightnegativeSpacer, btn_right_right, nil];
        
        
    }
}

-(void)leftBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击弹出sheet视图 可以关注 和加入黑名单
-(void)rightBtnPressed:(id)sender
{
    HKChatSetVc*vc = [[HKChatSetVc alloc]init];
    if (self.conversationType == ConversationType_PRIVATE) {
        vc.userId = self.targetId;
    }else{
        vc.cicleId = self.targetId;
    }
    [self.navigationController pushViewController:vc animated:YES];
    return;

}
#pragma mark 加入黑名单
-(void)addUserToBlackList {
    [HKMyFriendListViewModel addFriendToBlackListWithUserId:self.targetId success:^(id response) {
        [EasyShowTextView showText:@"成功加入黑名单"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addBlackList" object:nil];
        [AppUtils hanldeSuccessPopAfterSecond:1.5 WithCunrrentController:self];
      
    } fial:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
#pragma mark 举报
-(void)ReportUser {
    [HKMyFriendListViewModel addUserContentReportVc:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setName:(NSString *)name{
    _name = name;
    self.title = name;
}
@end
