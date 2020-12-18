//
//  ZJWCollectionView.m
//  navigationBarAnimation
//
//  Created by yangpan on 2016/12/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ZJWCollectionView.h"
#import "MyCollectionViewCell.h"
#define KScreenWith [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
static CGFloat itmsHeight = 60;
@implementation ZJWCollectionView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
-(void)createCollectionWithItms:(NSInteger)itms{
  
    self.itms = itms;
     self.imageArrays = @[@"imageshow_1",@"imageshow_2",@"imageshow_3",@"imageshow_4",@"imageshow_5",@"imageshow_6"];
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    //  设置collectionView滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.colleciont = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, KScreenWith, self.itms/3 * itmsHeight+30) collectionViewLayout:flowLayout];
    self.colleciont.backgroundColor = [UIColor clearColor];
    self.colleciont.delegate = self;
    self.colleciont.dataSource = self;
    self.colleciont.scrollEnabled = NO;
    self.colleciont.showsVerticalScrollIndicator = NO;
    [self.colleciont setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //  注册cell
    [self.colleciont registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    
    [self addSubview: self.colleciont];

}

#pragma mark --********collectionViewDelegete
//返回section个数(多少组)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个section的item个数(多少行)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itms;
}
//定义cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    cell.babyImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArrays[indexPath.row]]];
    // 设置圆角
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=5.0;
    cell.layer.borderWidth=1.0;
    cell.layer.borderColor=[[UIColor blackColor]CGColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 60);
}
//设置section的高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
//}
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
//选择国内外
-(void)destinationClick:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            {
                NSLog(@"国内");
            }
            break;
        case 2:
            {
                NSLog(@"国外");
            }
            break;
            
        default:
            break;
    }
    
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _itmsBlock(self,indexPath.row);
    
    NSLog(@"第%ld组第%ld行",(long)indexPath.section+1,(long)indexPath.row+1);
}

@end
