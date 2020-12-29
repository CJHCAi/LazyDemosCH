//
//  ListController.m
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "ListController.h"
#import "ListCell.h"
#import "DetailListController.h"
#import "ListModel.h"
#import "PrefixHeader.pch"

#define KBGColor [UIColor colorWithRed:237 / 255.0 green:239 / 255.0 blue:240 / 255.0 alpha:1]

@interface ListController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)NSMutableArray *modelArray;

@property(nonatomic, strong)NSMutableArray *listArray;

@property(nonatomic, strong)UICollectionView *collectionView;

// 记录上一次最后点击的菜系ID
@property(nonatomic, assign)NSInteger listID;
// 记录最后一次点击的cell
@property(nonatomic, assign)NSInteger cellRow;

@end

@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    // 初始化
    self.listID = 0;
    self.cellRow = 0;
    
    self.view.backgroundColor = KBGColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    // 设置边距
    layout.minimumInteritemSpacing = 20;
    CGFloat width = (KScreenWidth - 105) / 3;
    
    layout.itemSize = CGSizeMake(width, width + 30);
    
    // 创建一个集合视图
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 64, KScreenWidth - 20, KScreenHeight - 49 - 64)collectionViewLayout:layout];
    self.collectionView.backgroundColor = KBGColor;
//    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerClass:[ListCell class] forCellWithReuseIdentifier:@"classifiedCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO; // 隐藏右边滚动条
    [self.view addSubview:_collectionView];
    
    NSString *urlString = [NSString stringWithFormat:@"http://apis.juhe.cn/cook/category?key=parentid=&dtype=&key=%@", MyKey];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@", error);
        }else{
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *resultArray = dic[@"result"];
            
            self.modelArray = [NSMutableArray array];
            self.listArray = [NSMutableArray array];
            // 解析菜系
            for (int i = 0; i < 17; i++) {
                
                if (i == 6 || i == 10 || i == 12 || i == 14 || i == 15) {
                    
                }else{
                    
                    NSDictionary *dic = resultArray[i];
                    
                    [self.modelArray addObject:dic[@"name"]];
                    
                    NSArray *listArray = dic[@"list"];
                    
                    NSMutableArray *tempArray = [NSMutableArray array];
                    
                    for (int i = 0; i < listArray.count; i++) {
                        
                        NSDictionary *dic = listArray[i];
                        
                        ListModel *model = [[ListModel alloc]init];
                        
                        [model setValuesForKeysWithDictionary:dic];
                        
                        [tempArray addObject:model];
                    }
                    [self.listArray addObject:tempArray];
                }
            }
            
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }] resume];
    
}

#pragma mark --- UICollectionViewDataSource的代理方法 ---
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.modelArray != nil) {
        return self.modelArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classifiedCell" forIndexPath:indexPath];
    
    [cell setImageViewWithImageName:[NSString stringWithFormat:@"%02ld", (long)indexPath.row]];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", self.modelArray[indexPath.row]];
    
    return cell;
}

#pragma mark --- collectionView的点击方法 ---
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailListController *detailListController = [[DetailListController alloc]init];
    
    NSArray *array = self.listArray[indexPath.row];
    
    detailListController.listArray = array;
    detailListController.name = self.modelArray[indexPath.item];
    
    // 记录上一界面传过来的listID
    [detailListController takeNoteListID:^(NSInteger listID) {
        self.listID = listID;
    }];
    
    ListModel *model = nil;
    
    // 判断这次点击的cell是不是上次点击的cell
    if (self.cellRow == indexPath.row) {
        detailListController.listID = _listID;
        model = array[_listID];
    }else{
        model = array[0];
    }
    
    // 记录最后一次点击的indexPath.row
    self.cellRow = indexPath.row;
    
    detailListController.model = model;
    
    [self.navigationController pushViewController:detailListController animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

- (void)initUI {
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.945 green:0.263 blue:0.255 alpha:1.000]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

@end
