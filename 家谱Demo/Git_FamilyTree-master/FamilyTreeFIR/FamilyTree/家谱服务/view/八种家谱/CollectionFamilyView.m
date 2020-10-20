//
//  CollectionFamilyView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CollectionFamilyView.h"
#import "CustomCollectionViewCell.h"

#define Cell_size 90

#define GapOfCell 10

static NSString *const kReusableCellIdentifier = @"cellIdentifier";

@interface CollectionFamilyView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray *_imageNames;
    NSArray *_cellNames;
}

@property (nonatomic,strong) UICollectionView *collectionView; /*几何视图*/
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout; /**< 流式布局 */


@end

@implementation CollectionFamilyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}
#pragma mark *** 初始化数据 ***
-(void)initData{
    _imageNames = @[@"fuwu_zqhz",@"fuwu_zxjs",@"fuwu_zzfw",@"fuwu_jnxp",@"fuwu_zjtj",@"fuwu_fsjd",@"fuwu_sjxq",@"fuwu_mjym"];
    _cellNames = @[@"宗亲互助",@"在线祭祀",@"增值服务",@"教你修谱",@"专家推荐",@"风水鉴定",@"赏金寻亲",@"募捐圆梦"];
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self addSubview:self.collectionView];

}
#pragma mark *** collectionViewDataScource ***

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageNames.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReusableCellIdentifier forIndexPath:indexPath];
    cell.cusImage.image = MImage(_imageNames[indexPath.row]);
    cell.cusLabel.text = _cellNames[indexPath.row];
    return cell;
}
#pragma mark *** collectionViewDelegate ***
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(CollevtionFamily:didSelectedItemAtIndexPath:)]) {
        [_delegate CollevtionFamily:self didSelectedItemAtIndexPath:indexPath];
    }
    
}

#pragma mark *** getters ***

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, SelfView_width, self.bounds.size.height) collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:kReusableCellIdentifier];
        
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(40, 60);
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = (SelfView_width-4*_flowLayout.itemSize.width)/4;
        
    }
    return _flowLayout;
}
@end
