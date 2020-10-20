//
//  ZJWaterLayoutViewController.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/12.
//  Copyright © 2018年 James. All rights reserved.
//

/**
 项目地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git
 
 也可以到博客下看看相关介绍
 博客地址：https://www.jianshu.com/p/ff7089782d6c
 
 有什么错误或使用不便的地方可以留言或加我QQ
 
 QQ：1224740397
 */

#import "ZJWaterLayoutViewController.h"
#import "ZJWaterLayout.h"
#import "ZJWaterLayoutCollectionViewCell.h"

@interface ZJWaterLayoutViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,ZJWaterLayoutDelegate>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *images;
/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** ZJWaterLayout */
@property (nonatomic, strong) ZJWaterLayout *layout;

@end

@implementation ZJWaterLayoutViewController

static NSString *ItemIdentifier = @"ItemIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"流水布局(水平与竖直)";
    [self.view addSubview:self.collectionView];
    [self setRightItem];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJWaterLayoutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.item]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleStr = [NSString stringWithFormat:@"点击了第%ld",(long)indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:titleStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark - ZJWaterLayoutDelegate
/** 几列 */
-(NSInteger)waterFlowLayoutColumnCount:(ZJWaterLayout *)layout
{
    return 3;
}

-(CGFloat)waterFlowLayout:(ZJWaterLayout *)layout hieghtForItemAtIndex:(NSUInteger)index itemwidth:(CGFloat)itemwidth
{
    return (arc4random() % 101) + 100;//(100--200随机数)
}
/** 边距 */
- (UIEdgeInsets)waterFlowLayoutEdgeInsets:(ZJWaterLayout *)layout
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
       
        ZJWaterLayout *layout = [[ZJWaterLayout alloc] init];
        layout.delegate = self;
        layout.waterDirection = ZJWaterHorizontal;
        self.layout = layout;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_HEIGHT - 74) collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ZJWaterLayoutCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
       
    }
    return _collectionView;
}

- (NSMutableArray *)images
{
    if(_images == nil)
    {
        _images = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 30; i++) {
            
            [_images addObject:[NSString stringWithFormat:@"%zd.jpg", i]];
        }
    }
    return _images;
}

#pragma mark 设置右侧item
- (void)setRightItem
{
    UIButton *rightItem  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(0, 0, 50, 30);
    [rightItem setTitle:@"切换布局" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(clickRightItemBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItemBar = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    [self.navigationItem setRightBarButtonItem:rightItemBar];
}

#pragma mark - rightItem的监听方法
- (void)clickRightItemBar
{
    if (self.layout.waterDirection == ZJWaterHorizontal)
    {
        self.layout.waterDirection = ZJWaterVertical;
        [self.collectionView setCollectionViewLayout:self.layout animated:YES];
    } else {
        self.layout.waterDirection = ZJWaterHorizontal;
        [self.collectionView setCollectionViewLayout:self.layout animated:YES];
    }
    [self.collectionView reloadData];
}

@end
