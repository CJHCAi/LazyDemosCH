//
//  HKReleaseViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleasesViewController.h"
#import "WaterfallColectionLayout.h"
#import "HKInitializationRespone.h"
#import "HKBaseViewModel.h"
#import "HKReleasesCollectionViewCell.h"
#import "HK_RecruitmentViewController.h"
#import "HKVideoRecordTool.h"
#import "HKPublishCommonModuleViewController.h"
#import "HKReleasePhotographyViewController.h"
#import "HKReleaseMarryViewController.h"
@interface HKReleasesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UICollectionViewLayout* layout;

@property (nonatomic, strong)HKInitializationRespone *respone;
@property (nonatomic,strong) HKVideoRecordTool *tool;   //录制的工具类
@end

@implementation HKReleasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择发布频道";
    [self.view addSubview:self.collectionView];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeChanel:) name:@"ChangeChanel" object:nil];
}

- (void)changeChanel:(NSNotification *)noti {
    
#pragma mark 添加提示 让过程平缓
    UIAlertController * alet =[UIAlertController alertControllerWithTitle:@"确定更改发布频道?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *define =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (noti.object && [noti.object isKindOfClass:[NSNumber class]]) {
            NSNumber *flagNum = (NSNumber *)noti.object;
            if ([flagNum integerValue] == 1) {
//                [self requstChoiceRecruit];
                return;
            }
        }
        
        HKReleaseVideoParam *releaseParm = [HKReleaseVideoParam shareInstance];
        ENUM_PublishType type = releaseParm.publishType;
        switch (type) {
            case ENUM_PublishTypePublic:    //发布公共模块
            {
                HKPublishCommonModuleViewController *vc = [[HKPublishCommonModuleViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case ENUM_PublishTypePhotography:   //发布摄影
            {
                HKReleasePhotographyViewController *vc = [[HKReleasePhotographyViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case ENUM_PublishTypeMarry: //发布征婚交友
            {
                HKReleaseMarryViewController *vc = [[HKReleaseMarryViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    [alet addAction:action];
    [alet addAction:define];
    [self presentViewController:alet animated:YES completion:^{
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)loadData{
    HKInitializationRespone*model =   [NSKeyedUnarchiver unarchiveObjectWithFile:KinitDataPath];
    if (model == nil) {
        [HKBaseViewModel initDataSuccess:^(BOOL isSave, HKInitializationRespone *respone) {
            if (isSave) {
                self.respone = respone;
                [self.collectionView reloadData];
            }
        }];
    }else{
        self.respone = model;
        [self.collectionView reloadData];
    }
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKReleasesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKReleasesCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.respone.data.allCategorys.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKReleasesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKReleasesCollectionViewCell class]) forIndexPath:indexPath];
    AllcategorysModel*model = self.respone.data.allCategorys[indexPath.item];
    cell.model = model;
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/4, 105);
}


// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
      AllcategorysModel*model = self.respone.data.allCategorys[indexPath.item];
    
    if ([model.name isEqualToString:@"招聘"]) {
            HK_RecruitmentViewController *vc = [[HK_RecruitmentViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([model.name isEqualToString:@"征婚交友"]) {
            [self.tool toRecordView];
            [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypeMarry;
        } else if ([model.name isEqualToString:@"摄影"]) {
            [self.tool toRecordView];
            [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypePhotography;
        }else {
            [self.tool toRecordView];
            [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypePublic;
        }
        [HKReleaseVideoParam setObject:model.categoryId key:@"categoryId"];
        [HKReleaseVideoParam setObject:HKUSERLOGINID key:@"loginUid"];
        HK_BaseAllCategorys*models = [HK_BaseAllCategorys mj_objectWithKeyValues:[model mj_keyValues]];
        [HKReleaseVideoParam shareInstance].category = models;
}
- (HKVideoRecordTool *)tool {
    if (!_tool) {
        _tool = [HKVideoRecordTool videoRecordWithDelegate:self];
    }
    return _tool;
}
@end
