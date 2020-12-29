//
//  HKBaseCartListViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseCartListViewController.h"
#import "HK_BaseRequest.h"
#import "getCartList.h"
#import "HKDetailsPageViewController.h"
#import "HKLeBuyShoppingCartTableViewCell.h"
#import "HKLeBuyShoppingCartSectionView.h"
#import "HKCartToolVIew.h"
#import "HKConfirmationOfOrderViewController.h"
#import "HKShoppingViewModel.h"
@interface HKBaseCartListViewController ()<UITableViewDelegate,UITableViewDataSource,HKLeBuyShoppingCartTableViewCellDelegate,HKLeBuyShoppingCartSectionViewDelegete,HKCartToolVIewDelegate>
@property (nonatomic, strong)getCartList *cartList;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *selectArray;
@property (nonatomic, strong)HKCartToolVIew *toolView;
@property(nonatomic, assign) BOOL isEdit;
@end

@implementation HKBaseCartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setUI];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)setUI{
    self.title = @"购物车";
    [self.view addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.toolView.mas_top);
    }];
    [self setrightBarButtonItemWithTitle:@"编辑"];
}
-(void)gotoPay{
    HKConfirmationOfOrderViewController*vc = [[HKConfirmationOfOrderViewController alloc]init];
    vc.cartArray = self.selectArray;
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)deleteVc{
    NSMutableString*cartIds = [NSMutableString string];
    for (getCartListData*models in self.selectArray) {
        for (getCartListDataProducts*produt in models.products) {
            [cartIds appendString:produt.cartId];
            [cartIds appendString:@","];
        }
    }
    
    if (cartIds.length>0) {
        [cartIds deleteCharactersInRange:NSMakeRange(cartIds.length-1, 1)];
    }
    [HKShoppingViewModel deleteCartByid:@{@"loginUid":HKUSERLOGINID,@"cartId":cartIds} success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [self.selectArray removeAllObjects];
            self.isEdit = NO;
            [EasyShowTextView showSuccessText:@"删除成功" inView:self.view];
            [self loadData];
        }else{
            [EasyShowTextView showErrorText: @"删除失败" inView:self.view];
        }
    }];
}
-(void)rightBarButtonItemClick{
    self.isEdit = !self.isEdit;
}
-(void)loadData{
    [HK_BaseRequest buildPostRequest:get_cartList body:@{@"loginUid":LOGIN_UID} success:^(id  _Nullable responseObject) {
        getCartList *base = [getCartList mj_objectWithKeyValues:responseObject];
        if (base.responeSuc) {
            self.cartList = base;
            [self.tableView reloadData];
        }
    }failure:^(NSError * _Nullable error) {
        
    }];
}
-(void)selectAllWithIsSelect:(BOOL)isSelect{
    [self.selectArray removeAllObjects];
    int price = 0;
   
    for ( getCartListData*listM in self.cartList.data) {
        listM.isSelectList = isSelect;
        for (getCartListDataProducts*model in listM.products) {
            model.isSelect = isSelect;
            price += model.integral*model.number;
        }
    }
     getCartList*cartLists = [getCartList mj_objectWithKeyValues:[self.cartList mj_keyValues]];
    if (isSelect) {
       [self.selectArray addObjectsFromArray:cartLists.data];
        self.toolView.price = price;
    }else{
        self.toolView.price = 0;
    }
    
    
    [self.tableView reloadData];
}
-(void)selectCartSectionDataProducts:(getCartListData *)model isSelect:(BOOL)isSelect section:(NSInteger)section{
    for (getCartListData*models in self.selectArray) {
        if (models.randomID == model.randomID) {
            [self.selectArray removeObject:models];
            break;
        }
    }
    if (isSelect) {
        
        model.selectPrice = 0;
        for (getCartListDataProducts*model1 in model.products) {
            model1.isSelect = YES;
            model.selectPrice += model1.integral*model1.number;
        }
        [self.selectArray addObject:[getCartListData mj_objectWithKeyValues:[model mj_keyValues]]];
    }else{
        for (getCartListDataProducts*model1 in model.products) {
            model1.isSelect = NO;
        }
    }
    [self calculationTotalPrice];
    [self.tableView reloadData];
}
-(void)gotoInfo:(getCartListDataProducts *)model{
    HKDetailsPageViewController*vc = [[HKDetailsPageViewController alloc]init];
    vc.productId = model.productId;
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectCartListDataProducts:(getCartListDataProducts *)model isSelect:(BOOL)isSelect indexPath:(NSIndexPath *)indexPath{
    getCartListData*listM = self.cartList.data[indexPath.section];
    BOOL isHas = NO;
    getCartListData*selectListM;
    for (getCartListData*model2 in self.selectArray) {
        if (model2.randomID ==listM.randomID) {
            selectListM = model2;
            isHas = YES;
            break;
        }
    }
    if (!isHas) {
        selectListM = [[getCartListData alloc]init];
        selectListM.randomID = model.randomID;
        
        [self.selectArray addObject:selectListM];
    }
    if (isSelect) {
        selectListM.selectPrice += model.integral*model.number;
        [selectListM.products addObject:model];
    }else{
        selectListM.selectPrice -= model.integral*model.number;
        for (getCartListDataProducts*m in selectListM.products) {
            if (m.randomID == selectListM.randomID) {
                [selectListM.products removeObject:m];
                break;
            }
        }
    }
    if (selectListM.products.count == 0) {
        [self.selectArray removeObject:selectListM];
    }
    for (getCartListData*model3 in self.cartList.data) {
        if (model3.randomID==selectListM.randomID) {
            if (model3.products.count == selectListM.products.count) {
                model3.isSelectList = YES;
            }else{
                model3.isSelectList = NO;
            }
            break;
        }
    }
     [self calculationTotalPrice];
    [self.tableView reloadData];
}
-(void)calculationTotalPrice{
    NSInteger price = 0;
    for (getCartListData*models in self.selectArray) {
        price += models.selectPrice;
    }
    self.toolView.price = price;
}
-(void)numChange:(NSInteger)change products:(getCartListDataProducts *)model{
  
    if (model.isSelect) {
        self.toolView.price = self.toolView.price+change;
    }
    
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 24;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HKLeBuyShoppingCartSectionView*view = [[HKLeBuyShoppingCartSectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    view.model = self.cartList.data[section];
    view.section = section;
    view.delegate = self;
    view.isHideLine = NO;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cartList.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.cartList.data[section]products]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKLeBuyShoppingCartTableViewCell*cell = [HKLeBuyShoppingCartTableViewCell baseCellWithTableView:tableView];
    cell.model = [self.cartList.data[indexPath.section] products][indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.isHideLeft = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

-(void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    self.toolView.isEdit = isEdit;
}
-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
-(HKCartToolVIew *)toolView{
    if (!_toolView) {
        _toolView = [[HKCartToolVIew alloc]init];
        _toolView.delegate = self;
        _toolView.isEdit = NO;
    }
    return _toolView;
}
@end
