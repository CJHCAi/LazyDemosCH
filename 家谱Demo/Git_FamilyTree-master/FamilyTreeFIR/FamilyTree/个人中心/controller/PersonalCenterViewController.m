//
//  PersonalCenterViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/24.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "CommonNavigationViews.h"
#import "PersonalCenterHeaderView.h"
#import "PersonalCenterInfoView.h"
#import "PersonalCenterNumerologyView.h"
#import "PersonalCenterTodayFortuneView.h"
#import "PersonalCenterCliffordView.h"
#import "PersonalCenterMyPhotoAlbumsView.h"
#import "PayForFortuneView.h"
#import "PayForForeverFortuneView.h"
#import "RechargeViewController.h"
#import "FortuneTodayViewController.h"
#import "SettlementCenterViewController.h"
#import "VIPView.h"
#import "EditHeadView.h"
#import "EditPersonalInfoView.h"
#import "MemallInfoModel.h"
#import "QueryModel.h"
#import "JobModel.h"
#import "AreaModel.h"
#import "VIPInfoModel.h"
#import "VIPGrowUpModel.h"
#import "NewInfoViewController.h"

@interface PersonalCenterViewController ()<PersonalCenterHeaderViewDelegate,PersonalCenterTodayFortuneViewDelegate,UITableViewDataSource,UITableViewDelegate,PersonalCenterMyPhotoAlbumsViewDelegate,PayForFortuneViewDelegate,PayForForeverFortuneViewDelegate,VIPViewDelegate>
/** 全屏滚动*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** 导航栏*/
@property (nonatomic, strong) CommonNavigationViews *navi;
/** 头部视图*/
@property (nonatomic, strong) PersonalCenterHeaderView *headerView;
/** 切换家谱及头像视图*/
@property (nonatomic, strong) PersonalCenterInfoView *infoView;
/** 命理视图*/
@property (nonatomic, strong) PersonalCenterNumerologyView *numerologyView;
/** 今日运势视图*/
@property (nonatomic, strong) PersonalCenterTodayFortuneView *todayFortuneView;
/** 求签祈福视图*/
@property (nonatomic, strong)PersonalCenterCliffordView *cliffordView;
/** 家族动态表视图*/
@property (nonatomic, strong) UITableView *familyTreeNewsTB;
/** 个人相册视图*/
@property (nonatomic, strong) PersonalCenterMyPhotoAlbumsView *myPhotoAlbumsView;

/** 个人信息模型*/
@property (nonatomic, strong) QueryModel *queryModel;
/** 个人中心模型*/
@property (nonatomic, strong) MemallInfoModel *memallInfo;
/** 虔诚度模型*/
@property (nonatomic, strong) DevoutModel *devoutModel;


/** 家族动态数组*/
@property (nonatomic, strong) NSArray *familyTreeNewsArr;
/** vip视图*/
@property (nonatomic, strong) VIPView *vipView;
///** 导航栏vip按钮*/
//@property (nonatomic, strong) UIButton *vipBtn;

/** 个人信息编辑页面*/
@property (nonatomic, strong) EditPersonalInfoView *editPersonalInfoView;


@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavi];
    [self.view addSubview:self.scrollView];
    //添加背景图
    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 640)];
    bgIV.image = MImage(@"gr_ct_bg");
    [self.scrollView addSubview:bgIV];
    //添加背景模糊视图
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, 33)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.8;
    [self.view addSubview:bgView];
    
    //初始化界面
    [self initMainView];
    
    [SXLoadingView showProgressHUD:@"正在加载数据" duration:0.5];
    
}

#pragma mark - 获取数据
-(void)getNaviData{
    NSDictionary *logDic = @{@"userid":[NSString stringWithFormat:@"%@",GetUserId]};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeQueryMem success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            //MYLog(@"%@",jsonDic[@"data"]);
            weakSelf.queryModel = [QueryModel modelWithJSON:jsonDic[@"data"]];
            [weakSelf initNaviData];
            
        }else{
            //MYLog(@"%@",jsonDic[@"message"]);
        }
    } failure:^(NSError *error) {
        MYLog(@"失败---%@",error.description);
    }];

}

