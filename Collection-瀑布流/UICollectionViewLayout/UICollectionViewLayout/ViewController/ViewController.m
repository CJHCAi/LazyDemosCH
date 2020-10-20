//
//  ViewController.m
//  UICollectionViewLayout
//
//  Created by lujh on 2017/5/16.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "ViewController.h"
#import "ServiceNormalCell.h"
#import "ServiceOnePicCell.h"
#import "ServiceLeftPicCell.h"
#import "ServicePicTwoTitleCell.h"
#import "HeaderCollectionViewCell.h"
#import "HeaderReusableView.h"
#import "FooterReusableView.h"
#import "CollectionViewLayout.h"
@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    // 初始化
    [self initVar];
    
    // 初始化UICollectionView
    [self setupUICollectionView];
    
}

- (void)setupNavigation {
 
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_ios7"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark -初始化

- (void)initVar {
    
    self.navigationItem.title = @"服务";
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark -初始化UICollectionView

- (void)setupUICollectionView {
    
    CollectionViewLayout *layout = [[CollectionViewLayout alloc]init];
    layout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[HeaderCollectionViewCell class] forCellWithReuseIdentifier:@"HeaderCollectionViewCell"];
    [self.collectionView registerClass:[ServiceNormalCell class] forCellWithReuseIdentifier:@"ServiceNormalCell"];
    [self.collectionView registerClass:[ServiceOnePicCell class] forCellWithReuseIdentifier:@"ServiceOnePicCell"];
    [self.collectionView registerClass:[ServicePicTwoTitleCell class] forCellWithReuseIdentifier:@"ServicePicTwoTitleCell"];
    [self.collectionView registerClass:[ServiceLeftPicCell class] forCellWithReuseIdentifier:@"ServiceLeftPicCell"];
    
    
    [self.collectionView registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ServiceHeaderReusableView"];
    [self.collectionView registerClass:[FooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ServiceFooterReusableView"];
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return section == 1 ? 7 : 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderCollectionViewCell" forIndexPath:indexPath];
        
        return cell;
    }
    
    switch (indexPath.section) {
        case 1:
            
            if (indexPath.item == 0) {
                
                ServiceOnePicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceOnePicCell" forIndexPath:indexPath];
                
                return cell;
            } else {
                ServiceNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceNormalCell" forIndexPath:indexPath];
                return cell;
            }
            break;
        case 2:
            if (indexPath.item == 0) {
                ServicePicTwoTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServicePicTwoTitleCell" forIndexPath:indexPath];
                return cell;
            } else {
                ServiceLeftPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceLeftPicCell" forIndexPath:indexPath];
                return cell;
            }
            break;

        default:
            return [UICollectionViewCell new];
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        HeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ServiceHeaderReusableView" forIndexPath:indexPath];
        headerView.imgView.image = [UIImage imageNamed:@"ser_b1"];
        return headerView;
    } else {
        FooterReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ServiceFooterReusableView" forIndexPath:indexPath];
        return footerView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    NSInteger section = indexPath.section;
    
    NSLog(@"section =%lu  row =%lu",section ,row);
    
}


#pragma mark -CollectionViewLayoutDelegate

-(CGFloat)heightOfSectionFooterForIndexPath:(NSIndexPath *)indexPath {
    return 15;
}

-(CGFloat)heightOfSectionHeaderForIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 0;
        
    }else {
    
        return 50;
    }
    
}

@end
