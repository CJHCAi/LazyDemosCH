//
//  HKChangeReleaseCategoryViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKChangeReleaseCategoryViewController.h"
#import "HK_ChangeReleaseCategoryCell.h"
#import "HK_RecruitmentViewController.h"
#import "HK_CertificationProcessingViewController.h"
#import "HK_CertficationFailureViewController.h"
#import "HKVideoRecordTool.h"
#import "HKBaseViewModel.h"
@interface HKChangeReleaseCategoryViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, assign) NSInteger flag;   //1.招聘,0其他

@property (nonatomic, assign) BOOL requestDone;

@end

@implementation HKChangeReleaseCategoryViewController

#pragma mark 懒加载

static NSString *reuseIdentifier = @"HK_ChangeReleaseCategoryCell";
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kScreenWidth-46)/3, 40);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[HK_ChangeReleaseCategoryCell class] forCellWithReuseIdentifier:reuseIdentifier];
        collectionView.backgroundColor = [UIColor clearColor];
        _collectionView = collectionView;
        [self.view addSubview:_collectionView];
        _collectionView.showsVerticalScrollIndicator =NO;
        //布局
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _collectionView;
}

- (NSMutableArray  *)items {
    if (_items == nil) {
        _items = [[NSMutableArray alloc]init];
    }
    return _items;
}
#pragma mark 从数据库加载数据

- (void)getItemsFromDB {
    //从本地数据读取
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HKBaseViewModel initDataSuccess:^(BOOL isSave, HKInitializationRespone *respone) {
            for (AllcategorysModel * list  in respone.data.allCategorys) {
                [self.items addObject:list];
            }

        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
        });
    });
}

#pragma mark Nav 设置
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //设置不透明导航栏
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//设置左侧取消按钮
- (void)setLeftNavItem {
    UIButton * closeBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0,0,40,40);
    [closeBtn setImage:[UIImage imageNamed:@"close32"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    self.navigationItem.leftBarButtonItem = rightItem;
}
- (void)cancel {
    if (self.isClicle) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择发布频道";
    [self setLeftNavItem];
    self.flag = 0;
    [self getItemsFromDB];

    self.requestDone = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    DLog(@"%s",__func__);
}

#pragma mark UICollectionViewDataSource

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.items count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HK_ChangeReleaseCategoryCell *cell = (HK_ChangeReleaseCategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    AllcategorysModel *category = self.items[indexPath.item];
    cell.category = category;
    //点击头像事件跳转
//    @weakify(self);
    [cell setIconClickBlock:^(AllcategorysModel *category) {
        [HKReleaseVideoParam setObject:category.categoryId key:@"categoryId"];
        [HKReleaseVideoParam setObject:@"3" key:@"loginUid"];
        HK_BaseAllCategorys *caterM=[[HK_BaseAllCategorys alloc] init];
        caterM.imgSrc =category.imgSrc;
        caterM.categoryId =category.categoryId;
        caterM.name = category.name;
        caterM.type = category.type;
        caterM.parentId = category.parentId;
        [HKReleaseVideoParam shareInstance].category = caterM;
//        @strongify(self);
        if ([category.name isEqualToString:@"招聘"]) {
           // [self requstChoiceRecruit]; //请求招聘信息
            self.flag = 1;
        } else if ([category.name isEqualToString:@"征婚交友"]) {
            [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypeMarry;
        } else if ([category.name isEqualToString:@"摄影"]) {
            [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypePhotography;
        }else {
            [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypePublic;
        }
        if (!self.isClicle) {
             [self gotoReleaseViewController];
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectCategoty:)]) {
                [self.delegate selectCategoty:caterM];
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    return cell;
}

- (void)gotoReleaseViewController {
    for (UIViewController *vc in [self.navigationController viewControllers]) {
        if ([vc isKindOfClass:NSClassFromString(@"HK_PublishCategoryViewController")]||[vc isKindOfClass:NSClassFromString(@"HKReleasesViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeChanel" object:[NSNumber numberWithInteger:self.flag]];
}

#pragma mark UICollectionViewDelegate
// 点击 cell 跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
    
}
/*
-(void)requstChoiceRecruit
{
    if (self.requestDone) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
        [self Business_Request:BusinessRequestType_get_choiceRecruit dic:dic cache:NO];
        self.requestDone = NO;
    }
}

-(void)Business_Request_State:(BusinessRequestType)type statusCode:(NSInteger)statusCode
{
    if(BusinessRequestType_get_choiceRecruit == type)
    {
        if (RequsetStatusCodeSuccess == statusCode)
        {
            HK_ChoiceRecruitDataModel *data = [ViewModelLocator sharedModelLocator].choiceRecruitBase.data;
            NSInteger isEnterpriserecRuited =[data.isEnterpriserecRuited integerValue];
            if (isEnterpriserecRuited == 0) {   //默认类型
                //默认跳转到选择账户类型页面
                HK_RecruitmentViewController *vc = [[HK_RecruitmentViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else if (isEnterpriserecRuited == 1) {    //个人
                if ([data.isUserResume integerValue] == 0) {   //未发布
                    
                } else if([data.isUserResume integerValue] == 1) {  //已发布提示
                    
                }
            } else if (isEnterpriserecRuited == 2) {    //企业
                if (data.isAuth) {
                    if ([data.isAuth integerValue] == 2) {  //正在认证界面
                        HK_CertificationProcessingViewController *vc =[[HK_CertificationProcessingViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    } else if ([data.isAuth integerValue] == 0) {       //认证失败
                        HK_CertficationFailureViewController *vc = [[HK_CertficationFailureViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    } else if ([data.isAuth integerValue] == 1) {   //认证成功
                        if ([data.isEnterprise integerValue] == 0) {    //未发布
                            [HKReleaseVideoParam shareInstance].publishType = ENUM_PublishTypeRecruit;
                            [HKReleaseVideoParam shareInstance].userEnterpriseId = data.userEnterpriseId;
                        } else if ([data.isEnterprise integerValue] == 1) { //已发布
                            
                        }
                    }
                }
            }
        }
        self.requestDone = YES;
    }
}
*/

@end
