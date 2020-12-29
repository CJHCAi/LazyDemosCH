//
//  HKCircleSettingViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCircleSettingViewController.h"
#import "HKCircleSetting_TableViewCell.h"
#import "HKMyCircleViewModel.h"
#import "VPImageCropperViewController.h"
#import "HKChangeReleaseCategoryViewController.h"
#import "HKHKEstablishClicleParameters.h"
#import "HK_SingleColumnPickerView.h"
#import "HKUpdateCicleNameVc.h"
#import "HKCicleMemberVc.h"
#import "HKUserProductViewController.h"
#import "HKProductsModel.h"
@interface HKCircleSettingViewController ()<UITableViewDelegate,UITableViewDataSource,SetCellDelegete,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,HKChangeReleaseCategoryViewControllerDelegate,UIActionSheetDelegate,SelectProductDelegete>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *footView;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)HKHKEstablishClicleParameters *parameters;
@property (nonatomic, strong)NSMutableArray *arr;

@end
@implementation HKCircleSettingViewController


-(void)selectCategoty:(HK_BaseAllCategorys *)model{
    self.parameters.categoryId = model.categoryId;
    [HKMyCircleViewModel updateGroupChannel:[self.parameters mj_keyValues] success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            self.dataModel.categoryName = model.name;
            self.dataModel.categoryId = model.categoryId;
            [self.tableView  reloadData];
        }else {
            [EasyShowTextView showText:@"修改频道失败"];
        }
    }];
}
-(UIView *)footView {
    if (!_footView) {
        _footView=[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,70)];
        _footView.backgroundColor = MainColor;
        UIButton *sub =[UIButton buttonWithType:UIButtonTypeCustom];
        [AppUtils getButton:sub font:PingFangSCRegular16 titleColor:[UIColor whiteColor] title:@"解散圈子"];
         sub.frame =CGRectMake(30,10,kScreenWidth-60,50);
        sub.layer.cornerRadius =5;
        sub.layer.masksToBounds = YES;
        sub.backgroundColor =keyColor;
        [sub addTarget:self action:@selector(subComplains) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:sub];
    }
    return _footView;
}

