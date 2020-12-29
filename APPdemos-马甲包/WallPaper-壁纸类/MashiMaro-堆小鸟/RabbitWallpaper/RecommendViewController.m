//
//  RecommendViewController.m
//  RabbitWallpaper
//
//  Created by MacBook on 16/4/29.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "RecommendViewController.h"
static const CGFloat MJDuration = 2.0;

@interface RecommendViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RecommendViewController{
    UICollectionViewFlowLayout *_CollectionViewlayout;
    NSMutableArray *_dataSource;
    NSInteger _indexPathRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.f, 30.0f)];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    UIImage *image = [UIImage imageNamed:@"title.png"];
//    [imageView setImage:image];
//    self.navigationItem.titleView = imageView;//设置导航栏的titleView为imageView
    


    
    _dataSource = [[NSMutableArray alloc]init];

//    [self initNewWork];
    [self initCollectionView];
    [self example21];

}

- (void)example21
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 增加5条假数据
        
        [self initNewWork];
        
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.mj_header endRefreshing];
        });
    }];
    [self.collectionView.mj_header beginRefreshing];
}

-(void)initNewWork{
//    [StatusTipView showStatusTip:@"请稍后..." status:StatusTipBusy];

    [[HttpManager sharedManager]recommendWithIdfa:@"" Idfv:@"" NewIdfa:@"" Openudid:@"" SuccessBlock:^(AFHTTPRequestOperation *opration, id responseObject) {
        NSLog(@"1:%@",responseObject);

        _dataSource = [responseObject objectForKey:@"list"];
        [_collectionView reloadData];
//        [StatusTipView hideStatusTipDelay:1];

    } failureBlock:^(AFHTTPRequestOperation *opration, NSError *error) {
        [StatusTipView showStatusTip:@"错误..." status:StatusTipFailure];

        NSLog(@"2:%@",opration.responseString);
    }];
    
    
}
-(void)initCollectionView{
    _CollectionViewlayout = [[UICollectionViewFlowLayout alloc]init];
    _CollectionViewlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _CollectionViewlayout.itemSize = CGSizeMake(ScreenWidth, (ScreenHeight-64)/2-50);
    _CollectionViewlayout.minimumLineSpacing = 0;//最小行距
    _CollectionViewlayout.minimumInteritemSpacing = 0;//最小间距
    
    _collectionView.collectionViewLayout =_CollectionViewlayout;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - UICollectionViewDeletage
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.collectionView.mj_footer.hidden =_dataSource.count == 0;
    
    return _dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecommendCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dict;
    if (!dict) {
        dict = [_dataSource objectAtIndex:indexPath.row];
    }
    
    [cell RecommendCollectionWithData:dict];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _indexPathRow = indexPath.row;
    
    [self performSegueWithIdentifier:@"segue.oneDetailsVC" sender:self];
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue.oneDetailsVC"]) {
        NSDictionary *dict = [_dataSource objectAtIndex:_indexPathRow];
        DetailsViewController * DetailsController = segue.destinationViewController;
        DetailsController.titleString =[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        DetailsController.catidString = [dict objectForKey:@"type"];
        DetailsController.isType = YES;
    }
    //    segue.detailsVC
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
