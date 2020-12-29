//
//  HKMyGoodsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyGoodsViewController.h"
#import "HKMyGoodsRespone.h"
#import "HKMyGoodsViewModel.h"
#import "HKMyGoodsTopView.h"
#import "MJRefresh.h"
#import "HKMyGoodsTableViewCell.h"
#import "HKEditMyGoodsViewController.h"
#import "HKSearchGoodsViewController.h"
#import "HKAddToolBtn.h"
#import "HKShareBaseModel.h"
#import "HKCollageShareView.h"
@interface HKMyGoodsViewController ()<HKMyGoodsTopViewDelegate,UITableViewDelegate,UITableViewDataSource,HKMyGoodsTableViewCellDelegate,HKAddToolBtnDelegate,HKEditMyGoodsViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKMyGoodsTopView *topView;
@property(nonatomic, assign) MYUpperProductOrder selectOrder;
@property (nonatomic,assign) int pageNum;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *downArray;
@property (nonatomic,assign) UpDownType type;
@property (nonatomic, strong)HKAddToolBtn *toolBtn;
@end

@implementation HKMyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = UpDownType_UP;
    self.pageNum = 1;
    [self setUI];
     self.selectOrder = MYUpperProductOrder_time;
}
-(void)setUI{
    self.title = @"我的商品";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(81);
    }];
    [self.view addSubview:self.toolBtn];
    [self.toolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.toolBtn.mas_top);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
    self.tableView.mj_footer.hidden = YES;
    
   
}
-(void)searchGoods{
    HKSearchGoodsViewController*vc = [[HKSearchGoodsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)upLoadData{
    self.pageNum = self.pageNum + 1;
    [self loadData];
}
-(void)addClick{
    HKEditMyGoodsViewController*vc = [[HKEditMyGoodsViewController alloc]init];
    vc.isAdd = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loadNewData{
    self.pageNum = 1;
    [[self getData] removeAllObjects];
    [self loadData];
}
-(void)loadData{
    NSDictionary*dict = @{@"loginUid":HKUSERLOGINID,@"order":[NSString stringWithFormat:@"%d",self.selectOrder],@"pageNumber":[NSString stringWithFormat:@"%d",self.pageNum]};
    [HKMyGoodsViewModel loadMyUpperProduct:dict andType:self.type  success:^(HKMyGoodsRespone *respone) {
        if (respone.code == 0) {
            [[self getData] addObjectsFromArray:respone.data.list];
            [self.tableView reloadData];
        }else{
            if (self.pageNum > 1) {
                self.pageNum = self.pageNum - 1;
            }
        }
        if (respone.data.lastPage) {
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}
-(void)addGoods:(MyGoodsInfo *)goodsM{
    self.type = UpDownType_UP;
    [self loadNewData];
}
-(void)updateaGoods:(MyGoodsInfo *)goodsM row:(NSIndexPath *)row{
   HKMyGoodsModel*model = [self getData][row.row];
    SkusModel*sM = goodsM.skus.firstObject;
    model.title = goodsM.title;
    model.price = sM.price;
    model.num = sM.num;
    [self.tableView reloadData];
}
-(void)selectOrderWithType:(MYUpperProductOrder)selectOrder{
    self.selectOrder = selectOrder;
}
-(void)switchUpDownWithType:(UpDownType)type{
    self.type = type;
    [self.tableView reloadData];
    if ([[self getData]count]==0) {
        [self loadNewData];
    }
}
-(void)gotoEditWithModel:(HKMyGoodsModel *)goodsM indexPath:(NSIndexPath *)indexpath{
    HKEditMyGoodsViewController*vc = [[HKEditMyGoodsViewController alloc]init];
    vc.productId = goodsM.productId;
    vc.indexPath = indexpath;
    vc.delegate = self;
    @weakify(self)
    vc.rowRefresh = ^(NSInteger row) {
        @strongify(self)
        if (row == -100) {
            [self loadNewData];
        }else{
        [[self getData]removeObjectAtIndex:row];
        [self.tableView reloadData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)gotoUpperLowerProductWithModel:(HKMyGoodsModel *)goodsM indexPath:(NSIndexPath *)indexpath state:(int)state{
    [HKMyGoodsViewModel goodUpperLowerProductWithProductId:goodsM.productId andState:state success:^(HKBaseResponeModel *respone) {
        if (respone.code.length>0 && respone.code.intValue == 0) {
            [[self getData]removeObjectAtIndex:indexpath.row];
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
-(void)shareWithModel:(HKMyGoodsModel *)model{
    
    HKShareBaseModel*shareM = [[HKShareBaseModel alloc]init];
    shareM.goodsModel = model;
    shareM.subVc = self;
    [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:shareM];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getData].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyGoodsTableViewCell*cell = [HKMyGoodsTableViewCell myGoodsTableViewCellWithTableView:tableView];
    cell.type = self.type;
    cell.goodsM = [self getData][indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.showType = 0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (HKMyGoodsTopView *)topView{
    if (!_topView) {
        _topView = [[HKMyGoodsTopView alloc]init];
        _topView.delegate = self;
    }
    return _topView;
}
-(void)setSelectOrder:(MYUpperProductOrder)selectOrder{
    _selectOrder = selectOrder;
    self.topView.selectOrder = selectOrder;
    [self loadNewData];
}
-(NSMutableArray*)getData{
    if (self.type == UpDownType_UP) {
        return self.dataArray;
    }else{
        return self.downArray;
    }
}
- (NSMutableArray *)downArray
{
    if(_downArray == nil)
    {
        _downArray = [ NSMutableArray array];
    }
    return _downArray;
}
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [ NSMutableArray array];
    }
    return _dataArray;
}
- (HKAddToolBtn *)toolBtn{
    if (!_toolBtn) {
        _toolBtn = [[HKAddToolBtn alloc]init];
        _toolBtn.delegate = self;
    }
    return _toolBtn;
}
@end