-(void)subComplains {
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"您确定要解散圈子?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleA =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancleA setValue:RGB(153,153,153) forKey:@"titleTextColor"];
    [alertController addAction:cancleA];
    UIAlertAction *define =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [HKMyCircleViewModel dissMissGroup:@{kloginUid:HKUSERLOGINID,@"circleId":self.circleId} success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
              
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else
            {
                [EasyShowTextView showText:@"操作失败"];
            }
        }];
    }];
    [define setValue:keyColor forKey:@"titleTextColor"];
    [alertController addAction:define];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"圈子设置";
    [self setUI];
}
-(void)setDataModel:(HKMyCircleData *)dataModel{
    _dataModel = dataModel;
    [self.tableView reloadData];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.backgroundColor =MainColor;
        _tableView.tableFooterView =self.footView;
    }
    return _tableView;
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCircleSetting_TableViewCell*cell = [HKCircleSetting_TableViewCell circleSetting_TableViewCellWithTableView:tableView];
//    if (self.arr.count) {
//        NSMutableArray *proa =[[NSMutableArray alloc] init];
//        for (HKUserProduct *product in self.arr) {
//            HKProductsModel * proMo =[[HKProductsModel alloc] init];
//            proMo.productId =product.productId;
//            proMo.imgSrc = product.imgSrc;
//            proMo.title =product.title;
//            proMo.price =(int)product.price;
//            [proa addObject:proMo];
//        }
//        self.dataModel.products =(NSArray *)proa;
//    }
    cell.model = self.dataModel;
    cell.contentView.backgroundColor =MainColor;
    cell.delegete = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f+(self.view.frame.size.width/85.6*54)/2, self.view.frame.size.width, self.view.frame.size.width/85.6*54) limitScaleRatio:10];
        imgEditorVC.delegate = self;
        [self showCropperViewController:imgEditorVC];
    }];
}
-(void)showCropperViewController:(VPImageCropperViewController *)viewController;
{
    [self presentViewController:viewController animated:YES completion:nil];
}
#pragma mark VPImageCropperDelegate
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.parameters.coverImgWidth = (NSInteger)editedImage.size.width;
    self.parameters.coverImgHeight = (NSInteger)editedImage.size.height;
    self.image = editedImage;
    NSMutableArray *img =[NSMutableArray array];
    if (self.image) {
        [img addObject:self.image];
    }
    //修改封面......
    [HKMyCircleViewModel updateGroupCover:[self.parameters mj_keyValues] images:img success:^(HKBaseResponeModel *responde) {
        
        if (responde.responeSuc) {
            self.dataModel.coverImg = self.image;
            [self.tableView reloadData];
        }else{
            [EasyShowTextView showText:@"修改失败"];
        }
        
    }];
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}
-(HKHKEstablishClicleParameters *)parameters{
    if (!_parameters) {
        _parameters = [[HKHKEstablishClicleParameters alloc]init];
        _parameters.loginUid = HKUSERLOGINID;
        _parameters.circleId = self.circleId;
    }
    return _parameters;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)dismissController:(UIViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark  SetCellDelegete
//购买展位...
-(void)updateGoodsNumber {
//    if ([LoginUserData sharedInstance].integral <(NSInteger) self.dataModel.boothMoney) {
//        [EasyShowTextView showText:@"乐币不足"];
//        return;
//    }
    [HKMyCircleViewModel shopBoothWithCicleId:self.circleId success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            self.dataModel.num++;
            DLog(@"购买展位之后..%d",self.dataModel.num);
            [self.tableView reloadData];
        }else {
            [EasyShowTextView showText:@"购买失败"];
        }
    }];
}
//从我的商品中选择商品...
-(void)chooseProduct {
    if (self.arr.count) {
        [self.arr removeAllObjects];
    }
    HKUserProductViewController *vc = [[HKUserProductViewController alloc] init];
    vc.isCicle =YES;
    vc.delegete = self;
    //此处要将展示数量和模型传过去.
    vc.boothCount = self.dataModel.num;
    for (HKProductsModel *m  in self.dataModel.products) {
            HKUserProduct *p  =[[HKUserProduct alloc] init];
            p.productId =m.productId;
            p.title =m.title;
            p.price =(NSInteger)m.price;
            p.isShow =m.isShow;
            p.imgSrc =m.imgSrc;
            [self.arr addObject:p];
        }
      vc.selectItems = self.arr;
    DLog(@"购买展位之后传入的数据..num==%zd....传入产品==%zd",vc.boothCount,vc.selectItems.count);
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectProduct:(HKUserProduct *)model {
   //上传商品 成功加入数据源中...
    if (model.isShow) {
        [HKMyCircleViewModel removeCicleProduct:model.productId cicleId:self.circleId success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
                NSMutableArray *arr =[NSMutableArray arrayWithArray:self.dataModel.products];
                for (HKProductsModel * Cm in arr) {
                    if ([Cm.productId isEqualToString:model.productId]) {
                        [self.dataModel.products removeObject:Cm];
                    }
                }
                [self.tableView reloadData];
            }else {
                [EasyShowTextView showText:responde.msg];
            }
        }];
    }else {
      //添加
        [HKMyCircleViewModel addCilceProduct:model.productId cicleId:self.circleId success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
                HKProductsModel *m  =[[HKProductsModel alloc] init];
                m.productId =model.productId;
                m.imgSrc =model.imgSrc;
                m.title =model.title;
                [self.dataModel.products addObject:m];
                [self.tableView reloadData];
            }else {
                [EasyShowTextView showText:responde.msg];
            }
        }];
    }
}
-(void)pushMemberVc {
    HKCicleMemberVc * memberVc =[[HKCicleMemberVc alloc] init];
    memberVc.isMain =YES;
    memberVc.model = self.dataModel;
    memberVc.cicleId = self.circleId;
    [self.navigationController pushViewController:memberVc animated:YES];
}
-(void)updateCaterGrory {
    HKChangeReleaseCategoryViewController*vc = [[HKChangeReleaseCategoryViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.isClicle = YES;
    vc.isPre = YES;
    vc.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)updateCicleName {
    HKUpdateCicleNameVc * nameVC =[[HKUpdateCicleNameVc alloc] init];
    nameVC.updateName = YES;
    nameVC.name = self.dataModel.name;
    nameVC.block = ^(NSString *name) {
        
        [self updateNameWithCicleName:name andUpdateName:YES];
    };
    [self.navigationController pushViewController:nameVC animated:YES];
}
-(void)updateDescInfo {
    HKUpdateCicleNameVc * nameVC =[[HKUpdateCicleNameVc alloc] init];
    nameVC.updateName = NO;
    nameVC.name =self.dataModel.introduction;
    nameVC.block = ^(NSString *name) {
        [self updateNameWithCicleName:name andUpdateName:NO];
    };
    [self.navigationController pushViewController:nameVC animated:YES];
    
}
-(void)updateNameWithCicleName:(NSString *)cicleName andUpdateName:(BOOL)isName {
    if (isName) {
        self.parameters.circleName =cicleName;
        [HKMyCircleViewModel updateGroupName:[self.parameters mj_keyValues] success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
                self.dataModel.name =cicleName;
                [self.tableView reloadData];
            }else {
                [EasyShowTextView showText:@"操作失败"];
            }
        }];
    }else {
        self.parameters.introduction =cicleName;
        [HKMyCircleViewModel updateGroupIntrodution:[self.parameters mj_keyValues] success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
                self.dataModel.introduction =cicleName;
                [self.tableView reloadData];
            }else {
                [EasyShowTextView showText:@"操作失败"];
            }
        }];
    }
}
-(void)updateJoinMethod {
    //选证件类型..
    HK_SingleColumnPickerView *picker = [HK_SingleColumnPickerView showWithData:@[@"任何人可加入",@"需经圈主同意"] callBackBlock:^(NSString *value, NSInteger selectedIndex) {
        if (selectedIndex ==0) {
            self.parameters.isValidate = NO;
        }else {
            self.parameters.isValidate = YES;
        }
        [HKMyCircleViewModel updateGroupValidate:[self.parameters mj_keyValues] success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
                self.dataModel.isValidate  = self.parameters.isValidate? 1:0;
                [self.tableView reloadData];
            }else {
                [EasyShowTextView showText:@"操作失败"];
            }
        }];
    }];
    [self.navigationController.view addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
}
-(void)updateNumCount {
    //选证件类型..
    HK_SingleColumnPickerView *picker = [HK_SingleColumnPickerView showWithData:@[@"20",@"50",@"100",@"500"] callBackBlock:^(NSString *value, NSInteger selectedIndex) {
        self.parameters.upperLlimit =value;
        [HKMyCircleViewModel updateGroupValidate:[self.parameters mj_keyValues] success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
                self.dataModel.upperLlimit =value.intValue;
                [self.tableView reloadData];
            }else {
                [EasyShowTextView showText:@"操作失败"];
            }
        }];
    }];
    [self.navigationController.view addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    
}
-(void)updateCoverImage {
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [self openCamera:UIImagePickerControllerSourceTypePhotoLibrary];
        return;
    }
    UIActionSheet *imageSheet = [[UIActionSheet alloc] initWithTitle:@"修改图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从相册选择", nil];
    imageSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [imageSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self openCamera:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1) {
        [self openCamera:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else if (buttonIndex == 2)
    {
    }
}
- (void)openCamera:(UIImagePickerControllerSourceType)sourceType{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate  = self;
    picker.sourceType = sourceType;
    [self showPickViewController:picker];
}
-(void)showPickViewController:(UIImagePickerController *)viewController;
{
    [self presentViewController:viewController animated:YES completion:nil];
}
-(NSMutableArray *)arr {
    if (!_arr) {
        _arr =[[NSMutableArray alloc] init];
    }
    return _arr;
}
@end
