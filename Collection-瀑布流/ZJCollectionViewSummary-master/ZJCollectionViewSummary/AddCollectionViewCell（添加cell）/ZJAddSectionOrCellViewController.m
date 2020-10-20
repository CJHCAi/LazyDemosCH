//
//  ZJAddSectionOrCellViewController.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/5/29.
//  Copyright © 2018年 James. All rights reserved.
//

/**
 项目地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git
 
 也可以到博客下看看相关介绍
 博客地址：https://www.jianshu.com/p/ff7089782d6c
 
 有什么错误或使用不便的地方可以留言或加我QQ
 
 QQ：1224740397
 */

#import "ZJAddSectionOrCellViewController.h"
#import "ZJGroupingCollectionViewFlowLayout.h"
#import "ZJGroupingCollectionViewCell.h"

@interface ZJAddSectionOrCellViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *listArray;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic, assign) BOOL isHiddenCellDelete;
@property (nonatomic,strong) UIBarButtonItem *deleteCellBt;
@end

@implementation ZJAddSectionOrCellViewController

static NSString *ItemIdentifier = @"ItemIdentifier";

static NSString *AddSectionOrCellViewHeadID = @"ZJAddSectionOrCellViewHeadID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加cell或section";
    [self.view addSubview:self.collectionView];
    [self setDataArrayAndListArray];
    
    self.isHiddenCellDelete = YES;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setUpNavigationRightBarButtonItems];
}

- (void)setDataArrayAndListArray
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"allBrand" ofType:@"plist"];
    NSArray *dataA = [NSArray arrayWithContentsOfFile:path];
    _dataArray = [NSMutableArray arrayWithArray:dataA];
    NSMutableArray *listA = [NSMutableArray array];
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [listA addObject:obj[@"brandKey"]];
    }];
    self.listArray = [NSArray arrayWithArray:listA];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDictionary *dict = self.dataArray[section];
    NSArray *brandA = dict[@"brands"];
    
    return brandA.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJGroupingCollectionViewCell *cell;
    
    if (cell == nil) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    }
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSArray *brandA = dict[@"brands"];
    NSDictionary *brandDict = brandA[indexPath.row];
    
    if ((brandA.count - 1) == indexPath.row) {
        cell.nameLabel.text = @"添加";
        cell.nameLabel.textColor = [UIColor redColor];
        cell.imageV.image = [UIImage imageNamed:@"add_icon"];
        cell.imageV.backgroundColor = [UIColor blackColor];
    }else{
        cell.nameLabel.text = brandDict[@"name"];
        cell.nameLabel.textColor = [UIColor lightGrayColor];
        cell.imageV.backgroundColor = randomColor;
        cell.imageV.image = [UIImage imageNamed:@"James"];
    }
    if(self.isHiddenCellDelete){
        //正常情况下，所有删除按钮都隐藏；
        cell.deleteButton.hidden = YES;
    }else{
        if (indexPath.row == brandA.count - 1){
            cell.deleteButton.hidden = true;
        }else{
            cell.deleteButton.hidden = false;
        }
    }
    [cell.deleteButton addTarget:self action:@selector(clickCellDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *reusableHeaderView = nil;
        
        if (reusableHeaderView==nil) {
            
            reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:AddSectionOrCellViewHeadID forIndexPath:indexPath];
            
            reusableHeaderView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
            
            UILabel *label = (UILabel *)[reusableHeaderView viewWithTag:100];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 40)];
                label.tag = 100;
                [reusableHeaderView addSubview:label];
            }
            NSDictionary *dict = self.dataArray[indexPath.section];
            
            label.text = dict[@"brandKey"];
        }
        return reusableHeaderView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.section]];
    NSMutableArray *brandA = [NSMutableArray arrayWithArray:dict[@"brands"]];
    if ((indexPath.row == brandA.count - 1)) {
        NSString *addNameStr = [NSString stringWithFormat:@"%ld行新增",indexPath.row + 1];
        NSDictionary *addDict = @{@"name":addNameStr};
        [brandA addObject:addDict];
        dict[@"brands"] = brandA;
        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:dict];
        
        [self.collectionView reloadData];
    }else{
        NSLog(@"第%ld个section,点击图片%ld",indexPath.section,indexPath.row);
    }
}

- (void)clickCellDeleteButton:(UIButton *)button
{
    ZJGroupingCollectionViewCell *cell = (ZJGroupingCollectionViewCell *)[[button superview]superview];
    //需要遵循UICollectionViewDelegateFlowLayout
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.section]];
    NSMutableArray *brandA = [NSMutableArray arrayWithArray:dict[@"brands"]];
    [brandA removeObjectAtIndex:indexPath.row];
    dict[@"brands"] = brandA;
    [self.dataArray replaceObjectAtIndex:indexPath.section withObject:dict];
    
    [self.collectionView reloadData];
}

- (void)setUpNavigationRightBarButtonItems
{
    //添加
    UIBarButtonItem *addSectionBt = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(clickAddSectionBt:)];
    //删除
    UIBarButtonItem *deleteCellBt = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(clickDeleteCellBt:)];
    self.deleteCellBt = deleteCellBt;
    NSArray *buttonItem = @[addSectionBt,deleteCellBt];
    self.navigationItem.rightBarButtonItems = buttonItem;
}
//添加section
- (void)clickAddSectionBt:(UIBarButtonItem *)buttonItem
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入修改后的描述文字" preferredStyle:UIAlertControllerStyleAlert];
    //以下方法就可以实现在提示框中输入文本；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *cellDescTextField = alertController.textFields.firstObject;
        NSString *cellDesc = cellDescTextField.text;
        NSArray *array = @[@{@"name":@"韦德"},@{@"name":@"韦德"},@{@"name":@"韦德"},@{@"name":@"韦德"},@{@"name":@"韦德"},@{@"name":@"韦德"}];
        NSDictionary *dict = @{@"brandKey":cellDesc,@"brands":array};
        [self.dataArray insertObject:dict atIndex:0];
        
        [self.collectionView reloadData];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入Section名称";
    }];
    [self presentViewController:alertController animated:true completion:nil];
}
//删除cell
- (void)clickDeleteCellBt:(UIBarButtonItem *)buttonItem
{
    self.isHiddenCellDelete = !self.isHiddenCellDelete;
    self.deleteCellBt.title = self.isHiddenCellDelete?@"编辑":@"完成";
    [self.collectionView reloadData];
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGRect size = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        ZJGroupingCollectionViewFlowLayout *layout = [[ZJGroupingCollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:size collectionViewLayout:layout];
        [_collectionView registerClass:[ZJGroupingCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AddSectionOrCellViewHeadID];
    }
    return _collectionView;
}

@end
