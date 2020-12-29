//
//  WallpapersViewController.m
//  WallPaper
//
//  Created by Never on 2017/2/10.
//  Copyright © 2017年 Never. All rights reserved.
//

#import "WallpapersViewController.h"

#import "ImageCategory.h"

#import "WallPaperService.h"

#import "WallpaperCell.h"

#import "WallPaper.h"

//第三方图片浏览器
#import "PhotoBroswerVC.h"

#import "PixabayService.h"

#import "PixabayModel.h"

#import "MHNetwork.h"

#import <MJRefresh.h>

static NSString * const reuseIdentifier = @"Cell";

@interface WallpapersViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) MJRefreshNormalHeader *header;
@property (nonatomic, strong) MJRefreshBackNormalFooter *footer;
@property (nonatomic, strong) NSMutableArray *wallpapers;
@end

@implementation WallpapersViewController{
    
    ImageCategory *_category;
//    NSMutableArray *_wallpapers;
    MBProgressHUD *_HUD;
    NSString *_tag;
    int index;
    int _page;
}
- (instancetype)initWithImageTag:(NSString *)tag{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    int portraitWith = MIN(screenSize.width, screenSize.height);
    int itemSize = floor((portraitWith-1)/2);
    layout.itemSize = CGSizeMake(itemSize, itemSize);
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.title = tag;
        _tag = tag;
    }
    _page = 1;
    
    return self;
}
- (instancetype)initWithImageCategory:(ImageCategory *)category{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    int portraitWith = MIN(screenSize.width, screenSize.height);
    int itemSize = floor((portraitWith-1)/2);
    layout.itemSize = CGSizeMake(itemSize, itemSize);
    if (self = [super initWithCollectionViewLayout:layout]) {
        _category = category;
        self.title = category.name;
        
    }
    _page = 1;

    return self;
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 右侧刷新按钮
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    self.navigationItem.rightBarButtonItem = refreshItem;
    // 左侧返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 22, 44);
    [backBtn setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    // 保证侧滑返回可用
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView registerClass:[WallpaperCell class] forCellWithReuseIdentifier:reuseIdentifier];
    index = 1;
    _HUD = [Tools MBProgressHUD:@"正在加载"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(requestData) object:nil];
    [queue addOperation:op];
    [self mj_pullRefresh];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_HUD removeFromSuperview];

}
#pragma mark - **********  添加MJ_Refresh  **********
- (void)mj_pullRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestPreviousPage];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestNextPage];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"上一页" forState:MJRefreshStatePulling];
    [footer setTitle:@"下一页" forState:MJRefreshStatePulling];
    self.header = header;
    self.footer = footer;
    self.collectionView.mj_header = self.header;
    self.collectionView.mj_footer = self.footer;
}
#pragma mark  **********  重新加载  **********
- (void)reloadData{
    _page = 1;
    [self.wallpapers removeAllObjects];
    [self requestData];
}
#pragma mark  **********  上一页数据  **********
- (void)requestPreviousPage{
    [self reloadData];
//    if (_page>1) {
//        _page--;
//    }else{
//        _page = 1;
//    }
//
//    [self requestData];
}
#pragma mark  **********  下一页数据  **********
- (void)requestNextPage{
    _page++;
    [self requestData];
}

#pragma mark  **********  请求数据  **********
-(void)requestData{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([_tag isEqualToString:@"Latest"]) {
        [param setObject:@"latest" forKey:@"order"];
    }else{
        [param setObject:_tag forKey:@"q"];
    }
    [param setObject:@(_page) forKey:@"page"];
    [PixabayService requestWallpapersParams:param completion:^(NSArray *Pixabaypapers, BOOL success) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self->_HUD hideAnimated:YES];
        if (success && Pixabaypapers.count != 0) {
            self->index++;
            [self.wallpapers addObjectsFromArray:Pixabaypapers];
            [self.collectionView reloadData];
            
        }else if (success && Pixabaypapers.count == 0){
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            self->_HUD = [Tools MBProgressHUDOnlyText:@"已加载全部"];
            [self->_HUD hideAnimated:YES afterDelay:2.0f];
        }else{
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            self->_HUD = [Tools MBProgressHUDOnlyText:@"加载失败"];
            [self->_HUD hideAnimated:YES afterDelay:2.0f];
        }
    }];


}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.wallpapers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WallpaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PixabayModel *model = self.wallpapers[indexPath.item];
    [cell setPixabayModel:model];
    return cell;
}


#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:indexPath.item photoModelBlock:^NSArray *{
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:self.wallpapers.count];
        
        for (NSUInteger i = 0; i < self.wallpapers.count; i++) {
            PixabayModel *model = self.wallpapers[i];
//            WallPaper *wallpaper = _wallpapers[i];
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            //此处的展示视图为XIB，已经隐藏
//            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
//            pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
            pbModel.image_HD_U = [NSString stringWithFormat:@"%@", model.largeImageURL];
            
            pbModel.image_thumbnail_U = [NSString stringWithFormat:@"%@", model.webformatURL];
            //从图片地址中截取唯一标识id,作为保存id,不会有重复
//            NSArray *strArr = [pbModel.image_HD_U componentsSeparatedByString:@"-"];
//            NSString *idStr = [strArr[1] componentsSeparatedByString:@"."][0];
            /** mid，保存图片缓存唯一标识，必须传 */
            pbModel.mid = [model.Id integerValue];
            
            WallpaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            //源frame
            UIImageView *imageV =(UIImageView *)cell;
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
    
    
}


- (NSMutableArray *)wallpapers{
    
    if (!_wallpapers) {
        _wallpapers = [NSMutableArray array];
    }
    return _wallpapers;
}

@end
