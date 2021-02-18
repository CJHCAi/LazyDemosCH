//
//  AdgnatioHelpInfoViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/2.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "AdgnatioHelpInfoViewController.h"
#import "ScrollerView.h"
#import "AdgnatioHelpInfoModel.h"
#import "BannerView.h"

@interface AdgnatioHelpInfoViewController ()
/** 滚动图*/
//@property (nonatomic, strong) ScrollerView *bannerScrollView;
@property (nonatomic, strong) BannerView *bannerView;

/** 简介*/
@property (nonatomic, strong) UITextView *infoTX;
/** 关注按钮*/
@property (nonatomic, strong) UIButton *attentionBtn;
/** 联系按钮*/
@property (nonatomic, strong) UIButton *purposeBtn;
/** 分享按钮*/
@property (nonatomic, strong) UIButton *shareBtn;
/** 宗亲详情模型*/
@property (nonatomic, strong) AdgnatioHelpInfoModel *adgnatioHelpInfoModel;
/** 关注人数*/
@property (nonatomic, strong) UILabel *attentionPeopleNumLB;
@end

@implementation AdgnatioHelpInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self getInfoData];
}

#pragma mark - 视图初始化
-(void)initUI{
    self.view.backgroundColor = LH_RGBCOLOR(236, 236, 236);
    //[self.view addSubview:self.bannerScrollView];
    [self.view addSubview:self.bannerView];
    
    CGFloat viewWidth = (Screen_width-4*10)/3;
    //关注人数
    UIView *attentionV =[[UIView alloc]initWithFrame:CGRectMake(10, CGRectYH(self.bannerView)+10, viewWidth, 55)];
    attentionV.backgroundColor = LH_RGBCOLOR(139, 71, 31);
    [self.view addSubview:attentionV];
    
    UIImageView *attentionIV = [[UIImageView alloc]init];
    //attentionIV.backgroundColor = [UIColor random];
    attentionIV.image = MImage(@"zqhz_guanzhu");
    [attentionV addSubview:attentionIV];
    attentionIV.sd_layout.leftSpaceToView(attentionV, 7).topSpaceToView(attentionV,10).widthIs(22).heightIs(22);
    
    self.attentionPeopleNumLB = [[UILabel alloc]init];
    self.attentionPeopleNumLB.text = [NSString stringWithFormat:@"%ld人",(long)self.myHelpModel.ZqFollowcnt];
    self.attentionPeopleNumLB.font = MFont(13);
    self.attentionPeopleNumLB.textColor = [UIColor whiteColor];
    [attentionV addSubview:self.attentionPeopleNumLB];
    self.attentionPeopleNumLB.sd_layout.leftSpaceToView(attentionIV,10).rightSpaceToView(attentionV,9).heightIs(15).centerYEqualToView(attentionIV);
    
    UILabel *attentionLB = [[UILabel alloc]init];
    attentionLB.text = @"关注人数";
    attentionLB.textColor = [UIColor whiteColor];
    attentionLB.font = MFont(13);
    [attentionV addSubview:attentionLB];
    attentionLB.sd_layout.leftSpaceToView(attentionV,7).rightSpaceToView(attentionV,25).topSpaceToView(attentionIV,0).bottomSpaceToView(attentionV,0);
    
    //意向联系
    UIView *purposeContactV = [[UIView alloc]initWithFrame:CGRectMake(CGRectXW(attentionV)+10, CGRectY(attentionV), viewWidth, 55)];
    purposeContactV.backgroundColor = LH_RGBCOLOR(212, 59, 34);
    [self.view addSubview:purposeContactV];
    
    UIImageView *purposeContactIV = [[UIImageView alloc]init];
    //purposeContactIV.backgroundColor = [UIColor random];
    purposeContactIV.image = MImage(@"zqhz_yixianglianxi");
    [purposeContactV addSubview:purposeContactIV];
    purposeContactIV.sd_layout.leftSpaceToView(purposeContactV, 7).topSpaceToView(purposeContactV,10).widthIs(22).heightIs(22);
    
    UILabel *purposeContactPeopleNumLB = [[UILabel alloc]init];
    purposeContactPeopleNumLB.text = [NSString stringWithFormat:@"%ld人",(long)self.myHelpModel.ZqIntencnt];
    purposeContactPeopleNumLB.font = MFont(13);
    purposeContactPeopleNumLB.textColor = [UIColor whiteColor];
    [purposeContactV addSubview:purposeContactPeopleNumLB];
    purposeContactPeopleNumLB.sd_layout.leftSpaceToView(purposeContactIV,10).rightSpaceToView(purposeContactV,9).heightIs(15).centerYEqualToView(purposeContactIV);
    
    UILabel *purposeContactLB = [[UILabel alloc]init];
    purposeContactLB.text = @"意向人数";
    purposeContactLB.textColor = [UIColor whiteColor];
    purposeContactLB.font = MFont(13);
    [purposeContactV addSubview:purposeContactLB];
    purposeContactLB.sd_layout.leftSpaceToView(purposeContactV,7).rightSpaceToView(purposeContactV,25).topSpaceToView(purposeContactIV,0).bottomSpaceToView(purposeContactV,0);
    
    //剩余天数
    UIView *deadlineDayV = [[UIView alloc]initWithFrame:CGRectMake(CGRectXW(purposeContactV)+10, CGRectY(attentionV), viewWidth, 55)];
    deadlineDayV.backgroundColor = LH_RGBCOLOR(245, 172, 50);
    [self.view addSubview:deadlineDayV];
    
    UIImageView *deadlineDayIV = [[UIImageView alloc]init];
    //deadlineDayIV.backgroundColor = [UIColor random];
    deadlineDayIV.image = MImage(@"zqhz_shixian");
    [deadlineDayV addSubview:deadlineDayIV];
    deadlineDayIV.sd_layout.leftSpaceToView(deadlineDayV, 7).topSpaceToView(deadlineDayV,10).widthIs(22).heightIs(22);
    
    UILabel *deadlineDayNumLB = [[UILabel alloc]init];
    deadlineDayNumLB.text = [NSString stringWithFormat:@"%ld天",(long)self.myHelpModel.Syts];
    deadlineDayNumLB.font = MFont(13);
    deadlineDayNumLB.textColor = [UIColor whiteColor];
    [deadlineDayV addSubview:deadlineDayNumLB];
    deadlineDayNumLB.sd_layout.leftSpaceToView(deadlineDayIV,10).rightSpaceToView(deadlineDayV,9).heightIs(15).centerYEqualToView(deadlineDayIV);
    
    UILabel *deadlineDayLB = [[UILabel alloc]init];
    deadlineDayLB.text = @"剩余天数";
    deadlineDayLB.textColor = [UIColor whiteColor];
    deadlineDayLB.font = MFont(13);
    [deadlineDayV addSubview:deadlineDayLB];
    deadlineDayLB.sd_layout.leftSpaceToView(deadlineDayV,7).rightSpaceToView(deadlineDayV,25).topSpaceToView(deadlineDayIV,0).bottomSpaceToView(deadlineDayV,0);
    
    //简介
    self.infoTX = [[UITextView alloc]initWithFrame:CGRectMake(0, 314, Screen_width, Screen_height-314-40-49)];
    self.infoTX.editable = NO;
    self.infoTX.backgroundColor = [UIColor whiteColor];
    self.infoTX.font = MFont(12);
    [self.view addSubview:self.infoTX];
    
    //关注
    self.attentionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectYH(self.infoTX), Screen_width/3, 30)];
    self.attentionBtn.backgroundColor = [UIColor whiteColor];
    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionBtn setTitle:@"取消关注" forState:UIControlStateSelected];
    [self.attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.attentionBtn.titleLabel.font = MFont(12);
    [self.attentionBtn setImage:MImage(@"zqhz_guanzhu1") forState:UIControlStateNormal];
    self.attentionBtn.layer.borderColor = LH_RGBCOLOR(236, 236, 236).CGColor;
    self.attentionBtn.layer.borderWidth = 0.5;
    [self.attentionBtn addTarget:self action:@selector(clickToAttention:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.attentionBtn];
    //联系
    self.purposeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_width/3, CGRectYH(self.infoTX), Screen_width/3, 30)];
    self.purposeBtn.backgroundColor = [UIColor whiteColor];
    [self.purposeBtn setTitle:@"联系" forState:UIControlStateNormal];
    [self.purposeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.purposeBtn.titleLabel.font = MFont(12);
    [self.purposeBtn setImage:MImage(@"zqhz_yixianglianxi1") forState:UIControlStateNormal];
    self.purposeBtn.layer.borderColor = LH_RGBCOLOR(236, 236, 236).CGColor;
    self.purposeBtn.layer.borderWidth = 0.5;
    [self.purposeBtn addTarget:self action:@selector(clickToContact) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.purposeBtn];
    //分享
    self.shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(Screen_width/3*2, CGRectYH(self.infoTX), Screen_width/3, 30)];
    self.shareBtn.backgroundColor = [UIColor whiteColor];
    [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.shareBtn.titleLabel.font = MFont(12);
    [self.shareBtn setImage:MImage(@"zqhz_fenxiang") forState:UIControlStateNormal];
    self.shareBtn.layer.borderColor = LH_RGBCOLOR(236, 236, 236).CGColor;
    self.shareBtn.layer.borderWidth = 0.5;
    [self.shareBtn addTarget:self action:@selector(clickToShare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareBtn];
    
    
}

#pragma mark - 点击事件
-(void)clickToAttention:(UIButton *)sender{
    sender.selected = !sender.selected;
    MYLog(@"关注");
    if (sender.selected) {
        [self attention];
        self.attentionPeopleNumLB.text = [NSString stringWithFormat:@"%ld人",(long)self.myHelpModel.ZqFollowcnt+1];
    }else{
        [self cancelAttention];
        self.attentionPeopleNumLB.text = [NSString stringWithFormat:@"%ld人",(long)self.myHelpModel.ZqFollowcnt];
    }
    
    
}

-(void)clickToContact{
    MYLog(@"联系");
    [self contact];
}

-(void)clickToShare{
    MYLog(@"分享");
}

#pragma mark - 请求
-(void)getInfoData{
    NSDictionary *logDic = @{@"ZqId":[NSString stringWithFormat:@"%ld",(long)(self.myHelpModel.ZqId)]};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"zqhzdetail" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        //MYLog(@"%@",jsonDic);
        if (succe) {
            weakSelf.adgnatioHelpInfoModel = [AdgnatioHelpInfoModel modelWithJSON:jsonDic[@"data"]];
            weakSelf.infoTX.text = weakSelf.adgnatioHelpInfoModel.data.ZqBrief;
            weakSelf.attentionBtn.selected = weakSelf.adgnatioHelpInfoModel.isgz;
//            weakSelf.bannerScrollView.imageNames = [weakSelf.adgnatioHelpInfoModel.piclist mutableCopy];
            weakSelf.bannerView.imageArr = weakSelf.adgnatioHelpInfoModel.piclist;
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)attention{
    NSDictionary *logDic = @{@"FlMeid":GetUserId,
                             @"FlZqid":@(self.myHelpModel.ZqId),
                             @"FlType":@"GZ",
                             @"FlState":@""
                             };
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"createfollow" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)cancelAttention{
    
    NSDictionary *logDic = @{@"UserId":[NSString stringWithFormat:@"%@",GetUserId],
                             @"Zqid":[NSString stringWithFormat:@"%@",@(self.myHelpModel.ZqId)],
                             };
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"canlfollow" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            
        }
    } failure:^(NSError *error) {
        
    }];

}

-(void)contact{
    NSDictionary *logDic = @{@"FlMeid":GetUserId,
                             @"FlZqid":@(self.myHelpModel.ZqId),
                             @"FlType":@"LX",
                             @"FlState":@""
                             };
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"createfollow" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            [SXLoadingView showAlertHUD:weakSelf.adgnatioHelpInfoModel.data.ZqTel duration:0.5];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -lazyLoad
//-(ScrollerView *)bannerScrollView{
//    if (!_bannerScrollView) {
//        _bannerScrollView = [[ScrollerView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, 175) images:nil];
//    }
//    return _bannerScrollView;
//}

-(BannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, 172)];
    }
    return _bannerView;
}

@end
