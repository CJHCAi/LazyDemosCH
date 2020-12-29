//
//  HKLeSeeVideoMyGoodsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeSeeVideoMyGoodsViewController.h"
#import "HKHKShoppingActivityItem.h"
#import "GetMediaAdvAdvByIdRespone.h"
@interface HKLeSeeVideoMyGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HKLeSeeVideoMyGoodsViewController
- (instancetype)init
{
    self = [super init];
    self = [[HKLeSeeVideoMyGoodsViewController alloc]initWithNibName:@"HKLeSeeVideoMyGoodsViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"HKHKShoppingActivityItem" bundle:nil] forCellWithReuseIdentifier:@"HKHKShoppingActivityItem"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
#pragma mark - 代理方法 Delegate Methods

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKHKShoppingActivityItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHKShoppingActivityItem class]) forIndexPath:indexPath];
    GetMediaAdvAdvByIdProducts*products = self.dataArray[indexPath.item];
    cell.videoProduct = products;
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(115,165);
}


// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    [self dismissViewControllerAnimated:YES completion:^{
        GetMediaAdvAdvByIdProducts*products = self.dataArray[indexPath.item];
        if ([self.delegate respondsToSelector:@selector(gotoGoodsInfo:)]) {
            [self.delegate gotoGoodsInfo:products];
        }
    }];
}
- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
