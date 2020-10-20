//
//  ShoppingFirestViewController.m
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ShoppingFirestViewController.h"
#import "ShoppingTypeView.h"
#import "HotActiveView.h"
#import "NeedRushView.h"
#import "GuessLikeView.h"
#import "TypeView.h"
#import "WShopSearchViewController.h"
#import "BannerView.h"

@interface ShoppingFirestViewController ()<ShoppingTypeViewDelegate,HotActiveViewDelegate,NeedRushViewDelegate,GuessLikeViewDelegate,TypeViewDelegate,TopSearchViewDelegate>
/**
 *  商城种类视图
 */
@property (strong,nonatomic) ShoppingTypeView *shoppingTypeV;
/**
 *  热门活动
 */
@property (strong,nonatomic) HotActiveView *hotActiveV;
/**
 *  必抢
 */
@property (strong,nonatomic) NeedRushView *needRushView;
/**
 *  喜欢
 */
@property (strong,nonatomic) GuessLikeView *guessLikeV;

@property (strong,nonatomic) UIView *hotV;
/**
 *  热门数据
 */
@property (strong,nonatomic) NSArray *hotArr;
/**
 *  必抢数据
 */
@property (strong,nonatomic) NSArray *rushArr;
/**
 *  猜你喜欢数据
 */
@property (strong,nonatomic) NSArray *likeArr;

@property (strong,nonatomic) UIScrollView *backV;

@property (strong,nonatomic) TypeView *typeV;

@property (strong,nonatomic) NSArray *typeArr;

@property (nonatomic,strong) TopSearchView *topSearchView; /*顶部搜索*/

/** banner图*/
@property (nonatomic, strong) BannerView *bannerView;
/**购物车*/
@property (nonatomic,strong) UIButton *cartButton;
/**购物车界面*/
@property (nonatomic,strong) WShopCartView *shopCartView;

/**分类商品mode*/
@property (nonatomic,strong) GoodsModel *typeModel;

@end

@implementation ShoppingFirestViewController

- (void)getdata{
    self.hotArr = @[];
    self.rushArr = @[];
    self.likeArr = @[];
    self.typeArr = @[];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = LH_RGBCOLOR(236, 236, 236);
    self.navigationController.navigationBarHidden = YES;
    [self getBannerData];
    [self getdata];
    
    WK(wkSelf)
    [self postGetSyntypeWhileComplete:^() {
        [wkSelf postGoodsListWithGoodsName:@"" type:@"" label:@"热卖" WhileComplete:^(GoodsModel *goodmodel) {
        wkSelf.hotArr = goodmodel.datalist;
        [wkSelf.hotActiveV setinitValue:wkSelf.hotArr];
        [wkSelf initView];
 
        }];
        
        [wkSelf postGoodsListWithGoodsName:@"" type:@"" label:@"必抢" WhileComplete:^(GoodsModel *goodmodel) {
            wkSelf.rushArr = goodmodel.datalist;
            [wkSelf initView];
        }];
        
        NSString *likeStr = @"";
        if ([USERDEFAULT objectForKey:@"like"]) {
            likeStr = [USERDEFAULT objectForKey:@"like"];
        }
        [wkSelf postGoodsListWithGoodsName:likeStr type:@"" label:@"" WhileComplete:^(GoodsModel *goodmodel) {
            wkSelf.likeArr = goodmodel.datalist;
            [wkSelf initView];
        }];
    }];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.shopCartView reloadallData];
}
#pragma mark *** 初始化 ***
- (void)initView{
    
    [self.view removeAllSubviews];
    
    _backV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-50-46)];
    [self.view addSubview:_backV];
    _backV.backgroundColor = LH_RGBCOLOR(220, 220, 220);
    _backV.scrollEnabled = YES;
    
