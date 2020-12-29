//
//  HKReleaseViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReleaseViewController.h"
#import "HKUserProductViewController.h"
#import "HKChangeReleaseCategoryViewController.h"
#import "HKChinaModel.h"
#import "HKProvinceModel.h"
#import "HKCityModel.h"
#import "UrlConst.h"
#import "HK_BaseRequest.h"
#import "HKReleasesViewController.h"
#import "HK_UserProductList.h"
#import "HKBaseViewModel.h"
#import "HKAliyunOSSUploadVideoTool.h"
#import "HK_NetWork.h"
#import "HKIconAndTitleCenterView.h"
@interface HKReleaseViewController ()
@property (nonatomic, strong)HKIconAndTitleCenterView *doneButton;
@end

@implementation HKReleaseViewController

- (void)dealloc {
    DLog(@"%s",__func__);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sx_disableInteractivePop = YES;    //禁用全屏手势
    }
    return self;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        //自动估算行高
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 130;
        [self.view addSubview:tableView];
        _tableView = tableView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
             if (self.hasNoBottomBar) {
                 make.bottom.equalTo(self.view);
            }else {
                 make.bottom.equalTo(self.view).offset(-49);
            }

        }];
    }
    return _tableView;
}

- (HKReleaseVideoSaveDraftDao *)saveDraftDao {
    if (!_saveDraftDao) {
        _saveDraftDao = [[HKReleaseVideoSaveDraftDao alloc] init];
    }
    return _saveDraftDao;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
    }
    return _locationManager;
}

- (HKReleaseLocationData *)locationData {
    if (!_locationData) {
        _locationData = [[HKReleaseLocationData alloc] init];
        _locationData.location = @"定位中";
        _locationData.show = NO;
    }
    return _locationData;
}

- (NSMutableArray *)selectedItems {
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    return _selectedItems;
}


