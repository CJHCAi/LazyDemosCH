//
//  ManagerFamilyViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ManagerFamilyViewController.h"
#import "WRollDetailView.h"
#import "WSwitchDetailFamView.h"
#import "WAddJPPersonView.h"

#define ScroHeight 1700

@interface ManagerFamilyViewController ()<WswichDetailFamViewDelegate,WAddJPPersonViewDelegate>

{
    BOOL _selectedRollView;//是否选择了某个卷谱
    BOOL _selectedADDView;//是否选择了添加按钮
    BOOL _selectedADDBtn;//是否选择了新增卷谱俺就
    
    CGSize _contentSize;
    
    NSMutableArray *_titleArr;//卷谱名array
    
    NSMutableDictionary *_addJPDic;/** 添加卷谱信息里面的，名字--成员id 键值对 */
    
    /** 有多少种卷谱1-5为一种，5-9为一种，9-13为一种 */
    NSMutableArray *_JPTypeArr;
    
    /** 每种卷 */
    NSInteger _selecetdJPDsId;
    
    /** 所有卷谱的frameArr */
    NSMutableArray *_JPframeArr;
    
    /** 所有卷谱的id */
    NSMutableArray *_JPAllId;
}

@property (nonatomic,strong) UIScrollView *backScrollView; /*背景滚动图*/

@property (nonatomic,strong) UIImageView *famImage; /*家谱名字图腾*/

@property (nonatomic,strong) UILabel *famName; /*家谱名*/


@property (nonatomic,strong) UIButton *switchFam; /*切换家谱*/

@property (nonatomic,strong) WRollDetailView *detailView; /*具体人数等*/

@property (nonatomic,strong) WSwitchDetailFamView *switchDetailView; /*点击切换家谱之后的显示*/

@property (nonatomic,strong) CreateFamModel *famModel; /*家谱信息model*/

/**添加卷谱的大加号按钮*/
@property (nonatomic,strong) WAddJPPersonView *addJpPersonView;

/**添加卷谱按钮*/
@property (nonatomic,strong) UIButton *addJPBtn;

@end

@implementation ManagerFamilyViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:MImage(@"gljp_bg")];
    if ([USERDEFAULT objectForKey:kNSUserDefaultsMyFamilyID]) {
        [WFamilyModel shareWFamilModel].myFamilyId = [USERDEFAULT objectForKey:kNSUserDefaultsMyFamilyID];
    }
    
    [self initData];
    [self getJpTypeLayoutArrayCallback:^{
        
        [self initUI];
    }];

}

#pragma mark *** 初始化数据 ***
-(void)initData{
    _titleArr = [@[@"段正淳1|5代卷谱",@"段志兴6|9代卷谱",@"段志兴6 | 9代卷谱",@"段志兴10|15代卷谱",@"段志兴10|15代卷谱",@"段志兴10|15代卷谱"] mutableCopy];
    _addJPDic = [NSMutableDictionary dictionary];
    _JPTypeArr = [@[] mutableCopy];
    _JPframeArr = [@[] mutableCopy];
    _JPAllId = [@[] mutableCopy];
    _contentSize = CGSizeMake(ZeroContentOffset, 0);
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.backScrollView];
    [self.view addSubview:self.switchFam];
    [self initAllRollView];
    [self.backScrollView addSubview:self.famImage];
    [self.view bringSubviewToFront:self.switchFam];
}
//初始化所有家眷
-(void)initAllRollView{
    [_JPframeArr removeAllObjects];
    [_JPAllId removeAllObjects];
    for (int idx = 0; idx<_JPTypeArr.count; idx++) {
        NSArray *detailArr = _JPTypeArr[idx];
        for (int idx2 = 0; idx2<detailArr.count; idx2++) {
            
            NSString *JPName = [NSString stringWithFormat:@"%@%@|%@代卷谱",detailArr[idx2][@"jpname"],detailArr[idx2][@"minlevel"],detailArr[idx2][@"maxlevel"]];
            
            RollView *rollView = [[RollView alloc] initWithFrame:AdaptationFrame(_contentSize.width+383-185*idx2, 30+413*idx, 131, 358) withTitle:JPName rollType:idx>1?RollViewTypeDecade:RollViewTypeUnitsDigit];
            rollView.rollJPName = JPName;
            [_JPframeArr addObject:[NSValue valueWithCGRect:rollView.frame]];
            [_JPAllId addObject:_JPTypeArr[idx][idx2][@"genmeid"]];
            rollView.tag = idx;
            
            //添加手势
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToRooTapGes:)];
            
            [rollView addGestureRecognizer:tapGes];
            
            [self.backScrollView addSubview:rollView];
        }
    }

}