//广告视图
    [self.view addSubview:self.topSearchView];
    [_backV addSubview:self.bannerView];
    
    _shoppingTypeV = [[ShoppingTypeView alloc]initWithFrame:CGRectMake(0, CGRectYH(self.bannerView), __kWidth, __kWidth/4)];
    [_backV addSubview:_shoppingTypeV];
    _shoppingTypeV.delegate=self;


    _hotV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectYH(_shoppingTypeV)+4, __kWidth, (__kWidth)*11/36*(_hotArr.count/2+_hotArr.count%2)+30)];
    [_backV addSubview:_hotV];
    _hotV.backgroundColor = [UIColor whiteColor];

    UIImageView *hotIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 75, 20)];
    [_hotV addSubview:hotIV];
    hotIV.image = MImage(@"doing");
    hotIV.contentMode = UIViewContentModeScaleAspectFit;

    _hotActiveV = [[HotActiveView alloc]initWithFrame:CGRectMake(0, CGRectYH(hotIV), __kWidth, (__kWidth)*11/36*(_hotArr.count/2+_hotArr.count%2))];
    [_hotV addSubview:_hotActiveV];
    _hotActiveV.delegate = self;
    [_hotActiveV setinitValue:_hotArr];

    NSInteger Need;
    if (_rushArr.count%4==0) {
        Need = _rushArr.count/4;
    }else{
        Need = _rushArr.count/4+1;
    }

    _needRushView = [[NeedRushView alloc]initWithFrame:CGRectMake(0, CGRectYH(_hotV)+4, __kWidth, __kWidth*13/36*Need+40)];
    [_backV addSubview:_needRushView];
    _needRushView.delegate = self;
    [_needRushView setNeedView:_rushArr];

    _guessLikeV = [[GuessLikeView alloc]initWithFrame:CGRectMake(0, CGRectYH(_needRushView)+4, __kWidth, (__kWidth*5/18+80)*(_likeArr.count/2+_likeArr.count%2)+30)];
    [_backV addSubview:_guessLikeV];
    _guessLikeV.delegate = self;
    [_guessLikeV setLikeView:_likeArr];

     _backV.contentSize = CGSizeMake(__kWidth, __kWidth/4+(__kWidth)*11/36*(_hotArr.count/2+_hotArr.count%2)+30+__kWidth*13/36*Need+40+(__kWidth*5/18+80)*(_likeArr.count/2+_likeArr.count%2)+230+40);

     _typeV = [[TypeView alloc]initWithFrame:CGRectMake(0, CGRectYH(_shoppingTypeV), __kWidth, (__kWidth*5/18+80)*(_typeArr.count/2+_typeArr.count%2))];
    [_backV addSubview:_typeV];
    _typeV.delegate = self;
    _typeV.hidden = YES;
    
    //购物车btn
    [self.view addSubview:self.cartButton];
}

#pragma mark -TypeView Delegate
-(void)selectTypeCellGoodsId:(NSString *)goodId{
    NSLog(@"跳转到热门商品详情页%@",goodId);
    [self getDetailInfoForGoodId:goodId];
}


#pragma mark -GuessLikeViewDelegate
- (void)selectCellLikeGoodsid:(NSString *)goodsId{
    NSLog(@"跳转到热门商品详情页%@",goodsId);
    [self getDetailInfoForGoodId:goodsId];

}


#pragma mark -NeedRushView Delegate
-(void)selectCellRushGoodsId:(NSString *)goodsId{
    NSLog(@"跳转到热门商品详情页%@",goodsId);
    [self getDetailInfoForGoodId:goodsId];

}


#pragma mark -HotActiveViewDelegate
-(void)selectCellGoodsId:(NSString *)goodsId{
    NSLog(@"跳转到热门商品详情页%@",goodsId);
    [self getDetailInfoForGoodId:goodsId];

}

#pragma mark *** TopSearchViewDelegate ***

-(void)TopSearchViewDidTapView:(TopSearchView *)topSearchView{
    MYLog(@"商城搜索栏");
    
    [USERDEFAULT setObject:self.topSearchView.searchLabel.text forKey:@"like"];
    
    WShopSearchViewController *searchVc = [[WShopSearchViewController alloc] initWithText:self.topSearchView.searchLabel.text];
    [self.navigationController pushViewController:searchVc animated:YES];
}

#pragma mark -ShoppingTypeView Delegate
-(void)pushViewTitle:(NSString *)title{
    _hotV.hidden = YES;
    _guessLikeV.hidden = YES;
    _needRushView.hidden = YES;
    _typeV.hidden = NO;
    
    [self postGoodsListWithGoodsName:@"" type:title label:@"" WhileComplete:^(GoodsModel *goodmodel) {
        _typeArr = goodmodel.datalist;
        
        _typeV.frame =CGRectMake(0, CGRectYH(_shoppingTypeV), __kWidth, (__kWidth*5/18+80)*(_typeArr.count/2+_typeArr.count%2));
        [_typeV setTypeView:_typeArr];
        
        _backV.contentSize = CGSizeMake(__kWidth, 200+__kWidth/4+(__kWidth*5/18+80)*(_typeArr.count/2+_typeArr.count%2)+28);
    }];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark *** btnEvents ***
-(void)respondsToCartBtn:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
        [self.view addSubview:self.shopCartView];
//    }
}
-(void)respondsTorightBookingBtn:(UIButton *)sender{
    MyOrdersViewController *myOdVc = [[MyOrdersViewController alloc] init];
    [self.navigationController pushViewController:myOdVc animated:YES];
}
#pragma mark *** 网络请求 ***
-(void)getBannerData{
    NSDictionary *logDic = @{@"type":@"SC"};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getbanner" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            NSArray *array = [NSArray modelArrayWithClass:[BannerModel class] json:jsonDic[@"data"]];
            if (array.count != 0) {
               weakSelf.bannerView.modelArr = array;
            }
            
        }
    } failure:^(NSError *error) {
        
    }];

}


