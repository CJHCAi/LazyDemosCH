//
//  HKToolTranslateViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKToolTranslateViewController.h"
#import "HKToolTranslateViewCell.h"
#import "GetMediaAdvAdvByIdRespone.h"
@interface HKToolTranslateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation HKToolTranslateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)setUI{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKToolTranslateViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKToolTranslateViewCell"];
        _collectionView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.cityResponse.data.products.count) {
        return self.cityResponse.data.products.count;
    }else if(self.responde.data.products.count) {
          return self.responde.data.products.count;
    }
    return 0;
}
// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKToolTranslateViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKToolTranslateViewCell class]) forIndexPath:indexPath];
    if (self.cityResponse.data.products.count) {
         cell.model = self.cityResponse.data.products[indexPath.item];
    }else if(self.responde.data.products.count) {
         cell.model = self.responde.data.products[indexPath.item];
    }
    return cell;
}
// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-40)/3+10, (kScreenWidth-40)/3+10);
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
}
-(void)setResponde:(GetMediaAdvAdvByIdRespone *)responde{
    _responde = responde;
    [self.collectionView reloadData];
}

-(void)setCityResponse:(HKCityTravelsRespone *)cityResponse {
    _cityResponse = cityResponse;
    [self.collectionView reloadData];
}
@end
