//
//  WShopSearchViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WShopSearchViewController.h"
#import "WTypeBtnView.h"
#import "WSearchGoodModel.h"
#import "WSearchGoodsCell.h"
#import "WFilterView.h"
#import "GoodsModel.h"
static NSString *const kReusableSearchcellIdentifier = @"SearchcellIdentifier";

@interface WShopSearchViewController ()<TopSearchViewDelegate,UITableViewDelegate,UITableViewDataSource,WTypeBtnViewDelegate,WfilterViewDelegate>
{
    BOOL _selectedFilertBtn;
    NSString *_pxType;//综合 价格 销量
    NSString *_searchText;
}
@property (nonatomic,strong) TopSearchView *topSearchView; /*顶部搜索*/
@property (nonatomic,strong) ScrollerView *scrollerView; /*滚动图*/
/**搜索结果TableView*/
@property (nonatomic,strong) UITableView *tableView;
/**返回按钮*/
@property (nonatomic,strong) UIButton *leftBtn;
/**筛选btn*/
@property (nonatomic,strong) UIButton *filterBtn;
/**综合价格人气销量*/
@property (nonatomic,strong) WTypeBtnView *btnView;
/**筛选页面*/
@property (nonatomic,strong) WFilterView *filterView;

/**搜索model（和商品model一样）*/
@property (nonatomic,strong) NSArray <GoodsDatalist *>* goodsList;

@end

@implementation WShopSearchViewController
- (instancetype)initWithText:(NSString *)sarchText
{
    self = [super init];
    if (self) {
        _searchText = sarchText;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pxType = @"ZH";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.topSearchView];
    [self.view addSubview:self.btnView];
    [self.view addSubview:self.tableView];
    
    [self postGoodsListWithGoodsName:_searchText label:@"" minPrice:@"" maxProce:@"" typePx:_pxType WhileComplete:^{
        
    }];
    
}


#pragma mark *** UITableViewDadaSourceAndDelegate***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.goodsList&&self.goodsList.count) {
        return self.goodsList.count;
    }
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WSearchGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:kReusableSearchcellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[WSearchGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReusableSearchcellIdentifier];
    }
    GoodsDatalist *good = self.goodsList[indexPath.row];
    cell.cellImage.imageURL = [NSURL URLWithString:good.CoCover];
    cell.cellLabel.text = good.CoConame;
    cell.cellPrice.text = [NSString stringWithFormat:@"%ld",(long)good.CoprActpri];
    cell.goodsId = [NSString stringWithFormat:@"%ld",(long)good.CoId];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WSearchGoodsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", cell.goodsId);
    
}
#pragma mark *** WFilterViewDelegate ***
-(void)WfilterView:(WFilterView *)filterView completeFilterDictionary:(NSDictionary *)filterDic{
    _filterBtn.selected = false;
    
    NSString *label = filterDic[@"filter"]?filterDic[@"filter"]:@"";
    NSString *max = filterDic[@"max"];
    NSString *min = filterDic[@"min"];
    
    [self postGoodsListWithGoodsName:self.topSearchView.searchLabel.text label:label minPrice:min maxProce:max typePx:_pxType WhileComplete:^{
        
    }];
}
#pragma mark *** 网络请求 ***
/**
 *  搜索接口
 *
 *  @param name     搜索的商品
 *  @param label    筛选的内容
 *  @param minPrice 筛选的min
 *  @param maxPrice 筛选的max
 *  @param type     综合，加个，销量
 *  @param back     完成回调
 */
-(void)postGoodsListWithGoodsName:(NSString *)name
                            label:(NSString *)label
                         minPrice:(NSString *)minPrice
                         maxProce:(NSString *)maxPrice
                             typePx:(NSString *)type
                    WhileComplete:(void (^)())back{
    
    __weak typeof(self)weakSelf = self;
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"pagenum":@"1",
                                                @"pagesize":@"20",
                                                @"type":@"",
                                                @"label":label,
                                                @"coname":name,
                                                @"shoptype":@"GEN",
                                                @"qsj":minPrice,
                                                @"jwj":maxPrice,
                                                @"px":type,
                                                @"issx":@"1",
                                                } requestID:GetUserId requestcode:kRequestCodegetcomlist success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                    if (succe) {
                                                        NSLog(@"--goods--%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
                                                        GoodsModel *model = [GoodsModel modelWithJSON:jsonDic[@"data"]];
                                                        weakSelf.goodsList = model.datalist;
                                                        [weakSelf.tableView reloadData];
                                                        back();
                                                    }
                                                } failure:^(NSError *error) {
                                                    
                                                }];
}



