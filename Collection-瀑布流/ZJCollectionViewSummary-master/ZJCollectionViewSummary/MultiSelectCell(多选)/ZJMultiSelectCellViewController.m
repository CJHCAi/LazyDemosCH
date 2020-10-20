//
//  ZJMultiSelectCellViewController.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/11.
//  Copyright © 2018年 James. All rights reserved.
//

/**
 项目地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git
 
 也可以到博客下看看相关介绍
 博客地址：https://www.jianshu.com/p/ff7089782d6c
 
 有什么错误或使用不便的地方可以留言或加我QQ
 
 QQ：1224740397
 */

#import "ZJMultiSelectCellViewController.h"

#import "ZJGroupingCollectionViewFlowLayout.h"
#import "ZJMultiSelectCollectionViewCell.h"

@interface ZJMultiSelectCellViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *listArray;

@property (nonatomic, strong)NSMutableArray *selectedArray;

@property (nonatomic, assign) BOOL isSelectAll;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation ZJMultiSelectCellViewController
static NSString *ItemIdentifier = @"ItemIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelectAll = NO;
    _selectedArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"多选cell";
    [self.view addSubview:self.selectButton];
    [self.view addSubview:self.doneButton];
    [self.view addSubview:self.collectionView];
    [self setDataArrayAndListArray];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setDataArrayAndListArray
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"figurePhoto" ofType:@"plist"];
    self.listArray = [NSArray arrayWithContentsOfFile:path];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJMultiSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    
    NSDictionary *dict = self.listArray[indexPath.row];
    cell.imageV.image = [UIImage imageNamed:dict[@"imageName"]];
    cell.imageV.backgroundColor = randomColor;
    cell.titleL.text = dict[@"imageInfo"];
    if (self.isSelectAll) {
        cell.markV.image = [UIImage imageNamed:@"select_Icon"];
    }else{
        cell.markV.image = [UIImage imageNamed:@"unselected_icon"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJMultiSelectCollectionViewCell *cell = (ZJMultiSelectCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dict = _listArray[indexPath.row];
    if ([self.selectedArray containsObject:dict]) {
        [self.selectedArray removeObject:dict];
        cell.markV.image = [UIImage imageNamed:@"unselected_icon"];
    }else{
        [self.selectedArray addObject:dict];
        cell.markV.image = [UIImage imageNamed:@"select_Icon"];
    }
    
    if (self.selectedArray.count < self.listArray.count) {
        self.isSelectAll = NO;
        [self.selectButton setImage:[UIImage imageNamed:@"unselected_icon"] forState:UIControlStateNormal];
    }
}

//监听完成按钮的点击
- (void)clickDoneButton:(UIButton *)button{
    NSString *count = [NSString stringWithFormat:@"全选%lu条数据",(unsigned long)self.selectedArray.count];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:count preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:true completion:nil];
}

//监听全选按钮的点击
-(void)clickSelectButton:(UIButton *)button{
    if (!self.isSelectAll) {
        self.selectedArray = [NSMutableArray arrayWithArray:self.listArray];
        [button setImage:[UIImage imageNamed:@"select_Icon"] forState:UIControlStateNormal];
    }else{
        [self.selectedArray removeAllObjects];
        [button setImage:[UIImage imageNamed:@"unselected_icon"] forState:UIControlStateNormal];
    }
    self.isSelectAll = !self.isSelectAll;
    [self.collectionView reloadData];
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat selectButtonY = CGRectGetMaxY(self.selectButton.frame) + 6;
        CGRect size = CGRectMake(0, selectButtonY, SCREEN_WIDTH, SCREEN_HEIGHT - selectButtonY);
        ZJGroupingCollectionViewFlowLayout *layout = [[ZJGroupingCollectionViewFlowLayout alloc] init];
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 0);
        CGFloat cellWidth = (SCREEN_WIDTH - 20) / 3.0;
        layout.itemSize = CGSizeMake(cellWidth, 145);
        _collectionView = [[UICollectionView alloc] initWithFrame:size collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"ZJMultiSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ItemIdentifier];
    _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
//创建全选按钮
- (UIButton *)selectButton
{
    if (_selectButton == nil) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(10, 69, 80, 30);
        [_selectButton setTitle:@"  全选" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"unselected_icon"] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(clickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
//创建完成按钮
- (UIButton *)doneButton
{
    if (_doneButton == nil) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.frame = CGRectMake(SCREEN_WIDTH - 100, 69, 80, 30);
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

@end
