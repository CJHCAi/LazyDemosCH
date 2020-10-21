//
//  CXSearchViewController.m
//  CXShearchBar_Example
//
//  Created by caixiang on 2019/4/29.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXSearchViewController.h"
#import "CXSearchModel.h"
#import "CXSearchCollectionViewCell.h"
#import "CXSearchCollectionReusableView.h"
#import "CXSearchLayout.h"
#import "CXDBTool.h"

@interface CXSearchViewController ()<UICollectionReusableViewButtonDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *searchDataSource;
@property (strong, nonatomic) CXSearchLayout *searchLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

NSString *const kHistoryKey = @"kHistoryKey";
const CGFloat kMinimumInteritemSpacing = 10;
const CGFloat kFirstitemleftSpace = 20;

@implementation CXSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpdata];
}

- (void)setUpUI {
    self.navigationController.navigationBarHidden = YES;
    self.searchCollectionView.alwaysBounceVertical = YES;
    self.searchCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.searchTextField.delegate = self;
    self.searchCollectionView.dataSource = self;
    self.searchCollectionView.delegate = self;
    
    [self.searchCollectionView setCollectionViewLayout:self.searchLayout animated:YES];
    [self.searchCollectionView registerClass:[CXSearchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CXSearchCollectionReusableView class])];
    [self.searchCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CXSearchCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CXSearchCollectionViewCell class])];
}

- (void)setUpdata {
    NSArray *datas = @[@"化妆棉",@"面膜",@"口红",@"眼霜",@"洗面奶洗面奶洗面奶洗面奶洗面奶洗面奶洗面奶洗面奶",@"防晒霜",@"补水",@"香水香水香水香水香水",@"眉笔",@"香水香水香水香水香水",@"眉笔"];
    [datas enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXSearchModel *searchModel = [[CXSearchModel alloc] initWithName:obj searchId:[NSString stringWithFormat:@"%u",idx + 1]];
        [self.dataSource addObject:searchModel];
    }];
    //去数据库取数据
    NSArray *dbDatas =  [CXDBTool statusesWithKey:kHistoryKey];
    if (dbDatas.count > 0) {
        [self.searchDataSource setArray:dbDatas];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSource.count;
    } else if(section == 1) {
        return self.searchDataSource.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    CXSearchCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CXSearchCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.searchDataSource.count > 0) {
        return 2;
    }
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    CXSearchCollectionViewCell * searchCollectionViewCell = (CXSearchCollectionViewCell *)cell;
    CXSearchModel *searchModel;
    if (section == 0) {
         searchModel = self.dataSource[item];
    } else if (section == 1) {
        searchModel = self.searchDataSource[item];
    }
    searchCollectionViewCell.text = searchModel.content;
};

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]){
        CXSearchCollectionReusableView* searchCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([CXSearchCollectionReusableView class]) forIndexPath:indexPath];
        searchCollectionReusableView.delegate = self;
        if(indexPath.section == 0) {
            searchCollectionReusableView.text = @"热搜";
            searchCollectionReusableView.imageName = @"cool_icon";
            searchCollectionReusableView.hidenDeleteBtn = YES;
        }else if(indexPath.section == 1){
            searchCollectionReusableView.text = @"历史记录";
            searchCollectionReusableView.imageName = @"search_icon";
            searchCollectionReusableView.hidenDeleteBtn = NO;
        }
        reusableview = searchCollectionReusableView;
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if (section == 0) {
        CXSearchModel *searchModel = self.dataSource[item];
        return [CXSearchCollectionViewCell getSizeWithText:searchModel.content];
    } else if (section == 1) {
        CXSearchModel *searchModel = self.searchDataSource[item];
        return [CXSearchCollectionViewCell getSizeWithText:searchModel.content];
    }
    return CGSizeMake(80, 24);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    CXSearchModel *searchModel;
    if (section == 0) {
        searchModel =  self.dataSource[item];
    } else if (section == 1){
         searchModel =  self.searchDataSource[item];
    }
    [self showAlertWithTitle:[NSString stringWithFormat:@"您该去搜索 %@ 的相关内容了",searchModel.content]];
}

- (UIAlertController *)showAlertWithTitle:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

#pragma mark - textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        return NO;
    }
    /***  每搜索一次   就会存放一次到历史记录，但不存重复的*/
    __block BOOL isExist = NO;
    [self.searchDataSource enumerateObjectsUsingBlock:^(CXSearchModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([textField.text isEqualToString:obj.content]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    [self.dataSource enumerateObjectsUsingBlock:^(CXSearchModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([textField.text isEqualToString:obj.content]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (!isExist) {
        [self reloadData:textField.text];
    }
    return isExist;
}

- (void)reloadData:(NSString *)textString {
    CXSearchModel *searchModel = [[CXSearchModel alloc] initWithName:textString searchId:@""];
    [self.searchDataSource addObject:searchModel];
    //存数据
    [CXDBTool saveStatuses:[self.searchDataSource copy] key:kHistoryKey];
    [self.searchCollectionView reloadData];
    self.searchTextField.text = @"";
}

- (IBAction)cancleClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionReusableViewButtonDelegate
- (void)deleteDatas:(CXSearchCollectionReusableView *)view {
    [self.searchDataSource removeAllObjects];
    [self.searchCollectionView reloadData];
    [CXDBTool saveStatuses:@[] key:kHistoryKey];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)searchDataSource {
    if (!_searchDataSource) {
        _searchDataSource = [NSMutableArray array];
    }
    return _searchDataSource;
}

- (CXSearchLayout *)searchLayout{
    if (!_searchLayout) {
        _searchLayout = [[CXSearchLayout alloc] init];
        _searchLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
        _searchLayout.minimumInteritemSpacing = kMinimumInteritemSpacing;
        _searchLayout.minimumLineSpacing = kMinimumInteritemSpacing;
        _searchLayout.listItemSpace = kMinimumInteritemSpacing;
        _searchLayout.sectionInset = UIEdgeInsetsMake(20, kFirstitemleftSpace, 0, kFirstitemleftSpace);
    }
    return _searchLayout;
}

@end
