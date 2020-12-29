//
//  LikeVC.m
//  SeeFood
//
//  Created by 纪洪波 on 15/11/27.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "LikeVC.h"
#import "VideoCollectionCell.h"
#import "VideoModel.h"
#import "PrefixHeader.pch"
#import "CoreDataManager.h"
#import "AVPlayerViewController.h"
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>

@interface LikeVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, retain) NSMutableArray *modelArray;
@end

@implementation LikeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationItem setTitle:@"Favotite"];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    delete.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *deleteBar = [[UIBarButtonItem alloc]initWithCustomView:delete];
    self.navigationItem.rightBarButtonItem = deleteBar;
    
    //  申明集合布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake((KScreenWidth - 0) / 1, (KScreenWidth - 0) / 2);
    //   collectionViewLayout控制集合视图的四个边距,以及内部行列边距
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor whiteColor];
    //  设置代理
    _collection.delegate = self;
    _collection.dataSource = self;
    [self.view addSubview:_collection];
    //  注册自定义cell
    [_collection registerClass:[VideoCollectionCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)initData {
    _modelArray = [NSMutableArray array];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collection"];
    BmobUser *user = [BmobUser getCurrentUser];
    [bquery whereKey:@"username" equalTo:user.username];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *video in array) {
            VideoModel *model = [[VideoModel alloc]init];
            model.coverBlurred = [video objectForKey:@"coverBlurred"];
            model.coverForDetail = [video objectForKey:@"coverForDetail"];
            model.date = [[video objectForKey:@"date"] doubleValue];
            model.id = [[video objectForKey:@"id"] integerValue];
            model.playUrl = [video objectForKey:@"playUrl"];
            model.shareCount = [[video objectForKey:@"shareCount"] integerValue];
            model.title = [video objectForKey:@"title"];
            [_modelArray addObject:model];
        }
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    }];
}

- (void)reload {
    [_collection reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    VideoModel *model = _modelArray[indexPath.row];
    AVPlayerViewController *player = [[AVPlayerViewController alloc]init];
    player.url = [NSURL URLWithString:model.playUrl];
    
    //  旋转
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.isRotation = YES;
    [self presentViewController:player animated:YES completion:nil];
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
