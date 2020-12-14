//
//  ShoppingCartViewController.m
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/3.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartCell.h"
#import "ShoopingCartBottomView.h"
#import "ShoppingCartModel.h"
#import "ShoppingCartSectionHeaderView.h"

@interface ShoppingCartViewController ()
<UITableViewDataSource,UITableViewDelegate,ShoopingCartBottomViewDelegate,ShoppingCartSectionHeaderViewDelegate,ShoppingCartCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;//所有商铺数组
@property (nonatomic, strong) NSMutableArray *selectedShop;//选中的商品数组

@property (nonatomic, strong) ShoopingCartBottomView *bottomView;

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    
    [self setUpUI];
    
    [self initData];
}
- (void)setUpUI
{
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomView];
}
//网络请求数据(这里使用本地模拟数据)
- (void)initData {
    [ShoppingCartModel requestDataWithSucess:^(NSArray<__kindof ShopModel *> *result) {
        
        NSLog(@"result:%@",result);
        [self result:result];
        
    } failure:^{
        
    }];
}
- (void)result:(NSArray *)result {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:result];
    [self.tableView reloadData];
}

#pragma mark - delegate
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ShopModel *shopModel = self.dataSource[section];
    return shopModel.goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellID = @"ShoppingCartViewController_cell";
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    //刷新cell
    cell.indexPath = indexPath;
    ShopModel *shopModel = self.dataSource[indexPath.section];
    GoodsModel *goodsModel = shopModel.goods[indexPath.row];
    [cell setInfo:goodsModel];
    
    //计算并刷新价格、刷新结算按钮状态
    [self caculatePrice:goodsModel];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
//设置自定义的sectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *identifier = @"ShoppingCartViewController_cell_header";
    ShoppingCartSectionHeaderView *hearderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!hearderView) {
        hearderView = [[ShoppingCartSectionHeaderView alloc] initWithReuseIdentifier:identifier];
        hearderView.delegate = self;
    }
    hearderView.section = section;

    ShopModel *shopModel = self.dataSource[section];
    [hearderView setInfo:shopModel];
    
    //判断是否全选
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL allSelected = YES;
        for (ShopModel *shopModel in self.dataSource) {
            if (!shopModel.isSelected) {
                allSelected = NO;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bottomView setIsClick:allSelected];
        });
    });
    
    return hearderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
//设置自定义的sectionFooter,去除sectionFooter
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - ShoopingCartBottomViewDelegate
//全选
- (void)allGoodsIsSelected:(BOOL)selccted withButton:(UIButton *)btn {
    //修改数据源数据，刷新列表
    for (ShopModel *shopModel in self.dataSource) {
        shopModel.isSelected = selccted;
        for (GoodsModel *goodsModel in shopModel.goods) {
            goodsModel.isSelected = selccted;
        }
    }
    [self.tableView reloadData];
}
//结算
- (void)paySelectedGoods:(UIButton *)btn {
    NSLog(@"结算，选中的商品有：\n ");
    for (GoodsModel *goods in self.selectedShop) {
        NSLog(@"%@ \n",goods.goodsName);
    }
}
#pragma mark - ShoppingCartSectionHeaderViewDelegate
- (void)hearderView:(ShoppingCartSectionHeaderView *)headerView isSelected:(BOOL)isSelected section:(NSInteger)section
{
    //刷新选中的section数据
    ShopModel *shopModel = self.dataSource[section];
    shopModel.isSelected = isSelected;
    for (GoodsModel *goodsModel in shopModel.goods) {
        goodsModel.isSelected = isSelected;
    }
    
//#warning 数据源多的时候，刷新section时，页面会出现bug
//    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:section];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}
#pragma mark - ShoppingCartCellDelegate
- (void)cell:(ShoppingCartCell *)cell selected:(BOOL)isSelected indexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section:%ld row:%ld isSelected:%d",indexPath.section,indexPath.row,isSelected);
    //更新选中cell的section下的数据
    ShopModel *shopModel = self.dataSource[indexPath.section];
    GoodsModel *goodsModel = shopModel.goods[indexPath.row];
    goodsModel.isSelected = isSelected;
    //判断整个section是不是全被选中
    BOOL sectionSelected = YES;
    for (GoodsModel *goodsModel in shopModel.goods) {
        if (!goodsModel.isSelected) {
            sectionSelected = NO;
        }
    }
    shopModel.isSelected = sectionSelected;
    NSLog(@"all section selected:%d",sectionSelected);
    
//#warning 数据源多的时候，刷新section时，页面会出现bug
//    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:indexPath.section];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}
#pragma mark - 自定义
- (void)caculatePrice:(GoodsModel *)goodsModel{
    @synchronized (self.selectedShop)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (goodsModel.isSelected) {
                if (![self.selectedShop containsObject:goodsModel]) {
                    [self.selectedShop addObject:goodsModel];
                }
            }
            else {
                if ([self.selectedShop containsObject:goodsModel]) {
                    [self.selectedShop removeObject:goodsModel];
                }
            }
            
            NSDecimalNumber *allPriceDecimal = [NSDecimalNumber zero];
            for (GoodsModel *goods in self.selectedShop) {
                NSString *price = goods.price;
                NSDecimalNumber *decimalPrice = [NSDecimalNumber decimalNumberWithString:price];
                allPriceDecimal = [allPriceDecimal decimalNumberByAdding:decimalPrice];
            }
            NSString *allPriceStr = [allPriceDecimal stringValue];
            NSLog(@"总价：%@",allPriceStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([allPriceStr floatValue]>0) {
                    [self.bottomView setPayEnable:YES];
                    self.bottomView.allPriceLabel.text = [NSString stringWithFormat:@"总价：%@",[allPriceDecimal stringValue]];
                } else {
                    [self.bottomView setPayEnable:NO];
                    self.bottomView.allPriceLabel.text = @"总价：";
                }
            });
        });
    }
}

#pragma mark - set/get
- (ShoopingCartBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ShoopingCartBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-44-kIPhoneXBottomHeight, kScreenWidth, 44)];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44-kIPhoneXBottomHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (NSMutableArray *)selectedShop {
    if (!_selectedShop) {
        _selectedShop = [[NSMutableArray alloc] init];
    }
    return _selectedShop;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSLog(@"dealloc");
}

@end