#pragma mark *** 更新UI ***
-(void)reloadUI{
    
    [self.backScrollView removeAllSubviews];
    
    NSInteger maxCountX = [self maxJPArrCount]>4?[self maxJPArrCount]-4:0;
    NSInteger maxCountY = _JPTypeArr.count>3?_JPTypeArr.count-3:0;
    
    //更新背景滚动图大小
    self.backScrollView.contentSize = AdaptationSize(720+ZeroContentOffset+185*(maxCountX), ScroHeight+maxCountY*413);
        
    _contentSize = CGSizeMake(ZeroContentOffset+185*(maxCountX), 0);
    
//    _backScrollView.contentOffset = AdaptationCenter(ZeroContentOffset+185*(maxCountX), 0);
    
    self.famImage.frame = AdaptationFrame(560+_contentSize.width, 30, 131, 358);
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _backScrollView.contentSize.width, _backScrollView.contentSize.height)];
    
    backView.backgroundColor = [UIColor colorWithPatternImage:MImage(@"gljp_bg")];
    
    [self.backScrollView addSubview:backView];
    
    [self.backScrollView addSubview:self.famImage];
    
    self.famName.text = [NSString verticalStringWith:[WFamilyModel shareWFamilModel].myFamilyName];

    [self initAllRollView];
    
}
-(NSInteger)maxJPArrCount{
    __block NSInteger maxCount = 0;
    [_JPTypeArr enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.count>maxCount) {
            maxCount = obj.count;
        }
    }];
    
    return maxCount;
}
#pragma mark *** events ***
/** 每个视图的手势 */
-(void)respondsToRooTapGes:(UITapGestureRecognizer *)gesture{
    
    _selecetdJPDsId = gesture.view.tag;
    
    _selectedRollView = !_selectedRollView;
    if (_selectedRollView) {
        
        NSString *jpName = ((RollView *)gesture.view).rollJPName;
        [WDetailJPInfoModel sharedWDetailJPInfoModel].currentJPName = jpName;
        [WDetailJPInfoModel sharedWDetailJPInfoModel].currentJPIdx = gesture.view.tag;
        WRollDetailView * detailView = [[WRollDetailView alloc] initWithFrame:AdaptationFrame(CGRectGetMinX(gesture.view.frame)/AdaptationWidth()-271, gesture.view.frame.origin.y/AdaptationWidth(), 271, 355) ];
        self.detailView = detailView;
        
        self.detailView.userInteractionEnabled = false;
        
        [self.backScrollView addSubview:self.detailView];
        
        [self getZBInfoWithDs:gesture.view.tag whileComplete:^{
            [detailView updateUI];
            
            [self getAddJPPerWithJPId:_JPTypeArr[_selecetdJPDsId][0][@"genmeid"]  whileComplet:^{
                
                self.detailView.userInteractionEnabled = true;
                
                [WDetailJPInfoModel sharedWDetailJPInfoModel].currentJPID = _JPTypeArr[_selecetdJPDsId][0][@"genmeid"];
                
            }];
  
        }];
        
    }else{
       [self.detailView removeFromSuperview];
    }

}
//切换家谱事件
-(void)respondsToSwitchFam:(UIButton *)sender{
        [self.view addSubview:self.switchDetailView];
        [self.view bringSubviewToFront:self.switchDetailView];
        self.switchFam.hidden = YES;
}

/** 删除家谱事件 */

