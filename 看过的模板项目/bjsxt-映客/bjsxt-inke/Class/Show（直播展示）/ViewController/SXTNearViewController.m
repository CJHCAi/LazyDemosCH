//
//  SXTNearViewController.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/1.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTNearViewController.h"
#import "SXTLiveHandler.h"
#import "SXTNearLiveCell.h"
#import "SXTPlayerViewController.h"

static NSString * identifier = @"SXTNearLiveCell";

#define kMargin 5
#define kItemWidth 100

@interface SXTNearViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray * datalist;

@end

@implementation SXTNearViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
    
    
}

- (void)initUI {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SXTNearLiveCell" bundle:nil] forCellWithReuseIdentifier:identifier];
}

- (void)loadData {
    
    [SXTLiveHandler executeGetNearLiveTaskWithSuccess:^(id obj) {
        
        self.datalist = obj;
        [self.collectionView reloadData];
        
    } failed:^(id obj) {
        NSLog(@"%@",obj);
    }];
}

//cell将要显示时调用
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SXTNearLiveCell * c = (SXTNearLiveCell *)cell;
    
    [c showAnimation];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = self.collectionView.width / kItemWidth;
    
    CGFloat etraWidth = (self.collectionView.width - kMargin * (count + 1)) / count;
    
    return CGSizeMake(etraWidth, etraWidth + 20);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datalist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SXTNearLiveCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.live = self.datalist[indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    SXTLive * live = self.datalist[indexPath.row];
    
    SXTPlayerViewController * playerVC = [[SXTPlayerViewController alloc] init];
    playerVC.live = live;
    [self.navigationController pushViewController:playerVC animated:YES];
    
}



@end