#pragma mark 设置 nav
- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"存草稿" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont fontWithName:PingFangSCRegular size:15];
    attrs[NSForegroundColorAttributeName] = RGB(102,102,102);
    [rightItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.setMoney = NO;
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.setMoney) {
         [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
     }
       [SVProgressHUD dismiss];
}
//左侧取消按钮
- (void)cancel {
    if (self.source == 1) {
        [HKReleaseVideoParam clearParam];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIViewController *popVc;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"HK_PublishCategoryViewController")]||[vc isKindOfClass:[HKReleasesViewController class]]) {
            popVc = vc;
            break;
        }
    }
    if (popVc) {
        [self.navigationController popToViewController:popVc animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

//导航右侧按钮点击
- (void)nextStep {
    DLog(@"存草稿");
    [self.view endEditing:YES];
    //保存title和remark
    if (self.titleContentCell.title) {
        [HKReleaseVideoParam setObject:self.titleContentCell.title key:@"title"];
    }
    if (self.titleContentCell.remarks) {
        [HKReleaseVideoParam setObject:self.titleContentCell.remarks key:@"remarks"];
    }
    //保存商品
    [self saveProducts];
    [HKReleaseVideoParam shareInstance].products = self.selectedItems;
    //保存屏幕宽度
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenWidth] key:@"width"];
    //保存屏幕高度
    [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",kScreenHeight] key:@"high"];
    
    [HKReleaseVideoParam shareInstance].boothCount = self.boothCount;
    
    //保存数据到数据库
    HKReleaseVideoSaveDraft *draft = [HKReleaseVideoSaveDraftAdapter convertParam2SaveDraft];
    HKReleaseVideoSaveDraftDao *dao = [HKReleaseVideoSaveDraftDao saveDraftDao];
    BOOL success = [dao addDraft:draft];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    if (success) {
        [SVProgressHUD showSuccessWithStatus:@"保存草稿成功"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布视频";
    self.view.backgroundColor = RGB(241, 241, 241);
    [self setNavItem];
    [self setUpUI];
    self.boothCount = 1;
    if (self.source == 1) {
        [self getDataFromDB];
    }
}

- (void)getDataFromDB {
    if (self.saveDraft == nil) {
        return;
    }
    [HKReleaseVideoSaveDraftAdapter convertDraft2Param:self.saveDraft];
    //商品相关
    self.boothCount = [HKReleaseVideoParam shareInstance].boothCount;
    self.selectedItems = [HKReleaseVideoParam shareInstance].products;
    [self.tableView reloadData];
}


- (void)setUpUI {
   
    [self.view addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.width.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
}

- (void)buttonClick {
    DLog(@"发布");
}

- (void)uploadSuccess {
    if (self.source == 1) {
        [self.saveDraftDao delDraft:self.saveDraft];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//请求展位
- (void)requestBuyBooth {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:HKUSERLOGINID forKey:@"loginUid"];
    
    [HK_BaseRequest buildPostRequest:get_buyBooth_releaseVideo body:dict success:^(id  _Nullable responseObject) {
        NSString *code = [responseObject objectForKey:@"code"];
        if (code && [code integerValue] == 1) {
            //失败
            [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
        } else if(code && [code integerValue] == 0){
            //成功
            self.boothCount++;
            //刷新商品cell
            [self.tableView reloadRowsAtIndexPaths:@[self.productCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(NSError * _Nullable error) {
        [SVProgressHUD showInfoWithStatus:@"网络错误"];
    }];
   
}

//保存商品
- (void)saveProducts {
    //保存商品id
    if ([self.selectedItems count] > 0) {
        NSMutableArray *productIds = [NSMutableArray array];
        for (HKUserProduct *product in self.selectedItems) {
            [productIds addObject:product.productId];
        }
        [HKReleaseVideoParam setObject:productIds key:@"products"];
    }
}

#pragma mark 定位
- (void)requestLocation {
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                [SVProgressHUD showInfoWithStatus:@"定位失败"];
                return;
            }
        }
        
        DLog(@"latitude:%f,longitude:%f", location.coordinate.latitude,location.coordinate.longitude);
        //保存经纬度
        [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] key:@"latitude"];
        [HKReleaseVideoParam setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] key:@"longitude"];
        
        
        
        if (regeocode)
        {
            DLog(@"reGeocode:省:%@,市:%@", regeocode.province,regeocode.city);
            [HKBaseViewModel initCityDataSuccess:^(BOOL isSave, HKChinaModel *respone) {
            
               HKChinaModel*chinaM = [NSKeyedUnarchiver unarchiveObjectWithFile:KCityListData];
            self.locationData.location = regeocode.city;
                if (self.locationCellIndexPath) {
                     [self.tableView reloadRowsAtIndexPaths:@[self.locationCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }else {
                    [self.tableView reloadData];
                }
            if (regeocode.city) {//获得proviceId
                //保存省id
              
                for (HKProvinceModel *provice in chinaM.provinces) {
                    if ([provice.name isEqualToString:regeocode.province]) {
                        [HKReleaseVideoParam setObject:provice.code key:@"provinceId"];
                        for (HKCityModel *city in provice.citys) {
                            if ([city.name isEqualToString:regeocode.city]) {
                                [HKReleaseVideoParam setObject:city.code key:@"cityId"];
                                break;
                            }
                        }
                        break;
                    }
                }
            }
                }];
        }
             
             
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark cells
//更改频道cell
- (HKChooseChannelTableViewCell *)createChooseChannelCell {
    NSString *cellIdentifier = @"HKChooseChannelTableViewCell";
    HKChooseChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HKChooseChannelTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([HKReleaseVideoParam shareInstance].category.isUpdateCategory) {
        cell.detailTextLabel.hidden = YES;
    }else{
        cell.detailTextLabel.hidden = NO;
    }
//    @weakify(self);
    cell.block = ^{
//        @strongify(self);
        if ([[HKReleaseVideoParam shareInstance].category isUpdateCategory]) {
            return ;
        }
        HKChangeReleaseCategoryViewController *vc = [[HKChangeReleaseCategoryViewController alloc] init];
        self.setMoney =YES;
        vc.selectModel = [HKReleaseVideoParam shareInstance].category;;
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.category = [HKReleaseVideoParam shareInstance].category;
    return cell;
}
#pragma mark 请求
- (void)uploadData {
    HKReleaseVideoParam *param = [HKReleaseVideoParam shareInstance];
    
    self.doneButton.userInteractionEnabled = NO;
    if (param.publishType == ENUM_PublishTypeResume||param.publishType == ENUM_PublishTypeEditResume) {
        
    }
       [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showProgress:0.1 status:@"上传中"];
    [[HKAliyunOSSUploadVideoTool sharedHKAliyunOSSUploadVideoTool]hk_uploadWithVideoPath:param.filePath imagePath:param.coverImgSrcPath title:@"自媒体" requestSuccess:^(BOOL isUpload, NSString *msg) {
        if (!isUpload) {
            [SVProgressHUD dismiss];
        }
    } updataSuccess:^(VodSVideoUploadResult *result) {
        NSDictionary*dic = [param dataParamDict:result.videoId coverImgSrc:result.imageUrl type:param.publishType products:self.selectedItems];
        DLog(@"dic===%@...dataArr==%zd",dic,param.dataArray.count);
    
        [HK_NetWork updataFileWithURL:param.updataUrl formDataArray:param.dataArray parameters:dic progress:^(NSProgress *progress) {
            DLog(@"完成:%lld,总计:%lld...url=%@",progress.completedUnitCount,progress.totalUnitCount,param.updataUrl);
         
            [SVProgressHUD showProgress:0.5+(float)progress.completedUnitCount/progress.totalUnitCount status:@"上传中"];
            
        } callback:^(id responseObject, NSError *error) {
            self.doneButton.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];
            if (error) {
                [HKReleaseVideoParam clearParam];
                 [SVProgressHUD showInfoWithStatus:@"发布失败"];
            }else{
                NSUInteger code =[[responseObject objectForKey:@"code"] integerValue];
                if (code==0) {
                    [HKReleaseVideoParam clearParam];
                    [self uploadSuccess];
                }else {
                    
                    [HKReleaseVideoParam clearParam];
                    [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
                }
            }
        }];
    }uploadProgressWithUploadedSize:^(CGFloat progress) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showProgress:(float)progress*0.5 status:@"上传中"];
    }];
    
    
}
-(HKMoneyPayCell *)createMoneyCell:(NSIndexPath *)indexPath {
     NSString *cellIdentifier = @"HKTitleMoneyCell";
      HKMoneyPayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HKMoneyPayCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.model = self.model;
    return cell;
}
//标题和内容cell
- (HKTitleAndContentCell *)createTitleAndContentCell {
    NSString *cellIdentifier = @"HKTitleAndContentCell";
    HKTitleAndContentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HKTitleAndContentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.coverImage = [HKReleaseVideoParam shareInstance].coverImgSrc;
    self.titleContentCell = cell;
    return cell;
}

//图片附件cell
- (HKImageAnnexCell *)createImageAnnexCellWithTip:(NSString *)tip{
    HKImageAnnexCell *cell = [HKImageAnnexCell imageAnnexCellWithDelegate:self
                                                                      tip:tip
                                                                   images:[HKReleaseVideoParam shareInstance].photographyImages
                                            cellPickImageBlock:^(NSMutableArray<UIImage *> *pickImages) {
        DLog(@"选择了图片--:%@",pickImages);
                                                [HKReleaseVideoParam shareInstance].photographyImages = pickImages;
    }];
    return cell;
}

//定位cell
- (HKReleaseLocationCell *)createLocationCell:(NSIndexPath *)indexPath {
    self.locationCellIndexPath = indexPath;
    NSString *cellIdentifier = @"HKReleaseLocationCell";
    HKReleaseLocationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HKReleaseLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.locationData = self.locationData;
    return cell;
}

//商品cell
- (HKDisplayProductCell *)createDisplayProductCell:(NSIndexPath *)indexPath {
    if (!self.productCellIndexPath) {
        self.productCellIndexPath = indexPath;
    }
    NSString *cellIdentifier = @"HKDisplayProductCell";
    HKDisplayProductCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HKDisplayProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectedItems = self.selectedItems;
    cell.boothCount = self.boothCount;
//    @weakify(self);
    //购买展位
    cell.buyBoothBlock = ^{
//        @strongify(self);
        [self requestBuyBooth];
    };
    //跳转到我的商品
    cell.gotoUserProductBlock = ^{
//        @strongify(self);
        HKUserProductViewController *vc = [[HKUserProductViewController alloc] init];
        vc.selectItems = self.selectedItems;
        vc.boothCount = self.boothCount;
        vc.block = ^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        self.setMoney = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
-(HKIconAndTitleCenterView *)doneButton{
    if (!_doneButton) {
        @weakify(self)
        _doneButton = [HKIconAndTitleCenterView iconAndTitleCenterViewWithTitle:@"发布" imageName:@"fabu" backColor:RGB(74,145,223) click:^(HKIconAndTitleCenterView *sender) {
            @strongify(self)
            
            [self buttonClick];
                       }];
    }
    return _doneButton;
}
@end