-(void)respondsToDeleteBtn:(UIButton *)sender{
    //卷谱id
    NSString *gemeId = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    [Tools showAlertViewcontrollerWithTarGet:self Message:@"确定删除此卷谱吗？" complete:^(BOOL sure) {
        if (sure) {
            [TCJPHTTPRequestManager POSTWithParameters:@{@"GeId":[WFamilyModel shareWFamilModel].myFamilyId,@"GemeId":gemeId,@"IsJp":@""} requestID:GetUserId requestcode:kRequestCodechangejp success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                if (succe) {
                    
                    [self getJpTypeLayoutArrayCallback:^{
                        [self reloadUI];
                        [SXLoadingView hideProgressHUD];
                    }];
                    
                }
            } failure:^(NSError *error) {
                
            }];
        }else{
            return;
        }
    }];
    
}

/** 点击添加按钮出现人名 */
-(void)respondsToAddJpBtn:(UIButton *)sender{
    
    _selectedADDView = !_selectedADDView;
    
    if (_selectedADDView) {
        NSString *daishu = [NSString stringWithFormat:@"%ld",(long)5+4*sender.tag];
        [self getAddJpPossibleMemberWithDs:daishu complete:^(NSDictionary *jsonDic) {
            
            WGennerationModel *model = [WGennerationModel modelWithJSON:jsonDic[@"data"]];
            //如果有值
            if (model.datalist &&model.datalist.count!=0) {
                NSMutableArray *fatherArr = [@[] mutableCopy];
                
                NSArray<WGeDatalist *> *arr = model.datalist;
                
                [_addJPDic removeAllObjects];
                for (int idx = 0; idx<arr[0].datas.count; idx++) {
                    
                    [fatherArr addObject:arr[0].datas[idx].name];
                    
                    [_addJPDic setObject:@(arr[0].datas[idx].gemeid) forKey:arr[0].datas[idx].name];
                    
                }
                WAddJPPersonView *addPer = [[WAddJPPersonView alloc] initWithFrame:AdaptationFrame(sender.frame.origin.x/AdaptationWidth()-162, sender.frame.origin.y/AdaptationWidth()+5, 162, 211) forPersonArr:fatherArr];
                addPer.userInteractionEnabled = true;
                addPer.delegate = self;
                self.addJpPersonView = addPer;
                [self.backScrollView addSubview:self.addJpPersonView];
                
                if (fatherArr.count == 0) {
                    
                    [SXLoadingView showAlertHUD:@"没有可以添加的家谱" duration:1.0];
                    
                }
                
            }else{
                [SXLoadingView showAlertHUD:@"没有可以添加的家谱" duration:1.0];
            }
            
        }];
    }else{
        [self.addJpPersonView removeFromSuperview];
    }
    
}

/** 获取可以添加卷谱的成员 */

-(void)getAddJpPossibleMemberWithDs:(NSString *)member complete:(void(^)(NSDictionary *jsonDic))back{
    [TCJPHTTPRequestManager POSTWithParameters:@{@"geid":[WFamilyModel shareWFamilModel].myFamilyId,
                                                 @"query":@"",
                                                 @"pagenum":@"1",
                                                 @"pagesize":@"20",
                                                 @"ds":member} requestID:GetUserId requestcode:kRequestCodequeryzbgemelist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                     if (succe) {
                                                         NSLog(@"asdasd---%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
                                                         back(jsonDic);
                                                     }
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
}

/** 获取卷谱，然后将其分类 */
-(void)getJpTypeLayoutArrayCallback:(void (^)())back{
    [SXLoadingView showProgressHUD:@"正在加载.."];
    [self getAllFamJPCallBackJPDetailArray:^(NSArray<NSDictionary *> *JPArray) {
        [_JPTypeArr removeAllObjects];
        NSMutableArray *JpTypeGenArr = [@[] mutableCopy];
        if (JPArray.count == 1) {
            
            [JpTypeGenArr addObject:JPArray[0]];
            NSArray *arr = [NSArray arrayWithArray:JpTypeGenArr];
            
            [_JPTypeArr addObject:arr];
       
        }
        for (int idx = 1; idx<JPArray.count; idx++) {
            
            if ([[NSString stringWithFormat:@"%@",JPArray[idx][@"maxlevel"]]
                 isEqualToString:
                 [NSString stringWithFormat:@"%@",JPArray[idx-1][@"maxlevel"]]] ) {
                
                [JpTypeGenArr addObject:JPArray[idx-1]];
                
                if (idx==JPArray.count-1) {
                    [JpTypeGenArr addObject:JPArray[idx]];
                    NSArray *arr = [NSArray arrayWithArray:JpTypeGenArr];
                    
                    [_JPTypeArr addObject:arr];
                }
            }else{
                [JpTypeGenArr addObject:JPArray[idx-1]];
                
                NSArray *arr = [NSArray arrayWithArray:JpTypeGenArr];
                
                [_JPTypeArr addObject:arr];
                
                [JpTypeGenArr removeAllObjects];
                
                if (idx==JPArray.count-1) {
                    [JpTypeGenArr addObject:JPArray[idx]];
                    NSArray *arr = [NSArray arrayWithArray:JpTypeGenArr];
                    
                    [_JPTypeArr addObject:arr];
                }
            }
        }
        back();
        [SXLoadingView hideProgressHUD];
    }];

}

#pragma mark *** WAddJPPersonViewDelegate ***

/** 添加卷谱 */
-(void)WAddJPPersonViewDelegate:(WAddJPPersonView *)addView didSelectedBtn:(UIButton *)sender{
    NSString *clickName = sender.titleLabel.text;
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"GeId":[WFamilyModel shareWFamilModel].myFamilyId,@"GemeId":_addJPDic[clickName],@"IsJp":@"1"} requestID:GetUserId requestcode:kRequestCodechangejp success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            [self getJpTypeLayoutArrayCallback:^{
                [self reloadUI];
                [SXLoadingView hideProgressHUD];
            }];
            
        }
    } failure:^(NSError *error) {
        
    }];
   
}

