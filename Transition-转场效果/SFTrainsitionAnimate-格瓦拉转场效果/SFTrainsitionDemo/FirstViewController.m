//
//  FirstViewController.m
//  SFTrainsitionDemo
//
//  Created by sfgod on 16/5/13.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import "FirstViewController.h"
#import "SFTrainsitionAnimate.h"
#import "FirstCell.h"
#import "SecondViewController.h"
#import "UIViewController+SFTrainsitionExtension.h"

@interface FirstViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) SFTrainsitionAnimate    *animate;
@property (strong, nonatomic) UIScrollView     *scrollView;

@end

@implementation FirstViewController



#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self Adds];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.collectionView];
}

#pragma mark -- Data
- (void)initData{
    
    self.animate = [[SFTrainsitionAnimate alloc] init];
    
}

#pragma mark -- UI
- (void)initUI{
    
}
#pragma mark -- event response


- (void)buttonClick:(UIButton *)sender{
    
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return self.animate;
    }else{
        
        return nil;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    cell.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FirstCell *cell = (FirstCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    self.sf_targetView = cell;
    SecondViewController *secVC = [[SecondViewController alloc] init];
    secVC.v_coler = cell.backgroundColor;
    [self.navigationController pushViewController:secVC animated:YES];
}

#pragma mark -- getters and setters

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(SCREEN_WIDTH/3-20, (SCREEN_WIDTH/3-20)*1.3)];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [layout setMinimumInteritemSpacing:20];
        [layout setMinimumLineSpacing:20];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        [_collectionView registerClass:[FirstCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _collectionView;
}

@end
