//
//  HKFrindMainVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFrindMainVc.h"
#import "HKMyFriendListViewModel.h"
#import "HK_FriendUserVc.h"
#import "HKFrindShopVc.h"
#import "HKFrindVideoVC.h"
#import "HKFrindInfoHeaderView.h"
#import "ZWMSegmentController.h"
#import "HKAddHeadViewModel.h"
#import "UIButton+LXMImagePosition.h"
@interface HKFrindMainVc ()<UpdateHeaderDataDelegete>
{
    NSInteger _shopTotal;
    NSInteger _videoTotal;
    UIButton * _attetionBtn;
}
@property (nonatomic, strong)ZWMSegmentController *segmentVC;
@property (nonatomic, strong)HKFrindInfoHeaderView *head;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)UIView *bottomMoreView;

@end
@implementation HKFrindMainVc

-(void)viewWillAppear:(BOOL)animated {
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.listModel.gcount==100000) {
        [AppUtils setPopHidenNavBarForFirstPageVc:self];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page =1;
    if (self.listModel.name.length) {
        self.title =self.listModel.name;
    }else {
        self.title =@"";
    }
    self.showCustomerLeftItem = YES;
    [self creatSubViewControllers];
    [self.view addSubview:self.head];
    if ([[LoginUserData sharedInstance].chatId isEqualToString:self.listModel.uid]) {
       //用户自己进入自己主页...
    }else {
         [AppUtils addBarButton:self title:@"buy_more" action:@selector(showSheent) position:PositionTypeRight];
          [self.view addSubview:self.bottomMoreView];
    }
    //预请求得到商品和视频接口获取总数量
    // [self loadShopInfo];
}
-(void)loadShopInfo {
    
    [HKMyFriendListViewModel getUserShopDataByUid:self.listModel.uid withPage:self.page successBlock:^(HKFrindShopResponse *response) {
        self->_shopTotal  = response.data.totalRow;
        [HKMyFriendListViewModel getUserVideoDataByUid:self.listModel.uid withPage:self.page successBlock:^(HKUserVideoResponse *response) {
            self->_videoTotal = response.data.totalRow;
            dispatch_async(dispatch_get_main_queue(), ^{
              [self creatSubViewControllers];
            });
        } fial:^(NSString *error) {
            
        }];
    } fial:^(NSString *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self creatSubViewControllers];
        });
    }];
}
-(HKFrindInfoHeaderView *)head {
    if (!_head) {
        _head =[[HKFrindInfoHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,210)];
        _head.model = self.listModel;
    }
    return _head;
}

