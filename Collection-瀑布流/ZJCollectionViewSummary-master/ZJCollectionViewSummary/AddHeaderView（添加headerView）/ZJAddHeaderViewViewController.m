//
//  ZJAddHeaderViewViewController.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/7.
//  Copyright © 2018年 James. All rights reserved.
//

/**
 项目地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git
 
 也可以到博客下看看相关介绍
 博客地址：https://www.jianshu.com/p/ff7089782d6c
 
 有什么错误或使用不便的地方可以留言或加我QQ
 
 QQ：1224740397
 */

#import "ZJAddHeaderViewViewController.h"

#import "ZJGroupingCollectionViewFlowLayout.h"
#import "ZJGroupingCollectionViewCell.h"
#import "ZJAddHeaderForCollectionReusableView.h"

@interface ZJAddHeaderViewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *listArray;

@property (nonatomic, strong) ZJAddHeaderForCollectionReusableView *headerView;
@end

@implementation ZJAddHeaderViewViewController

static NSString *ItemIdentifier = @"ItemIdentifier";

static NSString *groupingCollectionViewHeadID = @"ZJAddHeaderViewViewHeadID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分组及添加索引";
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"adidasBrand" ofType:@"plist"];
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
    ZJGroupingCollectionViewCell *cell;
    
    if (cell == nil) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    }
    NSDictionary *dict = self.listArray[indexPath.row];
    NSString *urlStr = dict[@"picpath"];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"name"]];
    cell.imageV.backgroundColor = randomColor;
    cell.nameLabel.text = dict[@"goodsprice"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGRect size = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        ZJGroupingCollectionViewFlowLayout *layout = [[ZJGroupingCollectionViewFlowLayout alloc] init];
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 120);
        _collectionView = [[UICollectionView alloc] initWithFrame:size collectionViewLayout:layout];
        [_collectionView registerClass:[ZJGroupingCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView addSubview:self.headerView];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:groupingCollectionViewHeadID];
    }
    return _collectionView;
}

- (ZJAddHeaderForCollectionReusableView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"ZJAddHeaderForCollectionReusableView" owner:nil options:nil].lastObject;
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
        _headerView.dict = @{@"title":@"adidas",@"picUrl":@"https://juedui010.oss-cn-beijing.aliyuncs.com/201608/31/1472578383MH28ZbXeA8.png",@"detail":@"adidas是来自德国的体育用品品牌，自1949年创立以来，每一年都为众多运动爱好者带来了优质的商品，今年来更是和潮流品牌推出联名单品同样也是大受好评。"};
    }
    return _headerView;
}

@end