#pragma mark *** WswithDelegate ***
/** 切换家谱view协议 */
-(void)WswichDetailFamViewDelegate:(WSwitchDetailFamView *)detaiView didSelectedButton:(UIButton *)sender repeatNameIndex:(NSInteger)repeatIndex{
    
    NSString *searchTitle = sender.titleLabel.text;
    
    if ([searchTitle isEqualToString:@"切换家谱"]) {
        [_switchDetailView removeFromSuperview];
        self.switchFam.hidden = false;
    }else if ([searchTitle isEqualToString:@"创建家谱"]){
        CreateFamViewController *crefa = [[CreateFamViewController alloc] initWithTitle:@"创建家谱" image:nil];
        [self.navigationController pushViewController:crefa animated:YES];
    }else if ([searchTitle isEqualToString:@"新增卷谱"]){
        if (!_JPTypeArr.count||_JPTypeArr.count==0) {
            [SXLoadingView showAlertHUD:@"没有家谱，请先新建家谱" duration:0.5];
            return;
        }
            [self getAddJPPerWithJPId:_JPTypeArr[0][0][@"genmeid"] whileComplet:^{
                
                for (int idx = 0; idx<_JPTypeArr.count; idx++) {
                    
                    CGFloat jpBtnFrameX = 0;
                    
                    NSInteger amount = _JPTypeArr.count>1?((NSArray *)(_JPTypeArr[1])).count:0;
                    
                    jpBtnFrameX = _contentSize.width+383-185*amount;
                    
                    UIButton *jpBtn = [[UIButton alloc] initWithFrame:AdaptationFrame(jpBtnFrameX, 30+413, 131, 358)];
                    jpBtn.tag = idx;
                    if (idx>=1) {
                        
                        CGFloat jpBtnFrameX2 = 0;
                        
                        NSInteger amountOther = _JPTypeArr.count>idx+1?((NSArray *)(_JPTypeArr[idx+1])).count:0;
                        
                        jpBtnFrameX2 = _contentSize.width+383-185*amountOther;
                        
                        jpBtn.frame = AdaptationFrame(jpBtnFrameX2, 30+413*(idx+1), 131, 358);
                    }
                    [jpBtn setImage:MImage(@"addJP") forState:0];
                    [jpBtn addTarget:self action:@selector(respondsToAddJpBtn:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.backScrollView addSubview:jpBtn];
                }
   
            }];
        
    }else if ([searchTitle isEqualToString:@"删除卷谱"]){
        
        for (int idx = 0; idx<_JPframeArr.count; idx++) {
            CGRect rect = [_JPframeArr[idx] CGRectValue];
            
            UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(rect.origin.x+rect.size.width-10, rect.origin.y-10, 20, 20)];
            closeBtn.tag = [_JPAllId[idx] integerValue];
            [closeBtn addTarget:self action:@selector(respondsToDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
            [closeBtn setImage:MImage(@"close") forState:0];
        
            [self.backScrollView addSubview:closeBtn];
            
        }

    }
    else{
        //网络请求家谱详情
        [SXLoadingView showProgressHUD:@"正在加载"];
        
            [self posGetDetailFamInfoWithID:[WSelectMyFamModel sharedWselectMyFamModel].myFamIdArray[repeatIndex] callBack:^(id respondsDic) {
                //设置当前家谱id
                [WFamilyModel shareWFamilModel].myFamilyId = [WSelectMyFamModel sharedWselectMyFamModel].myFamIdArray[repeatIndex];
                [WFamilyModel shareWFamilModel].myFamilyName = searchTitle;
                
                [USERDEFAULT setObject:[WSelectMyFamModel sharedWselectMyFamModel].myFamIdArray[repeatIndex] forKey:kNSUserDefaultsMyFamilyID];
                [USERDEFAULT setObject:searchTitle forKey:kNSUserDefaultsMyFamilyName];

                WK(weakSelf)
                //将点击家谱名，获取到id，再根据id获取到的家谱详情传到famModel里
                 weakSelf.famModel = [CreateFamModel modelWithJSON:respondsDic[@"data"]];
                
                [self getJpTypeLayoutArrayCallback:^{
                     [self reloadUI];
                    [SXLoadingView hideProgressHUD];
                }];
            }];
    }
}

#pragma mark *** 请求家谱信息 ***
/** 根据点击名字获取id，（如果有多个，取点击的第某个）将第一个此家谱名的id */
-(void)postGetFamInfoWithtitle:(NSString *)title callBack:(void (^)(NSArray *genIDArr))callback{
    //网络请求家谱详情
    [TCJPHTTPRequestManager POSTWithParameters:@{@"query":title,@"type":@"MyGen"} requestID:GetUserId requestcode:kRequestCodequerymygen success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSMutableArray *idArr = [@[] mutableCopy];
            for (NSDictionary *dic in [NSString jsonArrWithArr:jsonDic[@"data"]]) {
                
                [idArr addObject:dic[@"Geid"]];
                
            }
            callback(idArr);
        }else{
            [SXLoadingView showAlertHUD:@"???" duration:0.5];
        }
    } failure:^(NSError *error) {
        
    }];
}
/** 请求家谱id */
-(void)posGetDetailFamInfoWithID:(NSString *)genId callBack:(void (^)(id respondsDic))callBack{
    [TCJPHTTPRequestManager POSTWithParameters:@{@"geid":genId} requestID:GetUserId requestcode:kRequestCodeQuerygendata success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            callBack(jsonDic);
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 获取卷谱列表 */
-(void)getAllFamJPCallBackJPDetailArray:(void (^)(NSArray <NSDictionary *>*JPArray))callBack{
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"genid":[WFamilyModel shareWFamilModel].myFamilyId} requestID:GetUserId requestcode:kRequestCodequeryjplist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSArray *sda = [NSString jsonArrWithArr:jsonDic[@"data"]];
            
            NSLog(@"卷谱列表----%@", sda);
            
            callBack(sda);
        }
    } failure:^(NSError *error) {
        MYLog(@"失败");
    }];
}


