//
//  SXTDetailsViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/23.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTDetailsViewController.h"
#import "SXTDetailsTopImageView.h"//顶部轮播图片
#import "SXTDetailsImageModel.h"//图片model
#import "MJExtension.h"//mj数据转模型
#import "SXTDetailsTitleLabelView.h"//商品标题及描述信息view
#import "SXTDetailsTitleModel.h"//商品详细信息model
#import "SXTDetailsListModel.h"//图文详情model
#import "SXTDetailsContentView.h"//图文详情view
#import "SXTBottomImageView.h"//底部多张图片view
#import "SXTThreeButtonView.h"//底部购买按钮
@interface SXTDetailsViewController ()
@property (strong, nonatomic)   UIScrollView *mainScroll;              /** 底部滚动视图 */
@property (strong, nonatomic)   SXTDetailsTopImageView *topImageView;              /** 顶部轮播图片 */
@property (strong, nonatomic)   SXTDetailsTitleLabelView *detailsTitleView;              /** 商品标题view */
@property (strong, nonatomic)   SXTDetailsContentView *contentView;              /** 图文详情view */
@property (strong, nonatomic)   SXTBottomImageView *bottomImageView;              /** 底部图片展示view */
@property (strong, nonatomic)   SXTThreeButtonView *buyNowView;              /** 购买view */
@property (assign, nonatomic)   CGFloat  scrollContentHeight;/** scroll内部高度 */
@property (copy, nonatomic)     NSString *goodsID;/** 商品ID */
@end

@implementation SXTDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollContentHeight = 365.0;
    [self.view addSubview:self.mainScroll];
    
    __weak typeof (self) weakSelf = self;
    [_mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0, 0, 45, 0));
    }];
    
    [self.mainScroll addSubview:self.topImageView];
    [self.mainScroll addSubview:self.detailsTitleView];
    [_detailsTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topImageView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
    }];
    
    [self.mainScroll addSubview:self.contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.detailsTitleView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
    }];
    
    [self.mainScroll addSubview:self.bottomImageView];
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.contentView.mas_bottom);
    }];
    [self.view addSubview:self.buyNowView];
    [self requestImageData];
    [self requestTitleData];
    [self requestGoodsDetail];

}

- (void)requestImageData{
    [self getData:@"appGoods/findGoodsImgList.do" param:@{@"GoodsId":self.DetailsGoodsId} success:^(id responseObject) {
        NSArray *imageArray = [SXTDetailsImageModel mj_objectArrayWithKeyValuesArray:responseObject];
        NSMutableArray *topImageArray = [NSMutableArray arrayWithCapacity:0];
        
        for (SXTDetailsImageModel *imageModel in imageArray) {
            if ([imageModel.ImgType isEqualToString:@"1"]) {
                [topImageArray addObject:imageModel.ImgView];
            }
        }
        _topImageView.imageArray = topImageArray;
        _bottomImageView.imageArray = imageArray;
    } error:^(NSError *error) {
        
    }];
}

//appGoods/findGoodsDetailList.do?
- (void)requestGoodsDetail{
    [self getData:@"appGoods/findGoodsDetailList.do?" param:@{@"GoodsId":self.DetailsGoodsId} success:^(id responseObject) {
        NSArray *goodsModel = [SXTDetailsListModel mj_objectArrayWithKeyValuesArray:responseObject];
        _contentView.contentArray = goodsModel;
    } error:^(NSError *error) {
        
    }];
}

- (void)requestTitleData{
    [self getData:@"appGoods/findGoodsDetail.do" param:@{@"GoodsId":self.DetailsGoodsId} success:^(id responseObject) {
        
        SXTDetailsTitleModel *titleModel = [SXTDetailsTitleModel mj_objectWithKeyValues:responseObject];
        _detailsTitleView.titleModel = titleModel;
        _goodsID = titleModel.GoodsId;
    } error:^(NSError *error) {
        
    }];
}
/*
 URL：http://123.57.141.249:8080/beautalk/appShopCart/insert.do
 传入数据：
 参数标记：
 会员登录名 ：MemberId
 美食ID ： GoodsId
 */

- (void)addGoodsInBuyCarMethod{
    
    NSDictionary *landingDic = [[NSUserDefaults standardUserDefaults]valueForKey:@"ISLOGIN"];
    if (landingDic.count > 0) {
        [self getData:@"appShopCart/insert.do" param:@{@"MemberId":landingDic[@"MemberId"],@"GoodsId":_goodsID} success:^(id responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                [self showTostMessage:@"商品已加入购物车"];
            }else{
                [self showTostMessage:@"加入购物车失败"];
            }
        } error:^(NSError *error) {
            
        }];
    }else{
        //跳转到登录页面
    }
    
}

- (UIScrollView *)mainScroll{
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc]init];
        _mainScroll.contentSize = CGSizeMake(0, 10000);
    }
    return _mainScroll;
}

- (SXTDetailsTopImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[SXTDetailsTopImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 380)];
    }
    return _topImageView;
}

- (SXTDetailsTitleLabelView *)detailsTitleView{
    if (!_detailsTitleView) {
        _detailsTitleView = [[SXTDetailsTitleLabelView alloc]init];
        __weak typeof (self) weakSelf = self;
        _detailsTitleView.heightBlock = ^(CGFloat height){
            SXTLog(@"height = %lf",height);
            [weakSelf.detailsTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            weakSelf.scrollContentHeight += height;
//            weakSelf.mainScroll.contentSize = CGSizeMake(0, weakSelf.scrollContentHeight);

        };
    }
    return _detailsTitleView;
}

- (SXTDetailsContentView *)contentView{
    if (!_contentView) {
        _contentView = [[SXTDetailsContentView alloc]init];
        __weak typeof (self) weakSelf = self;
        _contentView.heightBlock = ^(CGFloat height){
            SXTLog(@"height = %lf",height);
            [weakSelf.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            weakSelf.scrollContentHeight += height;
//            weakSelf.mainScroll.contentSize = CGSizeMake(0, weakSelf.scrollContentHeight);

        };
    }
    return _contentView;
}

- (SXTBottomImageView *)bottomImageView{
    if (!_bottomImageView) {
        _bottomImageView = [[SXTBottomImageView alloc]init];
        
        __weak typeof (self) weakSelf = self;
        _bottomImageView.imageHeightBlock = ^(CGFloat height){
            [weakSelf.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            weakSelf.scrollContentHeight += height;
        };
    }
    return _bottomImageView;
}

- (SXTThreeButtonView *)buyNowView{
    if (!_buyNowView) {
        _buyNowView = [[SXTThreeButtonView alloc]initWithFrame:CGRectMake(0, VIEW_HEIGHT-45, VIEW_WIDTH, 45)];
        __weak typeof (self) weakSelf = self;
        _buyNowView.addBlock = ^(){
            [weakSelf addGoodsInBuyCarMethod];
        };
    }
    return _buyNowView;
}
- (void)setScrollContentHeight:(CGFloat)scrollContentHeight{
    _scrollContentHeight = scrollContentHeight;
    self.mainScroll.contentSize = CGSizeMake(0, _scrollContentHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
