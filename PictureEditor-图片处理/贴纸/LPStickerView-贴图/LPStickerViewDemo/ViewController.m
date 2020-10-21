//
//  ViewController.m
//  LPStickerViewDemo
//
//  Created by 罗平 on 2017/6/14.
//  Copyright © 2017年 罗平. All rights reserved.
//

#import "ViewController.h"

#import "DemoStickerView.h"
#import "DemoCollectionCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *stickerViewsArray;

@property (nonatomic, weak) DemoStickerView *responseStickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stickerViewsArray = [NSMutableArray array];
    self.imagesArray = [NSMutableArray array];
    for (NSInteger i = 1; i < 8; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"DemoStickerImage%ld", i];
        [self.imagesArray addObject:[UIImage imageNamed:imageName]];
    }
    
    self.flowLayout.itemSize = CGSizeMake(100, 180);
    self.flowLayout.minimumLineSpacing = 10;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DemoCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
}


#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DemoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = self.imagesArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoStickerView *stickerView = [[DemoStickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
    stickerView.lp_transfromImage = [UIImage imageNamed:@"LPStickerView_transfrom"];
    stickerView.lp_deleteImage = [UIImage imageNamed:@"LPStickerView_delete"];
    stickerView.lp_borderColor = [UIColor greenColor];
    stickerView.lp_maxScaleRadio = 12.0;
    stickerView.lp_minScaleRadio = 0.8;
    stickerView.imageView.image = self.imagesArray[indexPath.item];
    [self.contentView addSubview:stickerView];
    stickerView.center = self.contentView.center;
    stickerView.stickerInfoChangeBlock = ^(NSDictionary *stickerInfoDict) {
      
        NSLog(@"%@", stickerInfoDict);
        
    };
    
    self.responseStickerView.lp_isTransfromResponse = NO;
    stickerView.lp_isTransfromResponse = YES;
    self.responseStickerView = stickerView;
    
    
    
}

@end