-(void)updateUserHeaderInfoWith:(HKMediaInfoResponse *)response {
       self.head.response = response;
       self.title = response.data.name;
   //刷新底部BarTitle...
    if (response.data.friendId.length) {
       [_attetionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
}
-(void)creatSubViewControllers {
    NSMutableArray *VCArr=[[NSMutableArray alloc] init];
    //标题数组
    NSString *videoStr ;
    NSString *shopStr;
    if (_videoTotal) {
        videoStr =[NSString stringWithFormat:@"视频 %zd",_videoTotal];
    }else {
        videoStr =@"视频";
    }
    if (_shopTotal) {
        shopStr =[NSString stringWithFormat:@"商品 %zd",_shopTotal];
    }else {
        shopStr =@"商品";
    }
     NSArray *titleArr =@[@"资料",videoStr,shopStr];
    //资料页
    HK_FriendUserVc * userVc =[[HK_FriendUserVc alloc] init];
    userVc.uid = self.listModel.uid;
    userVc.delegete = self;
    [VCArr addObject:userVc];
    //视频
    HKFrindVideoVC *videoVc =[[HKFrindVideoVC alloc] init];
    videoVc.uid =self.listModel.uid;
    videoVc.name = self.listModel.name;
    videoVc.headImg =self.listModel.headImg;
    [VCArr addObject:videoVc];
   //商品
    HKFrindShopVc *shopVc =[[HKFrindShopVc alloc] init];
    shopVc.uid = self.listModel.uid;
    [VCArr addObject:shopVc];
    self.segmentVC = [[ZWMSegmentController alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.head.frame),kScreenWidth,self.view.bounds.size.height-CGRectGetHeight(self.head.frame)) titles:titleArr];
    self.segmentVC.segmentView.segmentTintColor = RGB(239,89,60);
    self.segmentVC.segmentView.segmentNormalColor =RGB(153,153,153);
    self.segmentVC.viewControllers = VCArr;
    self.segmentVC.segmentView.style = ZWMSegmentStyleDefault;
    [self addSegmentController:self.segmentVC];
    [self.segmentVC  setSelectedAtIndex:0];
}
-(void)showSheent {
    [SRActionSheet sr_showActionSheetViewWithTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"加入黑名单",@"举报该人"] selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
        if (index ==0) {
            [self addUserToBlackList];
        }else {
            [self ReportUser];
        }
    }];
}
#pragma mark 加入黑名单
-(void)addUserToBlackList {
    [HKMyFriendListViewModel addFriendToBlackListWithUserId:self.listModel.uid success:^(id response) {
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
-(UIView *)bottomMoreView {
    if (!_bottomMoreView) {
        _bottomMoreView =[[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight-50-NavBarHeight -StatusBarHeight-SafeAreaBottomHeight,kScreenWidth,50)];
        UIView *lineTop =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth, 1)];
        lineTop.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        [_bottomMoreView addSubview:lineTop];
        NSArray * bTitle  =@[@"聊天",@"关注"];
        NSArray *imgaArr =@[@"mebia_say",@"mebia_add"];
        CGFloat btnW = kScreenWidth /2;
        for (int i=0; i< bTitle.count; i++) {
            UIButton * bottmB =[HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectMake(i*btnW,CGRectGetMaxY(lineTop.frame),btnW,CGRectGetHeight(_bottomMoreView.frame)-1) title:bTitle[i] font:PingFangSCRegular16 taget:self action:@selector(actionCoupon:) supperView:_bottomMoreView];
            bottmB.tag =i+200;
            [bottmB setTitleColor:[UIColor colorFromHexString:@"666666"] forState:UIControlStateNormal];
            [bottmB setImage:[UIImage imageNamed:imgaArr[i]] forState:UIControlStateNormal];
            bottmB.backgroundColor =[UIColor colorFromHexString:@"ffffff"];
            [bottmB setImagePosition:0 spacing:10];
            if (i==1) {
                _attetionBtn = bottmB;
            }
            [_bottomMoreView addSubview:bottmB];
      
        }
    }
    return _bottomMoreView;
}
#pragma  mark 底部Bar的点击事件
-(void)actionCoupon:(UIButton *)sender {
    if (sender.tag==200) {
       //聊天
        [AppUtils PushChatControllerWithType:ConversationType_PRIVATE uid:self.listModel.uid name:self.listModel.name headImg:self.listModel.headImg andCurrentVc:self];
    }
       else {
       //关注
           if ([sender.titleLabel.text isEqualToString:@"已关注"]) {
               [HKAddHeadViewModel followDelete:@{@"loginUid":HKUSERLOGINID,@"followUserId":self.listModel.uid} success:^(BOOL isSuc) {
                   
                   if (isSuc) {
                       [EasyShowTextView showText:@"取消关注"];
                       [sender setTitle:@"关注" forState:UIControlStateNormal];
                   }else {
                        [EasyShowTextView showText:@"已经是好友了"];
                   }
               }];
           }else{
               [HKAddHeadViewModel followAdd:@{@"loginUid":HKUSERLOGINID,@"followUserId":self.listModel.uid} success:^(BOOL isSuc) {
                   if (isSuc) {
                       [EasyShowTextView showText:@"关注成功"];
                       [sender setTitle:@"已关注" forState:UIControlStateNormal];
                   }else {
                       [EasyShowTextView showText:@"系统错误"];
                   }
               }];
           }
     }
}
@end
