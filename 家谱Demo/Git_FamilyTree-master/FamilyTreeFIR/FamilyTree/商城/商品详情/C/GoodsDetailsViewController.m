//
//  GoodsDetailsViewController.m
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GoodsDetailsViewController.h"
#import "GoodsDetailsNaviView.h"
#import "GoodsDetailView.h"
#import "GoodBottomView.h"
#import "GoodPayModel.h"
#import "GoodDetailModel.h"
#import "GoodLabelView.h"
#import "GoodCommentView.h"

@interface GoodsDetailsViewController ()<GoodsDetailsNaviViewDelegate,GoodBottomViewDelegate,GoodsDetailViewDelegate,UIScrollViewDelegate>
/**
 *  导航栏视图
 */
@property (strong,nonatomic) GoodsDetailsNaviView *titleView;
/**
 *  商品视图
 */
@property (strong,nonatomic) GoodsDetailView *goodDetailV;
/**
 *  底部视图
 */
@property (strong,nonatomic) GoodBottomView *goodBottomV;

@property (strong,nonatomic) UIScrollView *backV;

@property (strong,nonatomic) UIScrollView *goodOneV;

@property (strong,nonatomic) UIScrollView *goodTwoV;

/**
 *  获取商品数据模型
 */
@property (strong,nonatomic) GoodDetailModel *goodDetailModel;
/**
 *  商品详情视图
 */
@property (strong,nonatomic) GoodLabelView *goodLabelV;
/**
 *  评价视图
 */
@property (strong,nonatomic) GoodCommentView *goodCommentV;

/**详情model*/
@property (nonatomic,strong) WGoodsDetailModel *detalModel;

/**滚动视图*/
@property (nonatomic,strong) ScrollerView *scrollerView;
/**详情滚动*/
@property (nonatomic,strong) ScrollerView *detaiScroller;


@end

@implementation GoodsDetailsViewController

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image detailGoodsModel:(WGoodsDetailModel *)goodModel
{
    self = [super initWithTitle:title image:image];
    if (self) {
        self.detalModel = goodModel;
    }
    return self;
}

- (void)getData{
    _goodDetailModel = [[GoodDetailModel alloc]init];
    _goodDetailModel.goodName = self.detalModel.data.CoConame;
    
    
    NSArray *colorArr = @[@"黑",@"绿",@"棕",@"白",@"紫"];
    
    NSMutableArray *mutableStyleArr = [@[] mutableCopy];
    NSMutableDictionary *mutableStyleDicId = [NSMutableDictionary dictionary];
    for (DetailPro *pro in self.detalModel.pro) {
        [mutableStyleArr addObject:pro.CoprData];
        //一个商品类型，对应商品类型id，原价和总价
        [mutableStyleDicId setObject:@[@(pro.CoprId),@(pro.CoprMoney),@(pro.CoprActPri)] forKey:pro.CoprData];
    }
    [USERDEFAULT setObject:mutableStyleDicId forKey:kNSUserDefaultsgoodsDetail];
    
    _goodDetailModel.goodMoney = [NSString stringWithFormat:@"%ld",(long)self.detalModel.pro[0].CoprActPri];
    _goodDetailModel.goodQuote = [NSString stringWithFormat:@"%ld",(long)self.detalModel.pro[0].CoprMoney];
    NSArray *styleArr =  mutableStyleArr;
    _goodDetailModel.colorList = [NSMutableArray array];
    _goodDetailModel.styleList = [NSMutableArray array];
    for (int i=0 ; i<colorArr.count; i++) {
        GoodColorModel *model = [[GoodColorModel alloc]init];
        model.goodColor = colorArr[i];
        [_goodDetailModel.colorList addObject:model];
    }
    for (int i= 0; i<styleArr.count; i++) {
        GoodStyleModel *model =[[GoodStyleModel alloc]init];
        model.goodStyle = styleArr[i];
        [_goodDetailModel.styleList addObject:model];
    }
     [self initView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavi];
    self.view.backgroundColor = LH_RGBCOLOR(230, 230, 230);
    [self getData];
}

-(void)addNavi{
   _titleView = [[GoodsDetailsNaviView alloc]initWithFrame:CGRectMake(__kWidth/6, 20, __kWidth*2/3, 44)];
    [self.comNavi addSubview:_titleView];
    _titleView.delegate = self;
    [self.comNavi.rightBtn removeAllTargets];
    [self.comNavi.rightBtn addTarget:self action:@selector(respondsDetailRightBtn) forControlEvents:UIControlEventTouchUpInside];
}
-(void)respondsDetailRightBtn{
    MyOrdersViewController *myOdVc = [[MyOrdersViewController alloc] init];
    [self.navigationController pushViewController:myOdVc animated:YES];
}
-(void)changeView:(UIButton *)sender{
    
    [_backV setContentOffset:CGPointMake(sender.tag*Screen_width, 0) animated:YES];
    
}