-(void)getMainData{
    NSDictionary *logDic = @{@"userid":[NSString stringWithFormat:@"%@",GetUserId]};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeGetMemallInfo success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            weakSelf.memallInfo = [MemallInfoModel modelWithJSON:jsonDic[@"data"]];
            [weakSelf initNaviData];
            [weakSelf initMainData];
            [SXLoadingView hideProgressHUD];
            [weakSelf initTodayFortuneView];
            //今日运势数据
            [self.todayFortuneView reloadData:self.memallInfo.grys];
        }else{
            [SXLoadingView showProgressHUD:jsonDic[@"message"] duration:0.5];
        }
    } failure:^(NSError *error) {
        MYLog(@"失败---%@",error.description);
    }];
    
    
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getdevout" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            MYLog(@"虔诚度%@",jsonDic);
            DevoutModel *devoutModel = [DevoutModel modelWithJSON:jsonDic[@"data"]];
            [self.cliffordView reloadDevoutData:devoutModel];
            
        }else{
            
        }
    } failure:^(NSError *error) {
        MYLog(@"失败---%@",error.description);
    }];

}

-(void)getVIPInfoData{
    //获取vip特权信息
    NSDictionary *logDic = @{@"userid":[NSString stringWithFormat:@"%@",GetUserId]};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeGetVIPtq success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        //MYLog(@"%@",jsonDic[@"message"]);
        if (succe) {
            //MYLog(@"%@",jsonDic[@"data"]);
            NSArray<VIPInfoModel *> *arr = [NSArray modelArrayWithClass:[VIPInfoModel class] json:jsonDic[@"data"]];
            weakSelf.vipView = [[VIPView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
            _vipView.delegate = weakSelf;
            [weakSelf.view addSubview:weakSelf.vipView];
            [weakSelf.vipView reloadVIPInfoData:arr];
            [weakSelf getVIPGrowUpData];
        }else{
            
        }
        
    } failure:^(NSError *error) {
        MYLog(@"失败---%@",error.description);
    }];
    
}

-(void)getVIPGrowUpData{
    //获取vip成长值信息
    NSDictionary *logDic = @{@"userid":[NSString stringWithFormat:@"%@",GetUserId]};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getvipczz" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        //MYLog(@"%@",jsonDic[@"message"]);
        if (succe) {
            MYLog(@"%@",jsonDic[@"data"]);
            VIPGrowUpModel *vipGrowUpModel = [VIPGrowUpModel modelWithJSON:jsonDic[@"data"]];
            [weakSelf.vipView reloadVIPGrowUpData:vipGrowUpModel];
        }else{
            
        }
        
    } failure:^(NSError *error) {
        MYLog(@"失败---%@",error.description);
    }];

}

#pragma mark - 视图初始化
-(void)initNavi{
    self.navigationController.navigationBarHidden = YES;
    self.navi = [[CommonNavigationViews alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64) title:@"" image:MImage(@"chec")];
    self.navi.leftBtn.hidden = YES;
    UIButton *personalInfoEditBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 50)];
    
    [personalInfoEditBtn setImage:MImage(@"gr_ct_tit_wt") forState:UIControlStateNormal];
    [personalInfoEditBtn setImage:MImage(@"fanhui") forState:UIControlStateSelected];
    personalInfoEditBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [personalInfoEditBtn addTarget:self action:@selector(clickPersonalInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navi addSubview:personalInfoEditBtn];
//    self.vipBtn = [[UIButton alloc]init];
//    self.vipBtn.titleLabel.font = MFont(15);
//    [self.vipBtn addTarget:self action:@selector(clickVipBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navi addSubview:self.vipBtn];
//    self.vipBtn.sd_layout.leftSpaceToView(personalInfoEditBtn,5).bottomSpaceToView(self.navi,15).widthIs(35).heightIs(15);
    [self.view addSubview:self.navi];
}

-(void)initMainView{
    //添加头部视图
    self.headerView = [[PersonalCenterHeaderView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, 33)];
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
    //切换家谱及头像视图
    self.infoView = [[PersonalCenterInfoView alloc]initWithFrame:CGRectMake(0, 33, Screen_width, 138)];
    [self.scrollView addSubview:self.infoView];
    //命理视图
    self.numerologyView = [[PersonalCenterNumerologyView alloc]initWithFrame:CGRectMake(0, CGRectYH(self.infoView), Screen_width, 175)];
    [self.scrollView addSubview:self.numerologyView];
    //今日运势视图
    
    //求签祈福
    self.cliffordView = [[PersonalCenterCliffordView alloc]initWithFrame:CGRectMake(0.5156*Screen_width, 346, 0.4469*Screen_width, 119)];
    [self.scrollView addSubview:self.cliffordView];
    //家族动态
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectYH(self.cliffordView), Screen_width, 40)];
    [self.scrollView addSubview:tableHeaderView];
    UILabel *familyTreeNewsLB = [[UILabel alloc]initWithFrame:CGRectMake(22, 17, 60, 15)];
    familyTreeNewsLB.text = @"家族动态";
    familyTreeNewsLB.font = MFont(14);
    [tableHeaderView addSubview:familyTreeNewsLB];
    self.familyTreeNewsTB = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectYH(tableHeaderView), Screen_width, 88)];
    self.familyTreeNewsTB.backgroundColor = [UIColor clearColor];
    self.familyTreeNewsTB.bounces = NO;
    self.familyTreeNewsTB.dataSource = self;
    self.familyTreeNewsTB.delegate = self;
    [self.scrollView addSubview:self.familyTreeNewsTB];
    //我的相册
