//
//  HKSearchGoodsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchGoodsViewController.h"
#import "BackSearchNabarView.h"
#import "HKMyGoodsTableViewCell.h"
#import "HKMyGoodsViewModel.h"
#import "HKEditMyGoodsViewController.h"
@interface HKSearchGoodsViewController ()<BackSearchNabarViewDelegate,UITableViewDelegate,UITableViewDataSource,HKMyGoodsTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (copy, nonatomic) NSString *searchStr;
@property(nonatomic, assign) int pageNum;
@end

@implementation HKSearchGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    [self setUI];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
    self.tableView.mj_footer.hidden = YES;
}
-(void)setUI{
    self.title =@"搜索商品";
    self.showCustomerLeftItem = YES;
    [self.view addSubview:self.tableView];
  
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.nabarView.mas_bottom);
    }];
}
-(void)loadData{
    NSDictionary*dict = @{@"loginUid":HKUSERLOGINID,@"title":_searchStr,@"pageNumber":@(self.pageNum)};
    [HKMyGoodsViewModel searchGoods:dict success:^(HKMyGoodsRespone *respone) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (respone.data.lastPage) {
            self.tableView.mj_header.hidden = YES;
        }else{
            self.tableView.mj_header.hidden = YES;
        }
        if (respone.code == 0) {
            [self.questionArray addObjectsFromArray:respone.data.list];
            [self.tableView reloadData];
        }else{
            if (self.pageNum >1) {
                self.pageNum --;
            }
        }
    }];
}
-(void)upLoadData{
    self.pageNum ++;
    [self loadData];
}
-(void)loadNewData{
    [self.questionArray removeAllObjects];
    self.pageNum = 1;
    [self loadData];
}
- (void)textChangeWithText:(NSString *)textStr{
    _searchStr = textStr;
    [self loadNewData];
}
-(void)gotoEditWithModel:(HKMyGoodsModel *)goodsM indexPath:(NSIndexPath *)indexpath{
    HKEditMyGoodsViewController*vc = [[HKEditMyGoodsViewController alloc]init];
    vc.productId = goodsM.productId;
    vc.indexPath = indexpath;
   @weakify(self)
    vc.rowRefresh = ^(NSInteger row) {
        @strongify(self)
        [self.questionArray removeObjectAtIndex:row];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)gotoUpperLowerProductWithModel:(HKMyGoodsModel *)goodsM indexPath:(NSIndexPath *)indexpath state:(int)state{
    [HKMyGoodsViewModel goodUpperLowerProductWithProductId:goodsM.productId andState:state success:^(HKBaseResponeModel *respone) {
        if (respone.code.length>0 && respone.code.intValue == 0) {
            [[self questionArray]removeObjectAtIndex:indexpath.row];
            [self.tableView reloadData];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancleClick {
    [self.navigationController popViewControllerAnimated:YES];
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
    return self.questionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyGoodsTableViewCell*cell = [HKMyGoodsTableViewCell myGoodsTableViewCellWithTableView:tableView];
    HKMyGoodsModel *goodsM = self.questionArray[indexPath.row];
    cell.type = !(int)goodsM.isupper;
    cell.goodsM = goodsM;
    cell.delegate = self;
    cell.showType = 0;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
@end
