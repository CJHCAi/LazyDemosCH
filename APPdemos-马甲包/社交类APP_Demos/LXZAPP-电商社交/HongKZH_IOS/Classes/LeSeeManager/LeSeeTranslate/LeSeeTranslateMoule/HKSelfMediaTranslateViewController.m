//
//  HKSelfMediaTranslateViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMediaTranslateViewController.h"
#import "HKSeleMediaCollectionViewCell.h"
#import "HKLeSeeViewModel.h"
#import "SelfMediaRespone.h"
#import "WaterFLayout.h"
@interface HKSelfMediaTranslateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property(nonatomic, assign) int pageNum;
@end

@implementation HKSelfMediaTranslateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.collectionView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer.hidden = YES;
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
-(void)setCategoryId:(NSString *)categoryId{
    _categoryId = categoryId;
    [self loadNewData];
}
-(void)setUI{
    self.title = @"自媒体筛选";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)loadNextData{
    self.pageNum++;
    [self loadData];
}
-(void)loadNewData{
    self.pageNum  = 1;
    [self loadData];
}
-(void)loadData{
    [HKLeSeeViewModel getCategorySearchAdvList:@{@"pageNumber":@(self.pageNum),@"categoryId":self.categoryId.length>0?self.categoryId:@""} success:^(SelfMediaRespone *responde) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        if (responde.responeSuc) {
            if (self.pageNum == 1) {
                [self.questionArray removeAllObjects];
            }
            [self.questionArray addObjectsFromArray:responde.data.list];
            [self.collectionView reloadData];
        }else{
            if (self.pageNum>1) {
                self.pageNum--;
            }
        }
    }];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        WaterFLayout *layout = [[WaterFLayout alloc] init];
        layout.rightMark = 5;
        layout.columnCount = 2;
        layout.minimumColumnSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKSeleMediaCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKSeleMediaCollectionViewCell"];
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
    return self.questionArray.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKSeleMediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSeleMediaCollectionViewCell class]) forIndexPath:indexPath];
     SelfMediaModelList *myVideoList = [self.questionArray objectAtIndex:indexPath.item];
    cell.model = myVideoList;
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelfMediaModelList *myVideoList = [self.questionArray objectAtIndex:indexPath.item];
    CGFloat w = (kScreenWidth-30)*0.5;
    CGFloat maxH = w*4/3;
    CGFloat minH = w*3/4.5;
    
    CGFloat h = kScreenWidth*0.5*myVideoList.coverImgHeight.floatValue/ myVideoList.coverImgWidth.floatValue;
    if (h>maxH) {
        h = maxH;
    }
    if (h<minH) {
        h = minH;
    }
    return CGSizeMake((kScreenWidth-10)*0.5, h+93);
}



// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
@end
