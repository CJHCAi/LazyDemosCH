//
//  NewestViewController.m
//  RabbitWallpaper
//
//  Created by MacBook on 16/5/19.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "NewestViewController.h"

static const CGFloat MJDuration = 2.0;

@interface NewestViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//@property (strong, nonatomic) SDCycleScrollView *ScrollView;

@end

@implementation NewestViewController{
    UICollectionViewFlowLayout *_CollectionViewlayout;
    NSMutableArray *_dataSource;
    int _page;
    NSMutableArray *_HeaderData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.f, 30.0f)];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    UIImage *image = [UIImage imageNamed:@"title.png"];
//    [imageView setImage:image];
//    self.navigationItem.titleView = imageView;//设置导航栏的titleView为imageView
   
    _page=0;
    _dataSource = [[NSMutableArray alloc]init];
    _HeaderData = [[NSMutableArray alloc]init];
   
    [self initCollectionView];
    [self initHeaderNewWork];
    [self example21];
}

#pragma mark - mjRefreshing

- (void)example21
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 增加5条假数据
        //        _page++;
        
        [self initNewWork:_page];
        
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_header endRefreshing];
        });
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    //    // 上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 增加5条假数据
        _page++;
        [self initNewWork:_page];
        
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_footer endRefreshing];
        });
    }];
    // 默认先隐藏footer
    self.collectionView.mj_footer.hidden = YES;
}

-(void)initNewWork:(int )page{
    
    [[HttpManager sharedManager]WallPaperWithIdfa:@"" Idfv:@"" NewIdfa:@"" Openudid:@"" Page:page Type:@"0" SuccessBlock:^(AFHTTPRequestOperation *opration, id responseObject) {
        if (page==0) {
            
            [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
        }else{
            NSArray *array =[responseObject objectForKey:@"data"];
            
            [_dataSource addObjectsFromArray:array];
        }

    } failureBlock:^(AFHTTPRequestOperation *opration, NSError *error) {
        
    }];
    
}

-(void)initHeaderNewWork{
    [[HttpManager sharedManager]RundWithIdfa:@"" Idfv:@"" NewIdfa:@"" Openudid:@"" SuccessBlock:^(AFHTTPRequestOperation *opration, id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        
        _HeaderData = [responseObject objectForKey:@"list"];

        
    } failureBlock:^(AFHTTPRequestOperation *opration, NSError *error) {
        
    }];
}
#pragma mark - initCollectionView

-(void)initCollectionView{
    _CollectionViewlayout = [[UICollectionViewFlowLayout alloc]init];
    _CollectionViewlayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    _CollectionViewlayout.itemSize = CGSizeMake(ScreenWidth/3-2.5, (ScreenHeight-64)/3);
    _CollectionViewlayout.minimumLineSpacing = 1;//最小行距
    _CollectionViewlayout.minimumInteritemSpacing = 1;//最小间距

    _collectionView.collectionViewLayout =_CollectionViewlayout;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    

    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - SDCycleScrollViewDeletage
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSDictionary *dict = [_HeaderData objectAtIndex:index];
    DetailsViewController * DetailsController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    
    DetailsController.titleString =[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    DetailsController.catidString = [dict objectForKey:@"type"];
    DetailsController.isType = YES;
    [self.navigationController pushViewController:DetailsController animated:YES];
}
#pragma mark - UICollectionViewDeletage

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        HeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        

        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in _HeaderData) {
            [array addObject:[dict objectForKey:@"img"]];

        }
        NSLog(@"_HeaderData:%@",_HeaderData);

        headerView.scrollView.imageURLStringsGroup = array;
        headerView.scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        headerView.scrollView.delegate = self;
        //    self.bannerView.titlesGroup = titles;
        headerView.scrollView.currentPageDotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
        headerView.scrollView.placeholderImage = [UIImage imageNamed:@"bigImage"];
        headerView.scrollView.autoScrollTimeInterval = 2.5f;
        headerView.scrollView.currentPageDotColor = [UIColor orangeColor];
        
        
        
        reusableview = headerView;
        
    }
    
    
    return reusableview;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView.mj_footer.hidden =_dataSource.count == 0;
    
    return _dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dict;
    if (!dict) {
        dict = [_dataSource objectAtIndex:indexPath.row];
    }
    
    
    [cell TwoHomeCollectionWithData:dict];
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={1,180};
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [_dataSource objectAtIndex:indexPath.row];
    DisplayViewController * DisplayController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DisplayViewController"];
    DisplayController.bigImageUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"largeImageUrl"]];
//    [self.navigationController pushViewController:DisplayController animated:YES];
    [self presentViewController:DisplayController animated:NO completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
