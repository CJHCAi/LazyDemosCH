//
//  HKLocalSelfMediaViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLocalSelfMediaViewController.h"
#import "CityHomeRespone.h"
#import "HKCityCollectionViewCell.h"
#import "HKLeSeeViewModel.h"
#import "HKLocalHeadCollectionViewCell.h"
#import "HKLeSeeViewModel.h"
#import "HKAdvertisementCityInfo.h"
#import "HKHeadVodeoView.h"
#import "HKLoadImageScrollCollectionViewCell.h"
#import "HKLocationCategoryCollectionViewCell.h"
#import "UIImageView+HKWeb.h"
#import "HKLocalParameter.h"
#import "HKSelfMeidaVodeoViewController.h"
#import "SelfMediaRespone.h"
#import "WHFullAliyunVideoView.h"
@interface HKLocalSelfMediaViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,HKLocalHeadCollectionViewCellDelegate,HKLocationCategoryCollectionViewCellDelegate>
@property(nonatomic,strong)UICollectionView* collectionView;
@property (nonatomic,assign) int pageNum;
@property (nonatomic, strong)HKAdvertisementCityInfo *cityInfo;
@property (nonatomic, strong)WHFullAliyunVideoView *videoView;
@property (nonatomic,weak) HKLocalHeadCollectionViewCell *palyCell;
@property (nonatomic, strong)NSMutableArray *parameterArray;
@property (nonatomic, strong)HKLocalParameter *allP;

@property(nonatomic, assign) NSInteger index;
@end

@implementation HKLocalSelfMediaViewController


#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =self.cityName;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNext)];
    self.collectionView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer.hidden = YES;
    [self loadNewData];
}
-(void)loadNewData{
    HKLocalParameter*p = [self getParameter];
    p.pageNumber = 1;
    [self loadHeadData];
    [self loadData];
}
-(void)loadItemDataNew{
    
  HKLocalParameter*p = [self getParameter];
    p.pageNumber = 1;
    [self loadData];
}
-(void)loadNext{
    HKLocalParameter*p =   [self getParameter];
    p.pageNumber++;
    [self loadData];
}
-(void)loadHeadData{

    [HKLeSeeViewModel getCityInfoById:@{@"cityId":self.cityId} success:^(HKAdvertisementCityInfo *responde) {
        [self.collectionView.mj_footer endRefreshing];
        if (responde.responeSuc) {
            self.cityInfo = responde;
            [self.parameterArray removeAllObjects];
            [self.parameterArray addObject:self.allP];
            
            for (AdvertisementsCategorys*model in responde.data.categorys) {
                HKLocalParameter *p = [[HKLocalParameter alloc]init];
                p.pageNumber = 1;
                p.categoryId = model.categoryId;
                [self.parameterArray addObject:p];
            }
           
        }
         [self.collectionView reloadData];
    }];
}
-(void)loadData{
    HKLocalParameter*p = [self getParameter];
    [HKLeSeeViewModel getCategoryCityAdvList:@{@"categoryId":p.categoryId,@"cityId":self.cityId,@"pageNumber":@(p.pageNumber)} success:^(CityHomeRespone *responde) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        if (responde.responeSuc) {
            if (p.pageNumber == 1) {
                [p.questionArray removeAllObjects];
            }
            [p.questionArray addObjectsFromArray:responde.data.list];
            [self.collectionView reloadData];
        }else{
            if (p.pageNumber > 1) {
                p.pageNumber -- ;
            }
        }
    }];
}
-(void)categoryWithTag:(NSInteger)tag{
    self.index = tag;
    HKLocalParameter*p =  [self getParameter];
    if (p.questionArray.count>0) {
        [self.collectionView reloadData];
    }else{
        [self loadData];
    }
    
}
-(void)palyWithIndexPath:(NSIndexPath *)indexPath{
    if (self.palyCell.indexPath == indexPath) {
        return;
    }
    self.palyCell.staue = HKPalyStaue_close;
    [self.videoView reset];
     HKLocalHeadCollectionViewCell*cell = (HKLocalHeadCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.item == 0) {
         [self.videoView playWithVid:self.cityInfo.data.officialVideo playView:cell.iconView];
    }else{
        [self.videoView playWithVid:self.cityInfo.data.traditionalVideo playView:cell.iconView];
    }
   
    self.palyCell = cell;
    cell.staue = HKPalyStaue_play;
}
#pragma mark collectionViewDelegate-collectionViewDatesource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
         HKLocalParameter*p = [self getParameter];
        CityHomeModel*model = p.questionArray[indexPath.item];
        SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
        listM.title = @"";
        listM.coverImgSrc = model.coverImgSrc;
        //    listM.
        listM.praiseCount = model.praiseCount;
        listM.rewardCount = model.rewardCount;
        listM.isCity = YES;
        listM.ID = model.cityAdvId.length>0?model.cityAdvId:@"";
        HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
        vc.dataArray = [NSMutableArray arrayWithObject:listM];
        vc.selectRow = 0;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