#pragma mark *** TopSearchViewDelegate ***

-(void)TopSearchViewDidTapView:(TopSearchView *)topSearchView{
    
    MYLog(@"点击搜索");
    
    [self postGoodsListWithGoodsName:self.topSearchView.searchLabel.text label:@"" minPrice:@"" maxProce:@"" typePx:_pxType WhileComplete:^{
        
    }];
    
}
#pragma mark *** WtypeBtnDelegate ***
-(void)typeBtnView:(WTypeBtnView *)btnView didSelectedTitle:(NSString *)title{
    MYLog(@"%@",title);
    
    NSDictionary *titleDic = @{@"综合":@"ZH",
                               @"价格":@"MONEY",
                               @"销量":@"XL"};
    _pxType = titleDic[title];
    
    [self postGoodsListWithGoodsName:self.topSearchView.searchLabel.text label:@"" minPrice:@"" maxProce:@"" typePx:_pxType WhileComplete:^{
        
    }];
    
}
#pragma mark *** Events ***

-(void)respondsToRightBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    MYLog(@"筛选按钮");
       if(sender.selected){
         [self.view addSubview:self.filterView];
    }else{
        [self.filterView removeFromSuperview];
    }
}
-(void)respondsToReturnBtn{
    MYLog(@"返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark *** getters ***
-(TopSearchView *)topSearchView{
    if (!_topSearchView) {
        _topSearchView = [[TopSearchView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, StatusBar_Height+NavigationBar_Height)];
        _topSearchView.searchLabel.placeholder = @"输入关键词";
        _topSearchView.delegate = self;
        _topSearchView.searchLabel.text = _searchText;
        _topSearchView.searchView.frame = CGRectMake(0.05*Screen_width+20, SearchToTop, 0.8*Screen_width-20, SearchView_Height);
        _topSearchView.searchImage.frame = CGRectMake(CGRectGetMaxX(self.topSearchView.searchView.frame)-4*SearchImage_Size, self.topSearchView.searchView.bounds.size.height/2-SearchImage_Size/2, SearchImage_Size, SearchImage_Size);
        [_topSearchView.menuBtn removeAllTargets];
        [_topSearchView.menuBtn removeFromSuperview];
        [_topSearchView addSubview:self.filterBtn];
        [_topSearchView addSubview:self.leftBtn];
    }
    return _topSearchView;
}
-(UIButton *)filterBtn{
    if (!_filterBtn) {
        _filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(630*AdaptationWidth(), 30, 75*AdaptationWidth(), 24)];
        [_filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = MFont(12);
        [_filterBtn setImage:MImage(@"sel2") forState:UIControlStateNormal];
        [_filterBtn setImage:MImage(@"sel1") forState:UIControlStateSelected];
        _filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_filterBtn.imageView.frame.size.width - _filterBtn.frame.size.width + _filterBtn.titleLabel.frame.size.width, 0, 0);
        _filterBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_filterBtn.titleLabel.frame.size.width - _filterBtn.frame.size.width + _filterBtn.imageView.frame.size.width);

        _filterBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_filterBtn addTarget:self action:@selector(respondsToRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterBtn;
}
-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, StatusBar_Height, 44, 44)];
        [_leftBtn setImage:MImage(@"fanhui") forState:0];
        [_leftBtn addTarget:self action:@selector(respondsToReturnBtn) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftBtn;
}
-(WTypeBtnView *)btnView{
    if (!_btnView) {
        _btnView = [[WTypeBtnView alloc] initWithFrame:CGRectMake(0, CGRectYH(self.topSearchView), Screen_width, 70*AdaptationWidth())];
        _btnView.delegate = self;
        
    }
    return _btnView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectYH(self.btnView)+4, Screen_width, HeightExceptNaviAndTabbar-self.btnView.bounds.size.height-4)];
        _tableView.rowHeight = 200*AdaptationWidth();
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[WSearchGoodsCell class] forCellReuseIdentifier:kReusableSearchcellIdentifier];

    }
    return _tableView;
}
-(WFilterView *)filterView{
    if (!_filterView) {
        _filterView = [[WFilterView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar)];
        _filterView.delegate = self;
    }
    return _filterView;
}
@end