/** 查询卷谱的字辈信息 */

-(void)getZBInfoWithDs:(NSInteger)dsID whileComplete:(void(^)())back{
    
        [self getJPPersonNumWithJPId:_JPTypeArr[dsID][0][@"genmeid"] complete:^{
            back();
        }];
    
}

/** 根据卷谱id查询可添加的人 */
-(void)getAddJPPerWithJPId:(NSString *)jpId whileComplet:(void (^)())back{
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"gemeid":jpId,
                                                 @"geid":[WFamilyModel shareWFamilModel].myFamilyId,
                                                 @"sex":@""} requestID:GetUserId requestcode:kRequestCodequeryzbgemedetaillist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            WDetailJPInfoModel *detailJP = [WDetailJPInfoModel modelWithJSON:jsonDic[@"data"]];
            [WDetailJPInfoModel sharedWDetailJPInfoModel].datalist = detailJP.datalist;
            
            back();
                        
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 根据卷谱查询卷谱总人数以及各字辈人数 */

-(void)getJPPersonNumWithJPId:(NSString *)jpId complete:(void (^)())callback{
    [TCJPHTTPRequestManager POSTWithParameters:@{@"gemeid":jpId,@"geid":[WFamilyModel shareWFamilModel].myFamilyId} requestID:GetUserId requestcode:kRequestCodequerygezblist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSLog(@"---字辈详情%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
            WJPPersonZBNumberModel *theModel = [WJPPersonZBNumberModel modelWithJSON:jsonDic[@"data"]];
            [WJPPersonZBNumberModel sharedWJPPersonZBNumberModel].allcnt = theModel.allcnt;
            [WJPPersonZBNumberModel sharedWJPPersonZBNumberModel].datalist = theModel.datalist;
            callback();
            
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark *** getters ***
-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar)];
        
        _backScrollView.contentSize = AdaptationSize(ZeroContentOffset+720, ScroHeight);
        _backScrollView.bounces = false;
        
        NSInteger maxCountX  = [self maxJPArrCount]>4?[self maxJPArrCount]-4:0;
        
        NSInteger maxCountY = _JPTypeArr.count>3?_JPTypeArr.count-3:0;
        
        _backScrollView.contentSize = AdaptationSize(720+ZeroContentOffset+185*(maxCountX), ScroHeight+maxCountY*413);
        
        _contentSize = CGSizeMake(ZeroContentOffset+185*(maxCountX), 0);
        
        _backScrollView.contentOffset = AdaptationCenter(ZeroContentOffset+185*(maxCountX), 0);
        
        self.famImage.frame = AdaptationFrame(560+_contentSize.width, 30, 131, 358);
        
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _backScrollView.contentSize.width, _backScrollView.contentSize.height)];
        backView.image = MImage(@"gljp_bg");
        backView.contentMode = UIViewContentModeScaleToFill;
        
        [_backScrollView addSubview:backView];
        
    }
    return _backScrollView;
}

