//
//  ViewController.m
//  ScrollerDemo
//
//  Created by 栗子 on 2017/11/14.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "ViewController.h"
#import "StretchyHeaderCollectionViewLayout.h"
#import "HeaderCollectionReusableView.h"
#import "MySelfSpaceCollectionReusableView.h"
#import "RowCollectionViewCell.h"
#import "RunListOfActivitiesCustomNavView.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView    *myCollectionView;
@property(nonatomic,strong)NSArray             *nameArray;
@property(nonatomic,strong)UIImageView         *headerView;
@property(nonatomic,strong)RunListOfActivitiesCustomNavView *navView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameArray = @[@"个人资料",@"购物车",@"订单",@"个人资料",@"辅助功能",@"设置"];
    [self createUI];
     [self setNav];
    
}
- (void)createUI{
    StretchyHeaderCollectionViewLayout *stretchyLayout = [[StretchyHeaderCollectionViewLayout alloc] init];
    stretchyLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 200);
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, LFScreenW, LFScreenH) collectionViewLayout:stretchyLayout];
    _myCollectionView.alwaysBounceVertical = YES;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    _myCollectionView.dataSource = self;
    _myCollectionView.delegate = self;
    [self.view addSubview:_myCollectionView];
    _myCollectionView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    //注册头
    [_myCollectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCollectionReusableView"];
    //分割线
    [_myCollectionView registerClass:[MySelfSpaceCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MySelfSpaceCollectionReusableView"];
    //注册footer
    [_myCollectionView registerClass:[MySelfSpaceCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MySelfSpaceCollectionReusableView1"];
    [_myCollectionView registerClass:[RowCollectionViewCell class] forCellWithReuseIdentifier:@"RowCollectionViewCell"];
   
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.nameArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     RowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RowCollectionViewCell" forIndexPath:indexPath];
    cell.nameLB.text = self.nameArray[indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            HeaderCollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderCollectionReusableView" forIndexPath:indexPath];
            self.headerView = cell.headerIV;
            return cell;
        } else {
            MySelfSpaceCollectionReusableView *view= [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MySelfSpaceCollectionReusableView" forIndexPath:indexPath];
            return view;
        }
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if (indexPath.section==3) {
            MySelfSpaceCollectionReusableView *view= [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MySelfSpaceCollectionReusableView1" forIndexPath:indexPath];
            return view;
        }else{
            return nil;
        }
    }
    return nil;
}
#pragma mark - CollectionViewLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return CGSizeMake(self.view.frame.size.width,200);
    }else {
        return CGSizeMake(self.view.frame.size.width, 10);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
        return CGSizeMake(LFScreenW/3, 81);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section==3) {
        return CGSizeMake(self.view.frame.size.width,50);
    }else{
        return CGSizeMake(0,0);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(void)setNav{
    self.navView = [[RunListOfActivitiesCustomNavView alloc] initWithFrame:CGRectMake(0, 0, LFScreenW, 64)];
    self.navView.lineView.hidden = YES;
    self.navView.rightImage.hidden = YES;
    [self.navView.leftImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(23);
        make.width.height.mas_offset(37);
        make.left.mas_offset(29);
        
    }];
    self.navView.leftImage.backgroundColor = [UIColor lightGrayColor];
    self.navView.leftImage.layer.cornerRadius = 37/2;
    self.navView.leftImage.layer.masksToBounds=YES;
    self.navView.leftImage.layer.borderWidth=1;
    self.navView.leftImage.layer.borderColor=[UIColor whiteColor].CGColor;
    self.navView.leftImage.hidden = YES;
//    __weak __typeof__(self) weakSelf = self;
    self.navView.clickBlock = ^(NSString *type)
    {
       
    };
    [self.view addSubview:self.navView];
}
#pragma mark - 改变导航栏
-(void)changeNavAlphaWithConnentOffset:(CGFloat)offsetY
{
    
    if (offsetY> - 20) {
        CGFloat startChangeOffset = -20;
        CGFloat d = 56;
        CGFloat imageReduce = 1-(offsetY-startChangeOffset)/(d*3);
        //        imageReduce = imageReduce > 0.5 ? imageReduce : 0.5;
        CGFloat alpha = MIN(1,(offsetY + 20)/100);
        CGAffineTransform t = CGAffineTransformMakeTranslation(0,(1-alpha));
        self.headerView.transform = CGAffineTransformScale(t,imageReduce, imageReduce);
        if (offsetY > 50) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.navView.backgroundColor          =  [UIColor redColor];
                
            }completion:^(BOOL finished) {
            }];
            if (alpha > 0.5)
            {
                [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.navView.leftImage.hidden = NO;
                    self.headerView.hidden = YES;
                } completion:^(BOOL finished) {
                }];
            }else
            {
                self.headerView.hidden = NO;
              
            }
        }else{
            self.headerView.hidden = NO;
            self.navView.leftImage.hidden = YES;
            self.navView.backgroundColor          = [UIColor clearColor];
        }
    }
}
#pragma mark - scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _myCollectionView)
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        [self changeNavAlphaWithConnentOffset:offsetY];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