//    self.myPhotoAlbumsView = [[PersonalCenterMyPhotoAlbumsView alloc]initWithFrame:CGRectMake(0, CGRectYH(self.familyTreeNewsTB)+15, Screen_width, 150)];
//    self.myPhotoAlbumsView.delegate = self;
//    [self.scrollView addSubview:self.myPhotoAlbumsView];

    
}

-(void)initTodayFortuneView{
    //今日运势视图
    self.todayFortuneView = [[PersonalCenterTodayFortuneView alloc]initWithFrame:CGRectMake(0.0406*Screen_width, 346, 0.4469*Screen_width, 119)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToFortuneTodayView)];
    [self.todayFortuneView addGestureRecognizer:tap];
    self.todayFortuneView.delegate = self;
    [self.scrollView addSubview:self.todayFortuneView];
}
//导航栏数据刷新
-(void)initNaviData{
    //导航栏数据
    self.navi.titleLabel.text = self.queryModel.memb.MeNickname;
    NSString *vipLevelStr = [NSString stringWithFormat:@"VIP%@",@(self.queryModel.memb.MeViplevel)];
    [USERDEFAULT setObject:vipLevelStr forKey:VIPLevel];
    [self.headerView.vipBtn setTitle:vipLevelStr forState:UIControlStateNormal];
    self.headerView.money = (double)self.queryModel.memb.MeBalance;
    self.headerView.sameCityMoney = self.queryModel.memb.MeIntegral;
    [self.infoView.headIV.headInsideIV setImageWithURL:[NSURL URLWithString:self.queryModel.kzxx.Photo] placeholder:MImage(@"tx_1")];
}
//主界面数据刷新
-(void)initMainData{
    //让金额为登录请求返回的值
    //self.headerView.money =  [[USERDEFAULT valueForKey:@"MeBalance"] doubleValue];
    //self.headerView.sameCityMoney = [[USERDEFAULT valueForKey:@"MeIntegral"] intValue];
    //会员家谱数据
    [self.infoView reloadData:self.memallInfo.hyjp];

    //命理数据
    [self.numerologyView reloadData:self.memallInfo.scbz];
//    //今日运势数据
//    [self.todayFortuneView reloadData:self.memallInfo.grys];
    //求签数据
    [self.cliffordView reloadData:self.memallInfo.grqw];
    //家族动态数据
    [self.familyTreeNewsTB reloadData];
    //个人相册数据
    [self.myPhotoAlbumsView reloadData:self.memallInfo.grxc];
}

#pragma mark - 生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //右侧导航栏按钮隐藏
    [self.navi.rightMenuBtn removeFromSuperview];
    self.navigationController.navigationBarHidden = YES;
    //界面出现就重新加载数据
    [self getMainData];
    [self getNaviData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navi.rightBtn.selected = NO;
}