-(UIImageView *)famImage{
    if (!_famImage) {
        _famImage = [[UIImageView alloc] initWithFrame:AdaptationFrame(560+_contentSize.width, 30, 131, 358)];
        _famImage.image = MImage(@"jp_IMG");
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(0, 15, 131, 325)];
        nameLabel.text = [NSString verticalStringWith:[WFamilyModel shareWFamilModel].myFamilyName];
        nameLabel.textAlignment = 1;
        nameLabel.numberOfLines = 0;
        nameLabel.font = WFont(35);
        _famName = nameLabel;
        [_famImage addSubview:_famName];
    }
    return _famImage;
}


-(UIButton *)switchFam{
    if (!_switchFam) {
        _switchFam = [[UIButton alloc] initWithFrame:AdaptationFrame(660, 413+self.comNavi.frame.size.height/AdaptationWidth(), 62, 200)];
        _switchFam.backgroundColor = [UIColor blackColor];
        _switchFam.alpha = 0.7;
        [_switchFam setTitle:@"切换家谱" forState:0];
        _switchFam.titleLabel.numberOfLines = 0;
        _switchFam.titleLabel.font = WFont(33);
        [_switchFam addTarget:self action:@selector(respondsToSwitchFam:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchFam;
}

-(WSwitchDetailFamView *)switchDetailView{
    if (!_switchDetailView) {
        _switchDetailView = [[WSwitchDetailFamView alloc] initWithFrame:AdaptationFrame(self.view.bounds.size.width/AdaptationWidth()-187, 395+143, 187, 600) famNamesArr:[WSelectMyFamModel sharedWselectMyFamModel].myFamArray];
        _switchDetailView.delegate = self;
    }
    return _switchDetailView;
}


-(UIButton *)addJPBtn{
    if (!_addJPBtn) {
        _addJPBtn = [[UIButton alloc] initWithFrame:AdaptationFrame(_contentSize.width+50, 600, 131, 358)];
        [_addJPBtn setImage:MImage(@"addJP") forState:0];
        [_addJPBtn addTarget:self action:@selector(respondsToAddJpBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addJPBtn;
}
@end



