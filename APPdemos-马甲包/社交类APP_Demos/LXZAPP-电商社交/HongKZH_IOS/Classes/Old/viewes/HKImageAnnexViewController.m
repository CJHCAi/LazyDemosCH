//
//  HKImageAnnexViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKImageAnnexViewController.h"

@interface HKImageAnnexViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation HKImageAnnexViewController

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[HKImageAnnexCollectionViewCell class] forCellWithReuseIdentifier:@"HKImageAnnexCollectionViewCell"];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        collectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
        //布局
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _collectionView;
}

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片附件";
    [self setNavItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imgs count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKImageAnnexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKImageAnnexCollectionViewCell" forIndexPath:indexPath];
    cell.imageData = [self.imgs objectAtIndex:indexPath.item];
    return cell;
}
#pragma mark UICollectionViewDelegate
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((kScreenWidth-30)/2,(kScreenWidth-30)/2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


// 点击 cell 跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

@end

@implementation HKImageAnnexCollectionViewCell

- (UIImageView *)imgView {
    if (!_imgView) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = UICOLOR_HEX(0xeeeeee);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imgView];
        _imgView = imgView;
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _imgView;
}

- (void)setImageData:(HKMyResumePreviewImgs *)imageData {
    if (!_imageData) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageData.imgSrc]];
    }
}



@end
