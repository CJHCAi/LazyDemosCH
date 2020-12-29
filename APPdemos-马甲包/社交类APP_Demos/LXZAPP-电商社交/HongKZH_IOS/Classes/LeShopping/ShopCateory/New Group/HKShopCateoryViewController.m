//
//  HKShopCateoryViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopCateoryViewController.h"
#import "HKCateortyRowTableViewCell.h"
#import "HKShoppingViewModel.h"
#import "HKUserCategoryListRespone.h"
#import "HKSubCategoryListRespone.h"
#import "HKSubCateortyCollectionViewCell.h"
#import "HKSubCategoryHeadCollectionViewCell.h"
#import "HKShopCateoryListViewController.h"
@interface HKShopCateoryViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger selectRow;
@property (nonatomic, strong)NSArray *oneArray;
@end

@implementation HKShopCateoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)loadData{
    [HKShoppingViewModel getCategoryListSuccess:^(HKUserCategoryListRespone *responde) {
        if (responde.responeSuc) {
            self.oneArray = responde.data;
    
            self.selectRow = 0;
            
        }
    }];
}
-(void)setUI{
    self.title = @"商品分类";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.mas_equalTo(85);
    }];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.mas_right).offset(1);
        make.top.bottom.right.equalTo(self.view);
    }];
    UIView*view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorFromHexString:@"EEEEEE"];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(self.tableView.mas_right);
        make.width.mas_equalTo(1);
    }];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKSubCateortyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKSubCateortyCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKSubCategoryHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKSubCategoryHeadCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    HKUserCategoryListModel*model = self.oneArray[self.selectRow];
    return model.subCategory.data.categorys.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKSubCategoryHeadCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKSubCategoryHeadCollectionViewCell" forIndexPath:indexPath];
        
        HKUserCategoryListModel*model = self.oneArray[self.selectRow];
        if (model.subCategory) {
            cell.respone = model.subCategory;
        }
        return cell;
    }
    HKSubCateortyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSubCateortyCollectionViewCell class]) forIndexPath:indexPath];
    
    HKUserCategoryListModel*model = self.oneArray[self.selectRow];
    cell.model = model.subCategory.data.categorys[indexPath.item];
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        CGFloat w = kScreenWidth-86 - 30;
        CGFloat h = w*5/13;
        return CGSizeMake(w, h);
    }
    return CGSizeMake(kScreenWidth/3, 105);
}






// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HKShopCateoryListViewController*vc = [[HKShopCateoryListViewController alloc]init];
      HKUserCategoryListModel*model = self.oneArray[self.selectRow];
    vc.categoryId = [model.subCategory.data.categorys[indexPath.item]categoryId];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.oneArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCateortyRowTableViewCell*cell = [HKCateortyRowTableViewCell baseCellWithTableView:tableView];
    if (self.selectRow == indexPath.row) {
        cell.selectRow = YES;
    }else{
        cell.selectRow = NO;
    }
    cell.titleText = [self.oneArray[indexPath.row]name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectRow = indexPath.row;
}
-(void)setOneArray:(NSArray *)oneArray{
    _oneArray = oneArray;
    [self.tableView reloadData];
}
-(void)setSelectRow:(NSInteger)selectRow{
    _selectRow = selectRow;
    [self.tableView reloadData];
    HKUserCategoryListModel*model = self.oneArray[selectRow];
    if (model.subCategory.data.categorys.count>0) {
        [self.collectionView reloadData];
    }else{
        [HKShoppingViewModel getSubCategoryList:@{@"categoryId":model.categoryId} success:^(HKSubCategoryListRespone *responde) {
            if (responde.responeSuc) {
                responde.data.name = model.name;
                model.subCategory = responde;
                [self.collectionView reloadData];
            }
        }];
    }
}
@end