//    [self.navigationController pushViewController:[[HK_LeSeeAddProductDescVC alloc]init] animated:YES] ;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        HKLocalHeadCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKLocalHeadCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
        if (indexPath.item == 0) {
            if (self.cityInfo) {
                [cell.iconView hk_sd_setImageWithURL:self.cityInfo.data.officialCoverImgSrc placeholderImage:kPlaceholderImage];
            }
            cell.title.text = @"官方视频";
        }else{
            if (self.cityInfo) {
                [cell.iconView hk_sd_setImageWithURL:self.cityInfo.data.traditionalCoverImgSrc placeholderImage:kPlaceholderImage];
            }
            cell.title.text = @"传统文化";
        }
        return cell;
    }else if (indexPath.section == 0){
        HKLoadImageScrollCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"HKLoadImageScrollCollectionViewCell" forIndexPath:indexPath];
        if (self.cityInfo) {
            [cell.iconView hk_sd_setImageWithURL:self.cityInfo.data.imgSrc placeholderImage:kPlaceholderImage];
        
    }
        return cell;
    }else if (indexPath.section == 2){
        HKLocationCategoryCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKLocationCategoryCollectionViewCell" forIndexPath:indexPath];
        cell.dataArray = self.cityInfo.data.categorys;
        cell.delegate = self;
        cell.selectIndex = self.index;
        return cell;
    }
    HKCityCollectionViewCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"city" forIndexPath:indexPath];
    HKLocalParameter*p = [self getParameter];
    CityHomeModel*model = p.questionArray[indexPath.item];
    cell.model = model;
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if(section == 2){
        return 1;
    }
    HKLocalParameter*p = [self getParameter];
    return p.questionArray.count;;
}

#pragma mark - 代理方法 Delegate Methods


// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return CGSizeMake(kScreenWidth, 210);
    }else if (indexPath.section == 0){
        return CGSizeMake(kScreenWidth, 160);;
    }else if (indexPath.section == 2){
        return CGSizeMake(kScreenWidth, 110);;
    }
     HKLocalParameter*p = [self getParameter];
    CityHomeModel*model = p.questionArray[indexPath.item];
    return CGSizeMake((kScreenWidth-10)/2, kScreenWidth*0.5*model.coverImgHeight.intValue/ model.coverImgWidth.intValue+103);
}






#pragma mark getter-setter
-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerNib:[UINib nibWithNibName:@"HKCityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"city"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKLocalHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKLocalHeadCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKLoadImageScrollCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKLoadImageScrollCollectionViewCell"];
         [_collectionView registerNib:[UINib nibWithNibName:@"HKLocationCategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKLocationCategoryCollectionViewCell"];
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _collectionView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
}
-(NSMutableArray *)parameterArray{
    if (!_parameterArray) {
        _parameterArray = [NSMutableArray array];
        [_parameterArray addObject:self.allP];
    }
    return _parameterArray;
}
-(HKLocalParameter *)allP{
    if (!_allP) {
        _allP = [[HKLocalParameter alloc]init];
        _allP.pageNumber = 1;
        _allP.categoryId = @"";
    }
    return _allP;
}
-(HKLocalParameter*)getParameter{
    return self.parameterArray[self.index];
}
-(WHFullAliyunVideoView *)videoView{
    if (!_videoView) {
        _videoView = [[WHFullAliyunVideoView alloc]init];
        _videoView.type = 1;
    }
    return _videoView;
}
@end
