//
//  HK_SubMyVideoVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_SubMyVideoVc.h"
#import "HK_MyVideoTool.h"
#import "SelfMediaRespone.h"
#import "HKSelfMeidaVodeoViewController.h"
@interface HK_SubMyVideoVc ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign)int page;

@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray *dataSources;

@end

@implementation HK_SubMyVideoVc

-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources =[[NSMutableArray alloc] init];
    }
    return _dataSources;
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    self.page  =1;
    [self.view addSubview:self.collectionView];
    [self loadOrderListInfo];
   
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //创建瀑布流
        WaterFLayout *flowLayout=[[WaterFLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumColumnSpacing = 10;
        flowLayout.columnCount = 2;
        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-36-46) collectionViewLayout:flowLayout];
    
        [_collectionView registerClass:[HKMyVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([HKMyVideoCell class])];
        _collectionView.backgroundColor= UICOLOR_HEX(0xf5f5f5);
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.scrollsToTop = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator =NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //下拉刷新
         _collectionView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
            //上拉加载
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_collectionView.mj_footer setHidden: YES];
    
    }
    return _collectionView;
}

-(void)loadNewData {
    self.page =1;
    [self loadOrderListInfo];
}
-(void)loadMoreData {
    self.page ++;
    [self loadOrderListInfo];
}
-(void)loadOrderListInfo {
    
    if (_page>1) {
        [self.collectionView.mj_footer setHidden:NO];
        //不移除数据
    }else {
        [self.collectionView.mj_footer setHidden:YES];
    }

    NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
    [params setValue:HKUSERLOGINID forKey:@"loginUid"];
    [params setValue:@(self.page) forKey:@"pageNumber"];
    [params setValue:self.caterId forKey:@"categoryId"];
    
    [HK_BaseRequest buildPostRequest:[HK_MyVideoTool getAPiStrWithVideoType:self.caterType] body:params success:^(id  _Nullable responseObject) {
        [self.collectionView.mj_header endRefreshing];
        
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *mes =responseObject[@"msg"];
            if (mes.length) {
                [EasyShowTextView showText:mes];
            }
        }else {
            if (self.page==1) {
                if (self.dataSources.count) {
                    [self.dataSources removeAllObjects];
                }
                
                [self.collectionView.mj_footer setHidden:NO];
            }
            
            HKMyVideo * bigModel =[HKMyVideo mj_objectWithKeyValues:responseObject];
            
            if (bigModel.data.list.count) {
                [self.dataSources addObjectsFromArray:bigModel.data.list];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];
            }
            else
            {
                [self.collectionView.mj_footer setHidden:YES];
                if (self.page!=1) {
                    [EasyShowTextView showText:@"全部加载完毕"];
                }
            }
        }
    } failure:^(NSError * _Nullable error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [EasyShowTextView showText:@"无网络,稍后重试"];
    }];
    
}
#pragma mark UICollectionViewDataSource
//required
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSources count] > 0 ? [self.dataSources count] : 0;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HKMyVideoList *myVideoList = [self.dataSources objectAtIndex:indexPath.row];
    HKMyVideoCell *cell = [[HKMyVideoCell alloc] init];
    cell.myList = myVideoList;
    return [cell calcSelfSize];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HKMyVideoCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKMyVideoCell class]) forIndexPath:indexPath];
    
    HKMyVideoList *myVideoList = [self.dataSources objectAtIndex:indexPath.row];
    cell.myList = myVideoList;
    return cell;
}
#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   //自媒体播放
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:self.dataSources.count];
    HKMyVideoList *listD  = self.dataSources[indexPath.item];
    SelfMediaModelList*listM = [SelfMediaModelList mj_objectWithKeyValues:[listD mj_keyValues]];
    [array addObject:listM];
    HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
    vc.dataArray = array;
    vc.selectRow = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
