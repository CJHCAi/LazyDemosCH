//
//  VideoCVC.m
//  SeeFood
//
//  Created by 纪洪波 on 15/11/25.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "VideoCVC.h"
#import "PrefixHeader.pch"
#import "VideoCollectionCell.h"
#import "VideoModel.h"
#import <MJRefresh.h>

@interface VideoCVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic ,copy  ) NSString       *url;
@property (nonatomic ,copy  ) NSString       *nextPageUrl;
@property (nonatomic, retain) NSMutableArray *modelArray;
@property (nonatomic, strong) UICollectionView *collection;
@property (strong, nonatomic) UILabel *date;

@end

@implementation VideoCVC

-(void)viewDidLoad {
    [super viewDidLoad];
    self.modelArray = [NSMutableArray array];
    [self initUI];
    //  Network
    [self setNetwork];
    //  开始下拉刷新
    [self.collection.mj_header beginRefreshing];
}

- (void)initUI {
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    background.image = [UIImage imageNamed:@"LoginBack"];
    background.userInteractionEnabled = YES;
    [self.view addSubview:background];
    
    _date = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth, 50)];
    _date.text = @"Video List";
    _date.textAlignment = NSTextAlignmentCenter;
    _date.font = [UIFont systemFontOfSize:22];
    _date.textColor = [UIColor whiteColor];
    [background addSubview:_date];
    
    UIButton *changeViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeViewButton.frame = CGRectMake(0, 0, 30, 30);
    [changeViewButton addTarget:self action:@selector(changeView) forControlEvents:UIControlEventTouchUpInside];
    changeViewButton.center = CGPointMake(KScreenWidth - 20, 45);
    [changeViewButton setImage:[UIImage imageNamed:@"List"] forState:UIControlStateNormal];
    [background addSubview:changeViewButton];
    
    //  申明集合布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake((KScreenWidth - 0) / 1, (KScreenWidth - 0) / 2);
    //   collectionViewLayout控制集合视图的四个边距,以及内部行列边距
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64 - 44) collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor whiteColor];
    //  设置代理
    _collection.delegate = self;
    _collection.dataSource = self;
    [self.view addSubview:_collection];
    //  注册自定义cell
    [_collection registerClass:[VideoCollectionCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)setNetwork {
    NSString *transString = [@"开胃" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    self.url = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/videos?num=10&categoryName=%@", transString];
    //  下拉刷新
    self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getResourse:self.url];
    }];
    
    //  上拉加载
    self.collection.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getResourse:self.nextPageUrl];
    }];
}

- (void)changeView {
    [self.delegate changeView];
}

//  请求网络数据
- (void)getResourse:(NSString *)myurl {
    NSURL *url = [NSURL URLWithString:myurl];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%@",self.url);
        if (data == nil) {
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.nextPageUrl = [NSString stringWithFormat:@"%@&vc=125&u=368b8de74a9593712417679fd40adc8d79436584&v=1.8.1&f=iphone",[dic valueForKey:@"nextPageUrl"]];
        [self.modelArray addObjectsFromArray:[VideoModel jsonToModel:dic]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelectorOnMainThread:@selector(mainThreadAction) withObject:nil waitUntilDone:YES];
            // 让父类把数组传给主页的modelArray
            [self.delegate updateModelArray:self.modelArray];
        });
    }]resume];
}

- (void)mainThreadAction {
    [self.collection.mj_header endRefreshing];
    [self.collection.mj_footer endRefreshing];
    [_collection reloadData];
}

//  返回分区内行数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArray.count;
}

//  返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    VideoModel *model = self.modelArray[indexPath.row];
    [cell setValueWithModel:model];
    return cell;
}

//  点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate changeViewWithIndex:indexPath.row];
}
@end
