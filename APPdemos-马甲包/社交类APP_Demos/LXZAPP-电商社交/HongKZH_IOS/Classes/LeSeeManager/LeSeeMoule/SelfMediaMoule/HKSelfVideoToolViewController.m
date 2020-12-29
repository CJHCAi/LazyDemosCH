//
//  HKSelfVideoToolViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfVideoToolViewController.h"
#import "HKCategoryBarView.h"
#import "HKSelfToolInfoViewController.h"
#import "HKToolTranslateViewController.h"
#import "HKTollSelfCommitViewController.h"
#import "HKCommitSelfMeadioTool.h"
#import "HKLeSeeViewModel.h"
@interface HKSelfVideoToolViewController ()<HKCommitSelfMeadioToolDelegate,HKTollSelfCommitViewControllerDelegate>
@property (nonatomic, strong)HKCategoryBarView *categoryView;
@property (nonatomic, strong)HKSelfToolInfoViewController*vc1 ;
@property (nonatomic, strong)HKToolTranslateViewController *vc2;
@property (nonatomic, strong)HKTollSelfCommitViewController *vc3;
@property (nonatomic, strong)UIView *closeView;
@property (nonatomic, strong)HKCommitSelfMeadioTool *commitTool;

@property (nonatomic,weak) InfoMediaAdvCommentListModels *commentM;
@end

@implementation HKSelfVideoToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(200);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(kScreenWidth - 75);
        make.height.mas_equalTo(40);
    }];
    [self.view addSubview:self.closeView];
    [self.closeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(200);
        make.left.equalTo(self.categoryView.mas_right);
        make.height.mas_equalTo(40);
    }];
    [self.view addSubview:self.commitTool];
    [self.commitTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        HKSelfToolInfoViewController*vc1 = [[HKSelfToolInfoViewController alloc]init];
        self.vc1 = vc1;
//        [self.array_VC addObject:vc1];
        HKToolTranslateViewController*vc2 = [[HKToolTranslateViewController alloc]init];
        self.vc2 = vc2;
//        [self.array_VC addObject:vc2];
        HKTollSelfCommitViewController*vc3 = [[HKTollSelfCommitViewController alloc]init];
        self.vc3 = vc3;
        vc3.delegate = self;
        [self.array_VC addObject:vc3];
    }
    return self;
}
-(void)commitCommentWithText:(NSString *)text{
    NSString *Id ;
    if (self.cityResponse) {
        Id =self.cityResponse.data.cityAdvId;
    }else {
        Id =self.responde.data.ID;
    }
    [HKLeSeeViewModel advComment:@{@"loginUid":HKUSERLOGINID,@"content":text,@"id":Id,@"commentId":self.commentM.commentId} success:^(HKBaseResponeModel *responde) {
        self.commitTool.type = -1;
        if (responde.responeSuc) {
            [self.view endEditing:YES];
            
            [self.vc3 loadNewData];
            if (self.cityResponse) {
                self.cityResponse.data.commentCount =[NSString stringWithFormat:@"%ld",self.cityResponse.data.commentCount.integerValue+1];
            }else {
                self.responde.data.commentCount = [NSString stringWithFormat:@"%ld",self.responde.data.commentCount.integerValue+1];
            }
            if ([self.delegate respondsToSelector:@selector(commitSuc)]) {
                [self.delegate commitSuc];
            }
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"评论失败"];
        }
    }];
}
-(void)commitWithText:(NSString *)text{
    
    
    NSString *Id ;
    if (self.cityResponse) {
        Id =self.cityResponse.data.cityAdvId;
    }else {
        Id =self.responde.data.ID;
    }
    [HKLeSeeViewModel advComment:@{@"loginUid":HKUSERLOGINID,@"content":text,@"id":Id} success:^(HKBaseResponeModel *responde) {
        self.commitTool.type = -1;
        if (responde.responeSuc) {
            [self.view endEditing:YES];
        
            [self.vc3 loadNewData];
            if (self.cityResponse) {
                self.cityResponse.data.commentCount =[NSString stringWithFormat:@"%ld",self.cityResponse.data.commentCount.integerValue+1];
            }else {
                self.responde.data.commentCount = [NSString stringWithFormat:@"%ld",self.responde.data.commentCount.integerValue+1];
            }
            if ([self.delegate respondsToSelector:@selector(commitSuc)]) {
                [self.delegate commitSuc];
            }
            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"评论失败"];
        }
    }];
}
-(void)showTextViewCommunt:(InfoMediaAdvCommentListModels *)model{
    self.commitTool.type = 1;
    self.commentM = model;
    
}
-(void)setPageVcFrame{
    self.pageVC.view.frame = CGRectMake(0, 240, kScreenWidth, kScreenHeight-240);
}
-(HKCategoryBarView *)categoryView{
    if (!_categoryView) {
           @weakify(self)
        _categoryView = [HKCategoryBarView categoryBarViewWithCategoryArray:@[@"评论"] selectCategory:^(int index) {
            @strongify(self)
           
            [self btnClicks:index];
        } allW:kScreenWidth - 75];
    }
    return _categoryView;
}
-(void)setResponde:(GetMediaAdvAdvByIdRespone *)responde
{
    _responde = responde;
    self.vc1.responde = responde;
    self.vc2.responde = responde;
    self.vc3.responde = responde;
}

-(void)setCityResponse:(HKCityTravelsRespone *)cityResponse {
    
    _cityResponse = cityResponse;
    self.vc1.cityResponse = cityResponse;
    self.vc2.cityResponse = cityResponse;
    self.vc3.cityResponse = cityResponse;
}

-(void)closeBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIView *)closeView{
    if (!_closeView) {
        _closeView = [[UIView alloc]init];
        UIButton*btn = [[UIButton alloc]init];
        [btn setBackgroundImage:[UIImage imageNamed:@"player_down"] forState:0];
        [_closeView addSubview:btn];
        _closeView.backgroundColor = [UIColor whiteColor];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.closeView).offset(-15);
            make.centerY.equalTo(self.closeView);
        }];
        UIButton*actionBTn = [[UIButton alloc]init];
        [_closeView addSubview:actionBTn];
        [actionBTn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(btn);
            make.width.height.mas_equalTo(40);
        }];
        [actionBTn addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeView;
}
-(HKCommitSelfMeadioTool *)commitTool{
    if (!_commitTool) {
        _commitTool = [[HKCommitSelfMeadioTool alloc]initWithFrame:CGRectZero];
        _commitTool.delegate = self;
    }
    return _commitTool;
}
@end
