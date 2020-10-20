//
//  WShopCartView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WShopCartView.h"
#import "WCartTableViewCell.h"
#import "WCartTableHeaderView.h"
#import "WCartTableFooterView.h"
#import "WCartMode.h"
#import "OrderSureViewController.h"
static NSString *const kReusableCartCellIdentifier = @"WCartTableViewCell.h";

@interface WShopCartView()<UITableViewDataSource,UITableViewDelegate,WCartTableHeaderDelegate,WcarTableFooterViewDelegate,WCartTableViewCellDelegate>
{
    BOOL _isSelectedEditBtn;
    CGFloat _sumPrice;
    NSMutableArray *_selectedCellArr;//选中的商品arr
    CGFloat _allPrice;
}

/**白色背景图*/
@property (nonatomic,strong) UIView *whiteView;

/**table*/
@property (nonatomic,strong) UITableView *tableView;

/**tableModel*/
@property (nonatomic,strong)NSArray <WCartMode *>*carModel;

/**尾部视图*/
@property (nonatomic,strong) WCartTableFooterView *footView;



@end
@implementation WShopCartView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
        [self getCartData];
    }
    return self;
}

-(void)reloadallData{
    [self getCartData];
}
#pragma mark *** 初始化数据 ***
-(void)initData{
    _selectedCellArr = [@[] mutableCopy];
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self addSubview:backView];
    UITapGestureRecognizer *tapGus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToBackViewGes)];
    [backView addGestureRecognizer:tapGus];
    
    [self addSubview:self.tableView];
    [self addSubview:self.footView];
}

