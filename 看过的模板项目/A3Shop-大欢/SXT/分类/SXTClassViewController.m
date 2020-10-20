//
//  SXTClassViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/17.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTClassViewController.h"
#import "SXTClassCollectionView.h"
#import "SXTEffectClassModel.h"
#import "SXTClassCollectionModel.h"
#import "MJExtension.h"//mj数据转模型

#import "SXTGoodsListViewController.h"
@interface SXTClassViewController ()
@property (strong, nonatomic)   SXTClassCollectionView *classCollection;              /** 分类列表 */

@end

@implementation SXTClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.classCollection];
    __weak typeof (self) weakSelf = self;
    [_classCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self referData];
    
}

- (void)referData{
    
    //推荐品牌
    [self getData:@"appBrandareanew/findBrandareanew.do" param:nil success:^(id responseObject) {
        _classCollection.classicClassArray = [SXTClassCollectionModel mj_objectArrayWithKeyValuesArray:responseObject];
        [_classCollection reloadData];
    } error:^(NSError *error) {
        
    }];
    //经典品牌
    [self getData:@"appBrandarea/asianBrand.do" param:nil success:^(id responseObject) {
        _classCollection.recommendClassArray = [SXTClassCollectionModel mj_objectArrayWithKeyValuesArray:responseObject];
        [_classCollection reloadData];
    } error:^(NSError *error) {
        
    }];
    //功效
    [self getData:@"appBrandareatype/findBrandareatype.do" param:nil success:^(id responseObject) {
        _classCollection.effectArray = [SXTEffectClassModel mj_objectArrayWithKeyValuesArray:responseObject];
        [_classCollection reloadData];
    } error:^( NSError *error) {
        
    }];
    
}

- (SXTClassCollectionView *)classCollection{
    if (!_classCollection) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        NSInteger itemWidth = 0;
        if (VIEW_WIDTH > 400) {
            itemWidth = (VIEW_WIDTH - 4) / 5;
        }else{
            itemWidth = (VIEW_WIDTH - 3) / 4;
        }
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 1, 0);
        flowLayout.headerReferenceSize = CGSizeMake(0, 35);
        _classCollection = [[SXTClassCollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        _classCollection.backgroundColor = RGB(245, 245, 245);
        __weak typeof (self) weakSelf = self;
        _classCollection.selectCellBlock = ^ (NSDictionary *parameterDic){
            [weakSelf pushToClassListViewController:parameterDic];
        };
        
    }
    return _classCollection;
}

- (void)pushToClassListViewController:(NSDictionary *)parameterDic{
    SXTGoodsListViewController *classList = [[SXTGoodsListViewController alloc]init];
//    classList.idDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:parameterDic[@"URL"],@"URL",parameterDic[@"ShopID"],@"ID",parameterDic[@"Type"],@"keyword", nil];
    [self.navigationController pushViewController:classList animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
