//
//  SXTBuyCarViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/17.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTBuyCarViewController.h"
#import <MJExtension.h>
#import "SXTBuyCarListModel.h"//购物车列表model
#import "SXTBuyCarListView.h"//购物车列表view
#import "SXTPriceView.h"    //显示价格view
#import "SXTSureOrderModel.h"//去结算model
#import "SXTSureOrderViewController.h"//确认订单页面

@interface SXTBuyCarViewController ()
@property (strong, nonatomic)   SXTBuyCarListView *buyCarListView;              /** 购物车列表view */
@property (strong, nonatomic)   SXTPriceView *priceView;              /** 显示价格view */
@property (strong, nonatomic)   NSMutableArray *tableViewArray;              /** 存储model的数组 */
@end

@implementation SXTBuyCarViewController
//http://123.57.141.249:8080/beautalk/appShopCart/appCartGoodsList.do
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.buyCarListView];
    [self.view addSubview:self.priceView];
    [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@55);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestBuyCarData];
}

- (void)requestBuyCarData{
    
    NSDictionary *landingDic = [[NSUserDefaults standardUserDefaults]valueForKey:@"ISLOGIN"];
    //判断是否已经登录，如果没有登录可直接跳转到登录页面
    if (landingDic.count == 0) {
        
    }else{//如果已经登录，则加载正常的购物车页面
        [self getData:@"appShopCart/appCartGoodsList.do" param:@{@"MemberId":landingDic[@"MemberId"]} success:^(id responseObject) {
            self.tableViewArray = [NSMutableArray array];
            self.tableViewArray = [SXTBuyCarListModel mj_objectArrayWithKeyValuesArray:responseObject];
            //如果购物车中商品个数大于0显示购物车列表
            if (_tableViewArray.count > 0) {
                _buyCarListView.buyCarList = [NSMutableArray array];
                _buyCarListView.buyCarList = _tableViewArray;
                [self countPriceMoney];
            }
            else{//如果购物车中商品个数小于0显示购物车是空的
                
            }
        } error:^(NSError *error) {
            
        }];
    }
}

- (void)changeBuyCarData{
    /*
     拼装字符串标记：updateCartMsg
     格式：购物记录UUID,商品数量#购物记录UUID，商品数量#......
     */
    
    NSString * buyCarData;
    NSMutableArray *buyCarDataArray = [NSMutableArray arrayWithCapacity:0];
    for (SXTBuyCarListModel *model in _tableViewArray) {
        buyCarData = [NSString stringWithFormat:@"%@,%li",model.UUID,model.GoodsCount];
        [buyCarDataArray addObject:buyCarData];
    }
    buyCarData = [buyCarDataArray componentsJoinedByString:@"#"];
    
    [self getData:@"appShopCart/appUpdateCart.do" param:@{@"updateCartMsg":buyCarData} success:^(id responseObject) {
        SXTLog(@"responseObject : %@",responseObject);
    } error:^(NSError *error) {
        
    }];
}

- (SXTBuyCarListView *)buyCarListView{
    if (!_buyCarListView) {
        _buyCarListView = [[SXTBuyCarListView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT) style:(UITableViewStylePlain)];
        __weak typeof (self) weakSelf = self;
        _buyCarListView.changeDataBlock = ^(){
            [weakSelf countPriceMoney];
        };
    }
    return _buyCarListView;
}

- (void)countPriceMoney{
    CGFloat priceMoney = 0.0;
    for (SXTBuyCarListModel *model in _tableViewArray) {
        if (model.isSelectButton) {
            priceMoney += model.Price * model.GoodsCount;
        }
    }
    [self priceAttributedText:priceMoney];
    [self changeBuyCarData];
}

- (void)priceAttributedText:(CGFloat)money{
    //当前价格(需要手动添加人民币符号)
    NSString *nowPrice = @"合计：";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:nowPrice attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                                               NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
    //过去价格
    NSString *oldString = [NSString stringWithFormat:@"¥%.2lf",money];
    NSMutableAttributedString *oldPrice = [[NSMutableAttributedString alloc]initWithString:oldString attributes:@{NSForegroundColorAttributeName:RGB(230, 46, 37),NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]
                                                                                                                  }];
    [string insertAttributedString:oldPrice atIndex:string.length];
    _priceView.priceLabel.attributedText = string;
}

- (SXTPriceView *)priceView{
    if (!_priceView) {
        _priceView = [[SXTPriceView alloc]init];
        __weak typeof (self) weakSelf = self;
        _priceView.gotoInsert = ^(){
            [weakSelf gotoInsertMethod];
        };
    }
    return _priceView;
}

- (void)gotoInsertMethod{
    [self getData:@"appOrder/gotoInsert.do" param:[self makeInsertDic] success:^(id responseObject) {
        SXTSureOrderModel *result = [SXTSureOrderModel mj_objectWithKeyValues:responseObject];
        SXTLog(@"result%@",[result.GoodsList[0] GoodsId]);
        SXTSureOrderViewController *order = [[SXTSureOrderViewController alloc]init];
        order.orderTableData = result;
        [self.navigationController pushViewController:order animated:YES];
    } error:^(NSError *error) {
        
    }];
}
- (NSDictionary *)makeInsertDic{
    NSString * buyCarData;
    NSMutableArray *buyCarDataArray = [NSMutableArray arrayWithCapacity:0];
    for (SXTBuyCarListModel *model in _tableViewArray) {
        buyCarData = [NSString stringWithFormat:@"%li,%@,%lf",model.GoodsCount,model.GoodsId,model.Weight];
        [buyCarDataArray addObject:buyCarData];
    }
    buyCarData = [buyCarDataArray componentsJoinedByString:@"#"];
    
    return @{@"Goods":buyCarData};
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