#pragma mark *** post购物车数据 ***
-(void)getCartData{
    __weak typeof(self)wkSelf = self;
    [TCJPHTTPRequestManager POSTWithParameters:@{} requestID:GetUserId requestcode:kRequestCodegetshopcar success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSLog(@"购物车--%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
            
            wkSelf.carModel = [NSArray modelArrayWithClass:[WCartMode class] json:jsonDic[@"data"]];
            [wkSelf.tableView reloadData];
            wkSelf.userInteractionEnabled = YES;
            wkSelf.footView.priceLabel.text = @"¥0.0";
            [_selectedCellArr removeAllObjects];
        }
    } failure:^(NSError *error) {
        
    }];
}
/** 改变购物车数据 */
-(void)changeCartDataWith:(NSString *)cartId
                  goodsId:(NSString *)goodsId
              goodsTypeId:(NSString *)typeId ShcountId:(NSString *)count{
    __weak typeof(self)wkSelf = self;
    self.userInteractionEnabled = false;
    [TCJPHTTPRequestManager POSTWithParameters:@{@"ShId":cartId,
                                                 @"ShCoid":goodsId,
                                                 @"ShCoprid":typeId,
                                                 @"ShCount":count,
                                                 @"ShMeid":GetUserId} requestID:GetUserId requestcode:kRequestCodeeditshopcar success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                     if (succe) {
                                                         NSLog(@"%@", jsonDic[@"data"]);
                                                         [wkSelf getCartData];
                                                     }
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
}
/** 删除购物车 */
-(void)deleteCartDataWithCartId:(NSString *)cartId{
    __weak typeof(self)wkSelf = self;
    [TCJPHTTPRequestManager POSTWithParameters:@{@"ShId":cartId} requestID:GetUserId requestcode:kRequestCodedelshopcar success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            [wkSelf getCartData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark *** gestureEvents ***
-(void)respondsToBackViewGes{
    [self removeFromSuperview];
}
#pragma mark *** UITableViewDelegate ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.carModel && self.carModel.count!=0) {
        _sumPrice = 0.0;
        _allPrice = 0.0;
        return self.carModel.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReusableCartCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[WCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReusableCartCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WCartMode *car = self.carModel[indexPath.row];

    cell.cellName.text = car.CoName;
    cell.cellImage.imageURL = [NSURL URLWithString:car.Cover];
    cell.cellType.text = car.CoprData;
    cell.cellPrice.text = [NSString stringWithFormat:@"¥%ld",(long)car.CoprActpri];
    cell.cellCarId = [NSString stringWithFormat:@"%ld",(long)car.ShId];
    cell.cellGoodsId = [NSString stringWithFormat:@"%ld",(long)car.CoId];
    cell.cellNumber.countLb.text = [NSString stringWithFormat:@"%ld",(long)car.CoprCount];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.cellTypeId = [NSString stringWithFormat:@"%ld",(long)car.CoprId];
    cell.cellDisPrice = [NSString stringWithFormat:@"%ld",(long)car.CoprMoney];
    cell.cellSelectBtn.selected = car.Selected;
    
    return  cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WCartTableHeaderView *headView = [[WCartTableHeaderView alloc] initWithFrame:AdaptationFrame(0, 0, self.tableView.bounds.size.width/AdaptationWidth(), 66)];
    [CALayer drawBottomBorder:headView];
    headView.delegate = self;
    return headView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WCartTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.cellSelectBtn.selected) {
        return;
    }
     [_selectedCellArr addObject:cell];
    self.carModel[indexPath.row].Selected = true;
    cell.cellSelectBtn.selected = true;
    NSString *price = [cell.cellPrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    NSString *footPrice = [self.footView.priceLabel.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    _sumPrice =[footPrice floatValue]+[cell.cellNumber.countLb.text floatValue]*[price floatValue];
    self.footView.priceLabel.text = [NSString stringWithFormat:@"¥%.1f",_sumPrice];
//    [self.tableView reloadData];
    

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WCartTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.cellSelectBtn.selected) {
        return;
    }
    [_selectedCellArr removeObject:cell];
    self.carModel[indexPath.row].Selected = false;
    cell.cellSelectBtn.selected = false;
    NSString *price = [cell.cellPrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    NSString *footPrice = [self.footView.priceLabel.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    _sumPrice =[footPrice floatValue]-[cell.cellNumber.countLb.text floatValue]*[price floatValue];
    self.footView.priceLabel.text = [NSString stringWithFormat:@"¥%.1f",_sumPrice];
//    [self.tableView reloadData];

}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_isSelectedEditBtn) {
//        return UITableViewCellEditingStyleDelete;
//    }
//    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
//    
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"删除了--%@", NSStringFromSelector(_cmd));
    WCartTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self deleteCartDataWithCartId:cell.cellCarId];
    
}

#pragma mark *** WCartTableHeaderViewDelegate ***
-(void)WcartTableHeaderView:(WCartTableHeaderView *)headerView didSeletedButtion:(UIButton *)sender{
    NSLog(@"%@", sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
//        [_selectedCellArr removeAllObjects];
//        self.footView.priceLabel.text = @"¥0.0";
//        _isSelectedEditBtn = !_isSelectedEditBtn;
//        //触发改变编辑样式
//        _tableView.editing = !_tableView.editing;
//        _tableView.editing = true;
    }else{
        sender.selected = !sender.selected;
        if (sender.selected) {
//            self.footView.priceLabel.text = [NSString stringWithFormat:@"¥%.1lf",_sumPrice];
            [_selectedCellArr removeAllObjects];
            CGFloat allPrice = 0.0;
            for (int idx = 0; idx<self.carModel.count; idx++) {
                WCartTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                cell.cellSelectBtn.selected = true;
                self.carModel[idx].Selected = true;
                [_selectedCellArr addObject:cell];
                allPrice+=  self.carModel[idx].CoprActpri*self.carModel[idx].CoprCount;
            }
            NSLog(@"全选");
            self.footView.priceLabel.text = [NSString stringWithFormat:@"¥%.1f",allPrice];
        }else{
            [_selectedCellArr removeAllObjects];
            for (int idx = 0; idx<self.carModel.count; idx++) {
                WCartTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                cell.cellSelectBtn.selected = false;
                self.carModel[idx].Selected = false;
            }
            NSLog(@"反选");
            self.footView.priceLabel.text = [NSString stringWithFormat:@"¥0.0"];
        }

    }
}
#pragma mark *** WCartTableFooterViewDelegate ***
-(void)WCartTableFooterView:(WCartTableFooterView *)footView didSelectedButton:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"全选"]) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            [_selectedCellArr removeAllObjects];
            CGFloat allPrice = 0.0;
            for (int idx = 0; idx<self.carModel.count; idx++) {
                WCartTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                cell.cellSelectBtn.selected = true;
                self.carModel[idx].Selected = true;
                [_selectedCellArr addObject:cell];
                allPrice+=  self.carModel[idx].CoprActpri*self.carModel[idx].CoprCount;
            }
            NSLog(@"全选");
            self.footView.priceLabel.text = [NSString stringWithFormat:@"¥%.1f",allPrice];

        }else{
            [_selectedCellArr removeAllObjects];
            for (int idx = 0; idx<self.carModel.count; idx++) {
                WCartTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                cell.cellSelectBtn.selected = false;
                self.carModel[idx].Selected = false;
            }
            NSLog(@"反选");
            self.footView.priceLabel.text = [NSString stringWithFormat:@"¥0.0"];

        }
    }
    else{
        //去结算
        NSLog(@"选中的商品,--:%@", _selectedCellArr);
        
        if (_selectedCellArr.count==0) {
            [SXLoadingView showAlertHUD:@"请选择至少一个商品" duration:0.5];
            return;
        }
        
        OrderSureViewController *sureVc = [[OrderSureViewController alloc]initWithShopTitle:@"确认订单信息" image:MImage(@"chec") selectedArr:_selectedCellArr];
        [self.viewController.navigationController pushViewController:sureVc animated:true];
    }
}
#pragma mark *** WCartCellDelegate ***
-(void)WCartTableViewCell:(WCartTableViewCell *)cartCell atIndexPath:(NSIndexPath *)indexPath changedCellNumber:(NSString *)number{
    [self changeCartDataWith:cartCell.cellCarId goodsId:cartCell.cellGoodsId goodsTypeId:cartCell.cellTypeId ShcountId:number];
    
}
#pragma mark *** getters ***
-(UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(45, 0, self.bounds.size.width, self.bounds.size.height)];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(45, 0, self.bounds.size.width-45, self.bounds.size.height-93*AdaptationWidth())];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[WCartTableViewCell class] forCellReuseIdentifier:kReusableCartCellIdentifier];
        _tableView.rowHeight = 300*AdaptationWidth();
        _tableView.sectionHeaderHeight = 66*AdaptationWidth();
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsMultipleSelection = YES;
//      _tableView.editing = false;
    }
    return _tableView;
}

-(WCartTableFooterView *)footView{
    if (!_footView) {
        _footView = [[WCartTableFooterView alloc] initWithFrame:CGRectMake(CGRectX(self.tableView), self.bounds.size.height-93*AdaptationWidth(), self.tableView.bounds.size.width, 93*AdaptationWidth())];
        _footView.delegate = self;
    }
    return _footView;
}
@end
