//
//  DetailsViewController.m
//  RabbitWallpaper
//
//  Created by MacBook on 16/4/27.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "DetailsViewController.h"

static const CGFloat MJDuration = 2.0;

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation DetailsViewController{
    UICollectionViewFlowLayout *_CollectionViewlayout;
//    NSMutableArray *_dataSource;
    NSInteger _indexPathRow;
    int _page;
    NSArray *_array;
}


#pragma mark - 数据相关

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [[NSMutableArray alloc]init];

    self.navigationItem.title = self.titleString;
    _page = 0;
    [self initCollectionView];

    if (self.isType) {
//        NSLog(@"catidString:%@",self.catidString);
        [self initNewWorkIS];
    }else{
    
        [self example21];

    }
    
    
    



}
-(void)initNewWork:(int )page{
    
     [[HttpManager sharedManager]wallpaperWithIdfa:@"" Idfv:@"" NewIdfa:@"" Openudid:@"" Page:page Catid:self.catidString SuccessBlock:^(AFHTTPRequestOperation *opration, id responseObject) {
         
//         _array =[responseObject objectForKey:@"data"];
         
         
         if (page==0) {
         
             [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
         }else{
             NSArray *array =[responseObject objectForKey:@"data"];
           
             [_dataSource addObjectsFromArray:array];
         }
         
                  
         
//         [_collectionView reloadData];
//         NSLog(@"%@",_dataSource);
     } failureBlock:^(AFHTTPRequestOperation *opration, NSError *error) {
         
     }];
    
}

-(void)initNewWorkIS{
    [StatusTipView showStatusTip:@"请稍后..." status:StatusTipBusy];

    [[HttpManager sharedManager]themeWithIdfa:@"" Idfv:@"" NewIdfa:@"" Openudid:@"" TypeId:self.catidString SuccessBlock:^(AFHTTPRequestOperation *opration, id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        _dataSource = [responseObject objectForKey:@"list"];
        [self.collectionView reloadData];
        [StatusTipView hideStatusTipDelay:1];

    } failureBlock:^(AFHTTPRequestOperation *opration, NSError *error) {
        [StatusTipView showStatusTip:@"错误..." status:StatusTipFailure];

    }];
}
-(void)initCollectionView{
    _CollectionViewlayout = [[UICollectionViewFlowLayout alloc]init];
    _CollectionViewlayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    _CollectionViewlayout.itemSize = CGSizeMake(ScreenWidth/3-2.5, (ScreenHeight-64)/3);
    _CollectionViewlayout.minimumLineSpacing = 1;//最小行距
    _CollectionViewlayout.minimumInteritemSpacing = 1;//最小间距
    
//    [_CollectionViewlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    _collectionView.pagingEnabled = YES;
    
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
    HomeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dict;
    if (!dict) {
        dict = [_dataSource objectAtIndex:indexPath.row];
    }
   
    if (_isType) {
        
        [cell TwoHomeCollectionWithData:dict];
    }else{
    
        [cell homeCollectionWithData:dict isType:1];
    }
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={1,1};
    return size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _indexPathRow = indexPath.row;

    [self performSegueWithIdentifier:@"segue.DisplayVC" sender:self];

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue.DisplayVC"]) {
        NSDictionary *dict = [_dataSource objectAtIndex:_indexPathRow];
        DisplayViewController * DisplayController = segue.destinationViewController;
        DisplayController.bigImageUrl =[NSString stringWithFormat:@"%@",[dict objectForKey:@"largeImageUrl"]];

        
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