-(void)postGetSyntypeWhileComplete:(void (^)())back{
    [TCJPHTTPRequestManager POSTWithParameters:@{@"typeval":@"SPFL"} requestID:GetUserId requestcode:kRequestCodeGetsyntype success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSLog(@"--%@",[NSString jsonArrWithArr:jsonDic[@"data"]]);
            NSArray *arr = [NSString jsonArrWithArr:jsonDic[@"data"]];
            NSMutableDictionary *alldic = [NSMutableDictionary dictionary];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = arr[idx];
                [alldic setObject:dic[@"syntypeval"] forKey:dic[@"syntype"]];
            }];
            [WShopCommonModel shareWShopCommonModel].typeIdDic = alldic;
            back();
        }
    } failure:^(NSError *error) {
        
    }];
}
/**
 *  搜索商品
 *
 *  @param name 商品名
 *  @param back 结束搜索
 */
-(void)postGoodsListWithGoodsName:(NSString *)name type:(NSString *)type label:(NSString *)label WhileComplete:(void (^)(GoodsModel *goodmodel))back{
    NSDictionary *dic = [WShopCommonModel shareWShopCommonModel].typeIdDic;
    [TCJPHTTPRequestManager POSTWithParameters:@{@"pagenum":@"1",
                                                 @"pagesize":@"20",
                                                 @"type":dic[type]?dic[type]:@"",
                                                 @"label":label,
                                                 @"coname":name,
                                                 @"shoptype":@"GEN",
                                                 @"qsj":@"",
                                                 @"jwj":@"",
                                                 @"px":@"ZH",
                                                 @"issx":@"1",
                                                 } requestID:GetUserId requestcode:kRequestCodegetcomlist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                     if (succe) {
                                                         NSLog(@"--%@-goods--%@", label,[NSString jsonDicWithDic:jsonDic[@"data"]]);
                                                         GoodsModel *model = [GoodsModel modelWithJSON:jsonDic[@"data"]];
                                                         back(model);
                                                     }
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
}

-(void)getDetailInfoForGoodId:(NSString *)goodsId{
    [SXLoadingView showProgressHUD:@"正在加载"];
    __weak typeof(self)weakSelf = self;
    [TCJPHTTPRequestManager POSTWithParameters:@{@"CoId":goodsId} requestID:GetUserId requestcode:kRequestCodegetcomdetail success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSLog(@"详情----%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
            
            WGoodsDetailModel *deModel = [WGoodsDetailModel modelWithJSON:jsonDic[@"data"]];
            GoodsDetailsViewController *detaiVc = [[GoodsDetailsViewController alloc] initWithTitle:@"" image:MImage(@"chec") detailGoodsModel:deModel];
            
            [weakSelf.navigationController pushViewController:detaiVc animated:YES];
            [SXLoadingView hideProgressHUD];
        }
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark *** getters ***
-(TopSearchView *)topSearchView{
    if (!_topSearchView) {
        _topSearchView = [[TopSearchView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, StatusBar_Height+NavigationBar_Height)];
        _topSearchView.searchLabel.placeholder = @"输入关键词";
        _topSearchView.delegate = self;
        [_topSearchView.menuBtn removeFromSuperview];
        BookingBtn *btn = [[BookingBtn alloc] initWithFrame:CGRectMake(CGRectXW(_topSearchView.searchView)+15, CGRectGetHeight(_topSearchView.backView.bounds)/2-23+StatusBar_Height, 25, 25)];
        [_topSearchView addSubview:btn];
        
    }
    return _topSearchView;
}

-(BannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 0.6*Screen_width)];
    }
    return _bannerView;
}

-(UIButton *)cartButton{
    if (!_cartButton) {
        _cartButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)-45, 350, 45, 30)];
        [_cartButton setImage:MImage(@"car") forState:0];
        [_cartButton addTarget:self action:@selector(respondsToCartBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cartButton;
}
-(WShopCartView *)shopCartView{
    if (!_shopCartView) {
        _shopCartView = [[WShopCartView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar)];
    }
    [_shopCartView reloadallData];
    return _shopCartView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