#pragma mark - 点击事件
//点击个人信息编辑
-(void)clickPersonalInfoBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    MYLog(@"点击个人信息编辑");
    WK(weakSelf)
    if (!sender.selected) {
        //上传数据
        //获取省，市
        NSRange range = [self.editPersonalInfoView.personalInfoDetailArr[3] rangeOfString:@"-"];
        
        NSString *proStr = [self.editPersonalInfoView.personalInfoDetailArr[3] substringToIndex:(range.location)];
        NSString *cityStr = [self.editPersonalInfoView.personalInfoDetailArr[3] substringFromIndex:range.location+1];
        //获取性别
        NSString *sexStr;
        if ([self.editPersonalInfoView.personalInfoDetailArr[4] isEqualToString:@"女"]) {
            sexStr = @"0";
        }else if([self.editPersonalInfoView.personalInfoDetailArr[4] isEqualToString:@"男"]){
            sexStr = @"1";
        }else{
            sexStr = @"2";
        }
        //时间转换(生日)
        NSMutableString *birthdayStr = [NSMutableString stringWithString:self.editPersonalInfoView.personalInfoDetailArr[5]];
        [birthdayStr replaceCharactersInRange:NSMakeRange(4, 1) withString:@"-"];
        [birthdayStr replaceCharactersInRange:NSMakeRange(7, 1) withString:@"-"];
        [birthdayStr replaceCharactersInRange:NSMakeRange(10, 1) withString:@"T"];
        [birthdayStr replaceCharactersInRange:NSMakeRange(13, 1) withString:@":00:00"];
        //爱好
        MYLog(@"%@",[self.editPersonalInfoView getInterestStr]);
        //个人签名
        UITextField *signTX = (UITextField *)[self.editPersonalInfoView viewWithTag:888+11];
        //个人经历
        UITextField *experienceTX = (UITextField *)[self.editPersonalInfoView viewWithTag:888+12];
        NSDictionary *logDic = @{
                                 @"meaccount":[USERDEFAULT valueForKey:UserAccount],
                                 @"mobile":self.editPersonalInfoView.accountInfoDetailArr[3],
                                 @"email":self.editPersonalInfoView.accountInfoDetailArr[4],
                                 @"mename":self.editPersonalInfoView.personalInfoDetailArr[0],
                                 @"menickname":self.editPersonalInfoView.personalInfoDetailArr[1],
                                 @"country":@"中国",
                                 @"province":proStr,
                                 @"city":cityStr,
                                 @"mesex":sexStr,
                                 @"mebirthday":birthdayStr,
                                 @"mecertype":self.editPersonalInfoView.personalInfoDetailArr[6],
                                 @"mecardnum":self.editPersonalInfoView.personalInfoDetailArr[7],
                                 @"occupation":self.editPersonalInfoView.personalInfoDetailArr[8],
                                 @"education":self.editPersonalInfoView.personalInfoDetailArr[9],
                                 @"hobby":[self.editPersonalInfoView getInterestStr],
                                 @"perSign":signTX.text,
                                 @"experience":experienceTX.text
                                 };
        MYLog(@"%@",logDic);
        [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeEditProfile success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            MYLog(@"修改个人资料%@",jsonDic[@"message"]);
            if (succe) {
                [weakSelf getNaviData];
            }else{
                
            }
        } failure:^(NSError *error) {
            MYLog(@"失败---%@",error.description);
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.editPersonalInfoView.frame = CGRectMake(0,64,0,Screen_height-49-64);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.editPersonalInfoView removeFromSuperview];
        });
        
        
    }
    
    
    
    if (sender.selected) {
        dispatch_async(dispatch_queue_create("myQueue", NULL), ^{
            NSDictionary *logDic = @{@"userid":[NSString stringWithFormat:@"%@",GetUserId]};
            
            [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeQueryMem success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                if (succe) {
                    weakSelf.queryModel = [QueryModel modelWithJSON:jsonDic[@"data"]];
                    weakSelf.editPersonalInfoView = [[EditPersonalInfoView alloc]initWithFrame:CGRectMake(0, 64, 0, Screen_height-49-64)];
                    [self.view addSubview:self.editPersonalInfoView];
                    
                    [weakSelf.editPersonalInfoView reloadEditPersonalInfoData:weakSelf.queryModel];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        weakSelf.editPersonalInfoView.frame = CGRectMake(0, 64, Screen_width, Screen_height-49-64);
                    }];
                }else{
                }
            } failure:^(NSError *error) {
                MYLog(@"失败---%@",error.description);
            }];
            
            //生成职业plist文件
            NSDictionary *logDic1 = @{@"typeval":@"GRZY"};
            
            [TCJPHTTPRequestManager POSTWithParameters:logDic1 requestID:GetUserId requestcode:kRequestCodeGetsyntype success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                MYLog(@"%@",jsonDic[@"message"]);
                if (succe) {
                    NSArray<JobModel *> *arr = [NSArray modelArrayWithClass:[JobModel class] json:jsonDic[@"data"]];
                    NSMutableArray *mutableArr = [NSMutableArray array];
                    JobModel *jobModel = [[JobModel alloc]init];
                    for (jobModel in arr) {
                        [mutableArr addObject:jobModel.syntype];
                    }
                    NSString *filePath = [UserDocumentD stringByAppendingPathComponent:@"job.plist"];
                    [mutableArr writeToFile:filePath atomically:YES];
                }else{
                }
            } failure:^(NSError *error) {
                MYLog(@"失败---%@",error.description);
            }];
            
            
            
            //生成地区plist文件
            NSDictionary *logDic2 = @{@"country":@"中国"};
            [TCJPHTTPRequestManager POSTWithParameters:logDic2 requestID:GetUserId requestcode:kRequestCodeGetprovince success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                
                if (succe) {
                    NSArray<AreaModel *> *arr = [NSArray modelArrayWithClass:[AreaModel class] json:jsonDic[@"data"]];
                    NSMutableArray *mutableArr = [NSMutableArray array];
                    AreaModel *areaModel = [[AreaModel alloc]init];
                    for (areaModel in arr) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        [dic setObject:areaModel.proname forKey:@"proname"];
                        [dic setObject:areaModel.cityname forKey:@"cityname"];
                        [mutableArr addObject:dic];
                    }
                    NSString *filePath = [UserDocumentD stringByAppendingPathComponent:@"area.plist"];
                    
                    [mutableArr writeToFile:filePath atomically:YES];
                }else{
                }
            } failure:^(NSError *error) {
                MYLog(@"失败---%@",error.description);
            }];
            

        });

        
    }
    
    
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.memallInfo.jzdt.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.memallInfo.jzdt[indexPath.row].artitle;
    cell.textLabel.font = MFont(12);
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = indexPath.row%2?[UIColor clearColor]:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:0.5];
    cell.textLabel.textColor = LH_RGBCOLOR(118, 118, 118);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 22;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewInfoViewController *newInfoVC = [[NewInfoViewController alloc]initWithTitle:@"新闻详情" image:nil];
    newInfoVC.arId = [self.memallInfo.jzdt[indexPath.row].arid intValue];
    [self.navigationController pushViewController:newInfoVC animated:YES];
}


