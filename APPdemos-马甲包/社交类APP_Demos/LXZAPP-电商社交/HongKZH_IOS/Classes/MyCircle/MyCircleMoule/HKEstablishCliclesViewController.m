//
//  HKEstablishCliclesViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEstablishCliclesViewController.h"
#import "HKEstablishClicleTableViewCell.h"
#import "VPImageCropperViewController.h"
#import "HKChangeReleaseCategoryViewController.h"
#import "HKHKEstablishClicleParameters.h"
#import "HKMyCircleViewModel.h"
#import "HK_SingleColumnPickerView.h"
@interface HKEstablishCliclesViewController ()<UITableViewDelegate,UITableViewDataSource,HKEstablishClicleTableViewCellDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,HKChangeReleaseCategoryViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic,strong) UIPickerView* pickerV;
@property (nonatomic, strong)NSArray *teams;
@end

@implementation HKEstablishCliclesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.title =@"创建圈子";
    [self setrightBarButtonItemWithTitle:@"建立"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)rightBarButtonItemClick{
    if (self.parameters.circleName.length == 0) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"请输入圈子名称"];
        return;
    }
    if (self.parameters.introduction.length == 0) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"请输入圈子描述"];
        return;
    }
    if (self.parameters.categoryId.length == 0) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"请选择圈子频道"];
        return;
    }
    NSMutableArray*images = [NSMutableArray array];
    if (self.image) {
        [images addObject:self.image];
    }
    [HKMyCircleViewModel createGroup:[self.parameters mj_keyValues] images:images success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
//            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//            [SVProgressHUD showSuccessWithStatus:@"创建成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
             [EasyShowTextView showText:@"创建失败"];;
        }
    }];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.pickerV];
    [self.pickerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(203);
        make.top.equalTo(self.view).offset(kScreenHeight);
    }];
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
        _tableView.backgroundColor =MainColor;
    }
    return _tableView;
}
-(void)selectCategoty:(HK_BaseAllCategorys *)model{
    
    self.parameters.categoryName = model.name;
    self.parameters.categoryId = model.categoryId;
    [self.tableView reloadData];
}
#pragma mark –
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
    [self.tableView reloadData];
//    [self saveImage:editedImage];
//    [self.imageArr addObject:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)dismissController:(UIViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
#pragma tableView--delegate
#pragma tableView
-(void)showPickViewController:(UIImagePickerController *)viewController;
{
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void)openCamera:(UIImagePickerControllerSourceType)sourceType{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate  = self;
    picker.sourceType = sourceType;
    [self showPickViewController:picker];
}
-(void)selectChannel{
    HKChangeReleaseCategoryViewController*vc = [[HKChangeReleaseCategoryViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.isClicle = YES;
    vc.isPre = YES;
    vc.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)selctImage{
    //    [HK_Tool event:@"change_face_#person" label:@"change_face_#person"];
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
        //        [[customTabWindow defaultTabWindow] hideTabBar];
    }
}
-(void)selectJoin{
    //选证件类型..
    HK_SingleColumnPickerView *picker = [HK_SingleColumnPickerView showWithData:self.teams callBackBlock:^(NSString *value, NSInteger selectedIndex) {
        self.parameters.isValidate = selectedIndex;
        [self.tableView reloadData];
    }];
    [self.navigationController.view addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];

//    [self.pickerV mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(kScreenHeight-203-104);;
//    }];
//    [self.view layoutIfNeeded];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKEstablishClicleTableViewCell*cell = [HKEstablishClicleTableViewCell baseCellWithTableView:tableView];
    cell.parmeeter = self.parameters;
    cell.delegate = self;
    if (self.image) {
         cell.image = self.image;
    }
   
    return cell;
}
-(HKHKEstablishClicleParameters *)parameters{
    if (!_parameters) {
        _parameters = [[HKHKEstablishClicleParameters alloc]init];
        _parameters.isValidate = NO;
        _parameters.loginUid = HKUSERLOGINID;
    }
    return _parameters;
}
-(UIPickerView *)pickerV{
    if (!_pickerV) {
        UIPickerView*pickv = [[UIPickerView alloc] init];
        pickv.backgroundColor = [UIColor whiteColor];
        pickv.delegate = self;
        pickv.dataSource = self;
        _pickerV =pickv;
        
    }
    return _pickerV;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    return self.teams.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [self.teams objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    self.parameters.isValidate = row;
}
-(NSArray *)teams{
    if (!_teams) {
        _teams = [NSArray arrayWithObjects:@"任何人可加入",@"需经过圈主同意",nil];
    }
    return _teams;
}
@end
