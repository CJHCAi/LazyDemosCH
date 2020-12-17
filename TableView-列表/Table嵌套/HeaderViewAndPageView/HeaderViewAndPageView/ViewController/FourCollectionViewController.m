//
//  FourCollectionViewController.m
//  HeaderViewAndPageView
//
//  Created by yangpan on 2016/12/19.
//  Copyright © 2016年 susu. All rights reserved.
//
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#import "FourCollectionViewController.h"
#import "RecommendedCollectionViewCell.h"
@interface FourCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *imageArrs;
@property(nonatomic,strong)NSArray *paperArrs;
@property(nonatomic,strong)NSArray *priceArrs;
@property(nonatomic,strong)NSArray *soldArrs;
@end
static NSString * const reuseIdentifier = @"Cell";
@implementation FourCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    
    _collectionView.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-104);
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.directionalLockEnabled = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecommendedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"xibCell"];
    [self.view addSubview:self.collectionView];
    
    self.imageArrs = @[@"imageshow_1",@"imageshow_2",@"imageshow_3",@"imageshow_4",@"imageshow_5",@"imageshow_6",@"imageshow_7",@"imageshow_8",@"imageshow_9",@"imageshow_10",];
    self.paperArrs = @[@" 海利公館",@" 香港丽思卡尔顿酒店",@" 香港半岛酒店",@" 港岛香格里拉大酒店",@" 香港四季酒店",@" 香港文华东方酒店",@" 香港置地文华东方酒店",@" 香港皇悦卓越酒店",@" 香港遨凯酒店",@" 香港迪士尼乐园酒店",];
    self.priceArrs = @[@" ¥2488",@" ¥1308",@" ¥2269",@" ¥1688",@" ¥1358",@" ¥1432",@" ¥3199",@" ¥1258",@" ¥2229",@" ¥4396"];
    self.soldArrs =  @[@"58",@"1023",@"973",@"213",@"233",@"458",@"873",@"112",@"102",@"364",];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

   RecommendedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xibCell" forIndexPath:indexPath];
    
    cell.imageShow.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imageArrs[indexPath.row]]];
    cell.price.text = [NSString stringWithFormat:@"%@",_priceArrs[indexPath.row]];
    cell.sold.text = [NSString stringWithFormat:@"已售出%@",_soldArrs[indexPath.row]];
    cell.name.text = [NSString stringWithFormat:@"%@",_paperArrs[indexPath.row]];

// 设置圆角
        cell.layer.masksToBounds=YES;
        cell.layer.cornerRadius=5.0;
        cell.layer.borderWidth=1.0;
        cell.layer.borderColor=[[UIColor blackColor]CGColor];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);

}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Main_Screen_Width/2-20, 150);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第%ld组第%ld行",(long)indexPath.section+1,(long)indexPath.row+1);

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
