//
//  LJObjectsViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJObjectsViewController.h"
#import "AFNetworking.h"
#import "AFOnoResponseSerializer.h"
#import <Ono.h>
#import "LJComCell.h"
#import "LJCollectionObjectModel.h"
#import <MJRefresh.h>
#import "MBProgressHUDManager.h"
#import "LJSeeViewController.h"
#import "LBPhotoBrowserManager.h"


@interface LJObjectsViewController () <UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *_dataArray;
    NSInteger _page;
    AFHTTPRequestOperationManager *_manager;
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *flowLayout;
}

@property (nonatomic, strong) MBProgressHUDManager *hudManager;

@end

@implementation LJObjectsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_isFromClassify) {
        self.navigationController.navigationBar.translucent = YES;
    }
}

- (MBProgressHUDManager *)hudManager {
    if (!_hudManager) {
        _hudManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    }
    return _hudManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =self.titleN;
    [self loadData];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 创建UI
- (void) setupUI {
    if (_isFromClassify) {
        self.navigationController.navigationBar.translucent = NO;
    }
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _isFromClassify?self.view.frame.size.height:self.view.frame.size.height - 104) collectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake((flowLayout.collectionView.frame.size.width - 5) / 2 , self.view.frame.size.width / 2);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;

    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"LJComCell" bundle:nil] forCellWithReuseIdentifier:@"COMCELL"];
    [self.view addSubview:_collectionView];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self requestDataWithPage:_page];
    }];
    footer.automaticallyRefresh = NO;
    _collectionView.footer = footer;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [_dataArray removeAllObjects];
        [self requestDataWithPage:_page];
    }];
    _collectionView.header = header;
}

#pragma mark 数据相关
- (void)loadData {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    _page = 0;
    _manager = [AFHTTPRequestOperationManager manager];
    
    _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    _manager.responseSerializer = [AFHTTPResponseSerializer  serializer];
   
    [self requestDataWithPage:_page];
}

- (void) requestDataWithPage:(NSInteger)page {
    NSString *newUrl = [NSString stringWithFormat:self.urlStr,self.viewControllerType,_page];
    [self.hudManager showMessage:@"正在加载"];
    [_manager GET:_isFromSearch?self.urlStr:newUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:responseObject error:nil];
        
        NSArray * imageArray = [document.rootElement childrenWithTag:@"img"];
        
        for (ONOXMLElement * imageElement in imageArray) {
            NSDictionary * attrs = imageElement.attributes;
            LJCollectionObjectModel *model = [[LJCollectionObjectModel alloc] init];
            [model setValuesForKeysWithDictionary:attrs];
            model.baseurl = document.rootElement.attributes[@"baseurl"];
         
            [_dataArray addObject:model];
        }
        [_collectionView reloadData];
        [_collectionView.mj_footer endRefreshing];
        [_collectionView.mj_header endRefreshing];
        [self.hudManager showSuccessWithMessage:@"加载成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_collectionView.footer.state == MJRefreshStateRefreshing) {
            _page --;
            if (_page < 0) {
                _page = 0;
            }
            [_collectionView.mj_footer endRefreshing];
        }
        [_collectionView.mj_header endRefreshing];
        [self.hudManager showErrorWithMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}

#pragma mark UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJComCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"COMCELL" forIndexPath:indexPath];
    
    if (_dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i < _dataArray.count; i ++) {
        LJCollectionObjectModel *model = _dataArray[i];
            [tempArray addObject:[NSString stringWithFormat:@"%@%@",model.baseurl,model.thumblink]];
    }
    
    DefineWeakSelf;
    [[LBPhotoBrowserManager defaultManager] showImageWithURLArray:tempArray fromCollectionView:collectionView selectedIndex:(int)indexPath.row unwantedUrls:nil];
    [[[LBPhotoBrowserManager defaultManager] addLongPressShowTitles:@[@"保存图片至相册",@"预览",@"取消"]] addTitleClickCallbackBlock:^(UIImage *image, NSIndexPath *indexPath, NSString *title) {
        
        switch (indexPath.row) {
            case 0:
            {
                [weakSelf collectPictrue:image];
            }
                break;
            case 1:
            {
                LJSeeViewController *seeVC = [[LJSeeViewController alloc] init];
                seeVC.image = image;
                [self presentViewController:seeVC animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
        
    }].lowGifMemory = NO;

}

- (void)collectPictrue:(UIImage *)imageView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已保存到相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImageWriteToSavedPhotosAlbum(imageView, nil, nil, nil);
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