#pragma mark - lazyLoad
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-49-64)];
        _scrollView.contentSize = CGSizeMake(Screen_width, 640);
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

#pragma mark - PersonalCenterHeaderViewDelegate
-(void)clickMoneyViewToPay{
    //跳转充值页面
//    RechargeViewController *rechargeVC = [[RechargeViewController alloc]init];
//    [self.navigationController pushViewController:rechargeVC animated:YES];
}

-(void)clickSameCityMoneyViewToPay{
    //跳转同城币充值页面
    MYLog(@"跳转同城币支付页面");
}

-(void)clickVipBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
        if (sender.selected == YES) {
            [self getVIPInfoData];
        }else{
            [self.vipView removeFromSuperview];
        }
}

-(void)ToFortuneTodayView{
    if ([[USERDEFAULT objectForKey:@"vipLevel"] intValue] == 0) {
        [SXLoadingView showAlertHUD:@"您还不是会员" duration:0.5];
    }else{
    FortuneTodayViewController *fortuneTodayVC = [[FortuneTodayViewController alloc]initWithTitle:@"今日运势" image:nil];
    [self.navigationController pushViewController:fortuneTodayVC animated:YES];
    }
}

#pragma mark - PersonalCenterTodayFortuneViewDelegate
-(void)clickPayForFortuneBtn{
    MYLog(@"跳转续时运势页面");
    PayForFortuneView *payForFortuneView = [[PayForFortuneView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
    payForFortuneView.delegate = self;
    [self.view addSubview:payForFortuneView];
    
}

#pragma mark - PersonalCenterMyPhotoAlbumsViewDelegate
-(void)clickMoreBtnTo{
    MYLog(@"跳转我的相册");
}

#pragma mark - PayForFortuneViewDelegate
-(void)toPayForForeverFortuneView{
    MYLog(@"跳转续时永久页面");
    PayForForeverFortuneView *payForForeverFortuneView = [[PayForForeverFortuneView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
    payForForeverFortuneView.delegate = self;
    [self.view addSubview:payForForeverFortuneView];
}

#pragma mark - PayForForeverFortuneViewDelegate
-(void)clickPayForForeverFortuneSure{
    SettlementCenterViewController *settlementCenterVC = [[SettlementCenterViewController alloc]init];
    [self.navigationController pushViewController:settlementCenterVC animated:YES];
}

#pragma mark - VIPViewDelegate
-(void)clickVipBackBtn{
    self.headerView.vipBtn.selected = NO;
}


@end
