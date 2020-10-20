//
//  CollectionViewController.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/15.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "CollectionViewController.h"
#import "UIView+Sunshine.h"
#import "UICollectionView+Loading.h"
#import "CollectionViewCell.h"
#import "CollectionViewCell1.h"
#import "CollectionReusableView.h"
@interface CollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewLoadingDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.loadingDelegate = self;
    [self.collectionView startLoading];

    ///模仿网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //net-request
        [self.collectionView stopLoading];
    });
}
#pragma mark - UICollectionViewLoadingDelegate
- (NSInteger)sectionsOfloadingCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)loadingCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return 4;
}
- (UICollectionViewCell *)loadingCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CollectionViewCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell1" forIndexPath:indexPath];
         cell.sunshineViews = @[cell];
        return cell;
    }else {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
        cell.sunshineViews = @[cell.payIcon, cell.payway, cell.checkBox];
        return cell;
    }
}

- (UICollectionReusableView *)loadingCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionReusableView" forIndexPath:indexPath];
    header.sunshineViews = @[header.headerText];
    return header;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CollectionViewCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell1" forIndexPath:indexPath];
        cell.valueLabel.text = @"100元";
        return cell;
    }else {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
        cell.payway.text = @"支付渠道";
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionReusableView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            header.headerText.attributedText = [[NSAttributedString alloc] initWithString:@"余额乘车小于5元请先充值" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        }else {
            header.headerText.attributedText = [[NSAttributedString alloc] initWithString:@"选择充值方式" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        }
        return header;
    }else {
        
        return [UICollectionReusableView new];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(24, 16, 24, 16);
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(104, 58);
    }
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 64);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
