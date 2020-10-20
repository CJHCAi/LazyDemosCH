
//
//  WSearchDetailViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/14.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WSearchDetailViewController.h"

#import "WRollDetailView.h"
#import "WSwitchDetailFamView.h"
#import "WAddJPPersonView.h"
#import "WSearchZBView.h"
#import "WApplyJoinView.h"
@interface WSearchDetailViewController ()
{
    /** 是否点击了某个卷谱 */
    BOOL _selectedRollView;
    
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
    
    CGSize _contentSize;
    
}

@property (nonatomic,strong) UIScrollView *backScrollView; /*背景滚动图*/

@property (nonatomic,strong) UIImageView *famImage; /*家谱名字图腾*/

@property (nonatomic,strong) UILabel *famName; /*家谱名*/

@property (nonatomic,strong) WRollDetailView *detailView; /*具体人数等*/

/**字辈model*/
@property (nonatomic,strong) WJPPersonZBNumberModel *zbModel;

/**字辈图*/
@property (nonatomic,strong) WSearchZBView *zbView;

/**申请加入btn*/
@property (nonatomic,strong) UIButton *applyJoinBtn;

/**申请加入家谱填写信息View*/
@property (nonatomic,strong) WApplyJoinView *joinView;



@end

@implementation WSearchDetailViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:MImage(@"gljp_bg")];
    [self initData];
    //请求点击的家谱id
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
    [self initAllRollView];
    [self.backScrollView addSubview:self.famImage];
    [self.view addSubview:self.applyJoinBtn];
    [self.view bringSubviewToFront:self.comNavi];
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

//计算卷谱分卷后的最大卷谱数
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
        
        self.zbView = [[WSearchZBView alloc] initWithFrame:AdaptationFrame(CGRectGetMinX(gesture.view.frame)/AdaptationWidth()-125, gesture.view.frame.origin.y/AdaptationWidth(), 125, 355)];
        
        [self.backScrollView addSubview:self.zbView];
        [self getZBInfoWithDs:gesture.view.tag whileComplete:^{
            
            
//            self.zbModel
            NSMutableArray *zbArr = [@[] mutableCopy];
            
            [self.zbModel.datalist enumerateObjectsUsingBlock:^(WJPZBDatalist * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [zbArr addObject:obj.zb];
            }];
            
            [self.zbView reloadWithZBArr:zbArr];
            
        }];
        
    }else{
        [self.zbView removeFromSuperview];
    }

}

/** 申请加入家谱 */
-(void)respondsToApplyJoinBtn{
    self.joinView.alpha = 0;
    [self.view addSubview:self.joinView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.joinView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

#pragma mark *** 请求家谱信息 ***
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



/** 获取卷谱列表 */
-(void)getAllFamJPCallBackJPDetailArray:(void (^)(NSArray <NSDictionary *>*JPArray))callBack{
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"genid":[WSearchModel shardSearchModel].selectedFamilyID} requestID:GetUserId requestcode:kRequestCodequeryjplist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSArray *sda = [NSString jsonArrWithArr:jsonDic[@"data"]];
            
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

/** 根据卷谱查询卷谱总人数以及各字辈人数 */

-(void)getJPPersonNumWithJPId:(NSString *)jpId complete:(void (^)())callback{
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"gemeid":jpId,@"geid":[WSearchModel shardSearchModel].selectedFamilyID} requestID:GetUserId requestcode:kRequestCodequerygezblist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            
            NSLog(@"字辈人数详情--%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
            WJPPersonZBNumberModel *theModel = [WJPPersonZBNumberModel modelWithJSON:jsonDic[@"data"]];
            self.zbModel = theModel;
            callback();
            
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 根据卷谱id查询可添加的人 */
-(void)getAddJPPerWithJPId:(NSString *)jpId whileComplet:(void (^)(NSDictionary *backDic))back{
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"gemeid":jpId,
                                                 @"geid":[WSearchModel shardSearchModel].selectedFamilyID,
                                                 @"sex":@""} requestID:GetUserId requestcode:kRequestCodequeryzbgemedetaillist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                     if (succe) {
                                                         back(jsonDic[@"data"]);
                                                     }
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
}

#pragma mark *** getters ***
-(UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar)];
        _backScrollView.contentSize = AdaptationSize(ZeroContentOffset+720, 1500);
        _backScrollView.bounces = false;
        
        NSInteger maxCountX  = [self maxJPArrCount]>4?[self maxJPArrCount]-4:0;
        NSInteger maxCountY = _JPTypeArr.count>3?_JPTypeArr.count-3:0;
        _backScrollView.contentSize = AdaptationSize(720+ZeroContentOffset+185*(maxCountX), 1500+maxCountY*413);
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
        nameLabel.text = [NSString verticalStringWith:[WSearchModel shardSearchModel].selectedFamilyName];
        nameLabel.textAlignment = 1;
        nameLabel.numberOfLines = 0;
        nameLabel.font = WFont(35);
        _famName = nameLabel;
        [_famImage addSubview:_famName];
    }
    return _famImage;
}
-(UIButton *)applyJoinBtn{
    if (!_applyJoinBtn) {
        _applyJoinBtn = [[UIButton alloc] initWithFrame:AdaptationFrame(Screen_width/AdaptationWidth()-161, CGRectYH(self.famImage)/AdaptationWidth()+32+140, 161, 57)];
        [_applyJoinBtn setTitle:@"申请加入" forState:0];
        [_applyJoinBtn setTitleColor:[UIColor whiteColor] forState:0];
        _applyJoinBtn.titleLabel.font = WFont(30);
        _applyJoinBtn.backgroundColor = [UIColor blackColor];
        _applyJoinBtn.alpha = 0.8;
        _applyJoinBtn.layer.cornerRadius = 3;
        [_applyJoinBtn addTarget:self action:@selector(respondsToApplyJoinBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _applyJoinBtn;
}
-(WApplyJoinView *)joinView{
    if (!_joinView) {
        _joinView = [[WApplyJoinView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar) checkType:WApplyJoinViewNeedCheck];
    }
    return _joinView;
}
@end