#pragma mark -GoodBottomViewDelegate
-(void)payOrShop:(UIButton *)sender{
    NSLog(@"商品:%@\n颜色:%@\n款式:%@\n价格:%@\n数量:%@\n类型id:%@",_goodDetailV.chooseGood.goodName,_goodDetailV.chooseGood.goodColor,_goodDetailV.chooseGood.goodStyle,_goodDetailV.chooseGood.goodMoney,_goodDetailV.chooseGood.goodCount,_goodDetailV.chooseGood.goodStyleId);
    if (sender.tag) {
        NSLog(@"立即支付");
    }else{
        NSLog(@"加入购物车");
    }
}
#pragma mark -GoodDetailViewDelegate
-(void)allCommentShow{
    NSLog(@"全部评论");
    [_titleView chooseView:2];
    [_backV setContentOffset:CGPointMake(__kWidth*2, 0) animated:YES];
}

-(void)initView{
    //商品视图
    _backV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-46-46)];
    [self.view addSubview:_backV];
    _backV.scrollEnabled = YES;
    _backV.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _backV.contentSize = CGSizeMake(__kWidth*3, __kHeight-46);
    _backV.bounces = false;
    //开启滚动分页功能，如果不需要这个功能关闭即可
    [_backV setPagingEnabled:YES];
    _backV.showsHorizontalScrollIndicator=NO; //不显示水平滑动线
    _backV.showsVerticalScrollIndicator=NO;//不显示垂直滑动线
    _backV.contentOffset = CGPointMake(0, 0);

    _goodOneV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight-46-46)];
    [_backV addSubview:_goodOneV];
    _goodOneV.scrollEnabled = YES;

    //滚动视图
    [_goodOneV addSubview:self.scrollerView];

    _goodDetailV = [[GoodsDetailView alloc]initWithFrame:CGRectMake(0, __kWidth*5/9, __kWidth, __kHeight-30)];
    [_goodOneV addSubview:_goodDetailV];
    _goodDetailV.delegate = self;
    [_goodDetailV getGoodData:_goodDetailModel];
    _goodDetailV.frame = CGRectMake(0, __kWidth*5/9, __kWidth, _goodDetailV.detailH);
    _goodOneV.contentSize = CGSizeMake(__kWidth, _goodDetailV.detailH+__kWidth*5/9+64);

    //商品详情
    _goodTwoV = [[UIScrollView alloc]initWithFrame:CGRectMake(__kWidth, CGRectYH(self.scrollerView), __kWidth, __kHeight-110-46)];
    [_backV addSubview:_goodTwoV];
    [_backV addSubview:self.detaiScroller];
    
    _goodTwoV.scrollEnabled = YES;

    _goodLabelV = [[GoodLabelView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 120)];
    [_goodTwoV addSubview:_goodLabelV];
    _goodLabelV.detaiLb.text = self.detalModel.data.CoBrief;
    [_goodLabelV refreshFrame];
    if (_goodLabelV.bounds.size.height>__kHeight-110) {
        _goodTwoV.contentSize = CGSizeMake(__kWidth, _goodLabelV.bounds.size.height);
    }else{
        _goodTwoV.contentSize = CGSizeMake(__kWidth, __kHeight-110);
    }

    _goodCommentV = [[GoodCommentView alloc]initWithFrame:CGRectMake(__kWidth*2, 0, __kWidth, __kWidth-110-46)];
    [_backV addSubview:_goodCommentV];

    _goodBottomV = [[GoodBottomView alloc]initWithFrame:CGRectMake(0, __kHeight-46-46, __kWidth, 46)];
    [self.view addSubview:_goodBottomV];
    _goodBottomV.delegate = self;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x=0;
    if (scrollView.contentOffset.x>=(fabs(scrollView.contentOffset.x/__kWidth)*__kWidth+__kWidth/2)&&scrollView.contentOffset.x>__kWidth) {
        x=1;
    }
    [_titleView chooseView:(fabs(scrollView.contentOffset.x/__kWidth)+x)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark *** getters ***
-(ScrollerView *)scrollerView{
    if (!_scrollerView) {
         NSMutableArray *picArr = [@[] mutableCopy];
        [self.detalModel.pic enumerateObjectsUsingBlock:^(DetailPic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [picArr addObject:obj.PicFilepath];
        }];
        
        _scrollerView = [[ScrollerView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kWidth*5/9) images:picArr];
        
    }
    return _scrollerView;
}

-(ScrollerView *)detaiScroller{
    if (!_detaiScroller) {
        NSMutableArray *picArr = [@[] mutableCopy];
        [self.detalModel.pic enumerateObjectsUsingBlock:^(DetailPic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [picArr addObject:obj.PicFilepath];
        }];
        
        _detaiScroller = [[ScrollerView alloc] initWithFrame:CGRectMake(__kWidth, 0, __kWidth, __kWidth*5/9) images:picArr];
        
    }
    return _detaiScroller;
}

@end
