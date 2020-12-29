//
//  GrabRedEnvelopeViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "GrabRedEnvelopeViewController.h"
#import "HKGrabRedEnvelopeView.h"
#import "HKRobRedSucView.h"
#import "HKRobRedFailView.h"
#import "HKSelfMeidaVodeoViewModel.h"
#import "GetMediaAdvAdvByIdRespone.h"
#import "HKCollageShareView.h"
#import "HKShareBaseModel.h"
@interface GrabRedEnvelopeViewController ()<HKGrabRedEnvelopeViewDelegate,HKRobRedSucViewDelegate,HKRobRedFailViewDelegate>
@property (nonatomic, strong)HKGrabRedEnvelopeView *robView;
@property (nonatomic, strong)HKRobRedSucView *sucView;

@property (nonatomic, strong)HKRobRedFailView *failView;

@end

@implementation GrabRedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self gotorobRed];
    [self setUI];
    self.redType = GrabRedType_Grab;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)setUI{
    [self.view addSubview:self.robView];
    [self.view addSubview:self.sucView];
    [self.view addSubview:self.failView];
    [self.robView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.sucView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.failView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIButton*btn = [[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:@"X"] forState:0];
    [btn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-72);
    }];
}
-(void)closeClick{
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(playNextCell)]) {
            [self.delegate playNextCell];
        }
    }];
    
}
-(void)gotorobRed{
    [HKSelfMeidaVodeoViewModel getRedPacketsMediaAdvById:@{@"loginUid":HKUSERLOGINID,@"id":self.dataM.data.ID} success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            NSDictionary*dict = (NSDictionary*)responde.data;
            if ([dict[@"money"] integerValue]>0) {
                self.sucView.num = [dict[@"money"] integerValue];
                self.redType = GrabRedType_Suc;
            }else{
                self.redType = GrabRedType_Fail;
            }
        }
    }];
}
-(void)shareToVc{
    HKShareBaseModel*shareM = [[HKShareBaseModel alloc]init];
    shareM.subVc = self;
    shareM.mediaModel = self.dataM;
    [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:shareM];
}
-(void)setRedType:(GrabRedType)redType{
    switch (redType) {
        case GrabRedType_Grab:{
            self.robView.hidden = NO;
            self.sucView.hidden = YES;
            self.failView.hidden = YES;
        }
            break;
        case GrabRedType_Suc:{
            self.robView.hidden = YES;
            self.sucView.hidden = NO;
            self.failView.hidden = YES;
        }
            break;
        case GrabRedType_Fail:{
            self.robView.hidden = YES;
            self.sucView.hidden = YES;
            self.failView.hidden = NO;
        }
            break;
        default:
            break;
    }
}
-(void)setDataM:(GetMediaAdvAdvByIdRespone *)dataM{
    _dataM = dataM;
    self.robView.dataM =dataM;
}
+(void)showWithSuperVC:(HKBaseViewController*)superVc vodeoId:(GetMediaAdvAdvByIdRespone*)dataM{
    GrabRedEnvelopeViewController*vc = [[GrabRedEnvelopeViewController alloc]init];
    vc.redType = GrabRedType_Grab;
    vc.dataM = dataM;
    vc.delegate = superVc;
    [self showPreWithsuperVc:superVc subVc:vc];
}
-(HKGrabRedEnvelopeView *)robView{
    if (!_robView) {
        _robView = [[HKGrabRedEnvelopeView alloc]init];
        _robView.hidden = YES;
        _robView.delegate = self;
    }
    return _robView;
}
-(HKRobRedSucView *)sucView{
    if (!_sucView) {
        _sucView = [[HKRobRedSucView alloc]init];
        _sucView.hidden = YES;
        _sucView.delegate = self;
    }
    return _sucView;
}
-(HKRobRedFailView *)failView{
    if (!_failView) {
        _failView = [[HKRobRedFailView alloc]init];
        _failView.hidden = YES;
        _failView.delegate = self;
    }
    return _failView;
}

@end
