//
//  HKUpdateResumeViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateResumeViewController.h"
#import "HKUpdateResumeHeadImgCell.h"
#import "HKUpdateResumeBasicInfoCell.h"
#import "HKResumeAddAllCell.h"
#import "HKCareerIntentionsCell.h"
#import "HKUserEducationalCell.h"
#import "HKUserExperienceCell.h"
#import "HKUserContentCell.h"
#import "HKChooseCellModel.h"
#import "HKResumeBasicInfoViewController.h"
#import "UrlConst.h"
//#import "reqeust_get_updateUserPortrait.h"
#import "HK_MyApplyTool.h"
#import "HK_NetWork.h"
#import "HKDateTool.h"
@interface HKUpdateResumeViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) HK_UserRecruitData *recruitUserInfo;
@property (nonatomic, strong) NSArray<HK_UserEducationalData *> *userEducationalItems;
@property (nonatomic, strong) NSArray<HK_UserExperienceData *> *userExperienceItems;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString *complete;
@end

@implementation HKUpdateResumeViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        //自动估算行高
        tableView.estimatedRowHeight = 100.f;
        tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:tableView];
        _tableView = tableView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKUpdateResumeHeadImgCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKUpdateResumeHeadImgCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKUpdateResumeBasicInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKUpdateResumeBasicInfoCell class])];
        [_tableView registerClass:[HKResumeAddAllCell class] forCellReuseIdentifier:NSStringFromClass([HKResumeAddAllCell class])];
        [_tableView registerClass:[HKCareerIntentionsCell class] forCellReuseIdentifier:NSStringFromClass([HKCareerIntentionsCell class])];
        [_tableView registerClass:[HKUserContentCell class] forCellReuseIdentifier:NSStringFromClass([HKUserContentCell class])];
    }
    return _tableView;
}

- (NSMutableArray *)images {
    if (!_images) {
        _images =[[NSMutableArray alloc] init];
    }
    return _images;
}
#pragma mark 设置 nav
- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
}

//导航右侧按钮点击
- (void)nextStep {
    
}
#pragma mark 教育经历
- (void)requestUserEdutional {
    [HK_MyApplyTool getUserEDucInfoSuccessBlock:^(id res) {
        NSArray *list = res[@"data"];
        NSMutableArray *arr =[[NSMutableArray alloc] init];
        for (NSDictionary * dic in list) {
            HK_UserEducationalData *items =[HK_UserEducationalData mj_objectWithKeyValues:dic];
            [arr addObject:items];
        }
        self.userEducationalItems =(NSArray *)arr;
        [self.tableView reloadData];
        [self updateComplete];
    } andFial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}
#pragma mark 工作经历
- (void)requestUserExperience {
    [HK_MyApplyTool getUserWorkInfoSuccessBlock:^(id res) {
        NSArray *list = res[@"data"];
        NSMutableArray *arr =[[NSMutableArray alloc] init];
        for (NSDictionary * dic in list) {
            HK_UserExperienceData *items =[HK_UserExperienceData mj_objectWithKeyValues:dic];
            [arr addObject:items];
        }
        self.userExperienceItems =(NSArray *)arr;
        [self.tableView reloadData];
        [self updateComplete];

    } andFial:^(NSString *msg) {
         [EasyShowTextView showText:msg];
    }];
}
#pragma mark 获取用户个人信息
- (void)requestRecruitUserInfo {
    [HK_MyApplyTool getUserRecruitInfoSuccessBlock:^(HK_UserRecruitData *comRes) {
       self.recruitUserInfo = comRes;
       [self.tableView reloadData];
       [self updateComplete];
        
    } andFial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}

//修改个人简历头像
- (void)uploadHeadImg {
#pragma mark 上传图片...
    [HK_NetWork uploadEditImageURL:get_updateUserPortrait parameters:@{kloginUid:LOGIN_UID} images:self.images name:@"portrait" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:@"jpeg" specifications:nil progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            //上传成功
            [self requestRecruitUserInfo];
        }
    }];
}
//工作经历,教育经历各占30%,职业意向10%,基本信息10%,头像10%,自我描述10%
- (void)updateComplete {
    NSInteger percent = 0;
    if (self.recruitUserInfo.portrait) {
        percent += 10;  //头像
    }
    if (self.recruitUserInfo.content) {
        percent += 10;  //自我描述
    }
    if (self.recruitUserInfo.name && self.recruitUserInfo.mobile && self.recruitUserInfo.email) {
        percent += 10;  //基本信息
    }
    if (self.recruitUserInfo.functionsName && self.recruitUserInfo.salaryName) {
        percent += 10;  //职业意向
    }
    if ([self.userEducationalItems count] > 0) {
        percent += 30;
    }
    if ([self.userExperienceItems count] > 0) {
        percent += 30;
    }
    self.complete = [NSString stringWithFormat:@"%ld%%",percent];
    if (self.block) {
        self.block(self.complete);
    }
}

- (void)setComplete:(NSString *)complete {
    if (complete) {
        _complete = complete;
        self.title = [NSString stringWithFormat:@"简历完整度：%@",complete];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(241, 241, 241);
    
    [self setNavItem];
    
    [self requestUserEdutional];
    
    [self requestUserExperience];
    
    [self requestRecruitUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            HKUpdateResumeHeadImgCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKUpdateResumeHeadImgCell class])];
            cell.headImg = self.recruitUserInfo.portrait;
//            @weakify(self);
            cell.block = ^{
//                @strongify(self);
                //调用相机
                [self showCameraSheet];
            };
            return cell;
        }
            break;
        case 1:
        {
            HKUpdateResumeBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKUpdateResumeBasicInfoCell class])];
            cell.infoData = self.recruitUserInfo;
            
//            @weakify(self);
            cell.updateResumeBlock = ^{
//                @strongify(self);
                HKResumeBasicInfoViewController *vc = [[HKResumeBasicInfoViewController alloc] init];
                vc.infoData = self.recruitUserInfo;
                vc.uploadSuccessBlock = ^{
                    [self requestRecruitUserInfo];
                };
                [self.navigationController pushViewController:vc  animated:YES];
            };
            return cell;
        }
            break;
        case 2:
        {
            return [HKChooseCellModel careerIntentionCellWith:self.recruitUserInfo vc:self uploadSuccessBlock:^{
                [self requestRecruitUserInfo];
            }];
        }
            break;
        case 3:
        {
            return [HKChooseCellModel educationalCellWithItems:self.userEducationalItems tableView:tableView vc:self uploadSuccessBlock:^{
                [self requestUserEdutional];
            }];
        }
            break;
        case 4:
        {
            return [HKChooseCellModel experienceCellWithItems:self.userExperienceItems tableView:tableView vc:self uploadSuccessBlock:^{
                [self requestUserExperience];
            }];
        }
            break;
        case 5:
        {
            return [HKChooseCellModel userContentCellWith:self.recruitUserInfo vc:self uploadSuccessBlock:^{
                [self requestRecruitUserInfo];
            }];
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}

#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 138.f;
            break;
        case 1:
            return 266.f;
            break;
        case 2:
            return [HKChooseCellModel careerIntentionCellHeightWith:self.recruitUserInfo];
            break;
        case 3:
            return [HKChooseCellModel educationalCellHeightWithItems:self.userEducationalItems tableView:tableView];
            break;
        case 4:
            return [HKChooseCellModel experienceCellHeightWithItems:self.userExperienceItems tableView:tableView];
            break;
        case 5:
            return [HKChooseCellModel userContentCellHeightWith:self.recruitUserInfo];
            break;
            
        default:
            return 0;
            break;
    }
}

//header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)sectionHeaderViewWithTitle:(NSString *)title isRequired:(BOOL)isRequired{
    UIView *view = [[UIView alloc] init];
    
    UILabel *titleLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                   textColor:UICOLOR_HEX(0x333333)
                                               textAlignment:NSTextAlignmentLeft
                                                        font:PingFangSCRegular15
                                                        text:title
                                                  supperView:view];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.top.equalTo(view).offset(21);
        make.height.mas_equalTo(15);
    }];
    
    if (isRequired) {
        UILabel *tipLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                       textColor:UICOLOR_HEX(0xf44834)
                                                   textAlignment:NSTextAlignmentLeft
                                                            font:PingFangSCRegular11
                                                            text:@"必填"
                                                      supperView:view];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(5);
            make.bottom.equalTo(titleLabel);
            make.height.mas_equalTo(11);
        }];
    }
    
    return view;
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title;
    BOOL isRequired;
    switch (section) {
        case 0:
        {
            title = @"简历头像";
            isRequired = YES;
        }
            break;
        case 1:
        {
            title = @"基本信息";
            isRequired = YES;
        }
            break;
        case 2:
        {
            title = @"职业意向";
            isRequired = YES;
        }
            break;
        case 3:
        {
            title = @"教育经历";
            isRequired = YES;
        }
            break;
        case 4:
        {
            title = @"工作经历";
            isRequired = NO;
        }
            break;
        case 5:
        {
            title = @"自我描述";
            isRequired = NO;
        }
            break;
            
        default:
            return nil;
            break;
    }
    return [self sectionHeaderViewWithTitle:title isRequired:isRequired];
}

//footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 5) {
        return [UIView new];
    }
    return nil;
}

//footer 高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 5) {
        return 47;
    }
    return 0.01f;
}

//cell 选中处理
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.section) {
//        case 0:
//        case 1:
//            break;
//        case 2:
//        {
//
//        }
//            break;
//        case 3:
//        {
//
//        }
//            break;
//
//        default:
//            break;
//    }
//}

#pragma mark 相机
-(void)showCameraSheet{
    //    [HK_Tool event:@"change_face_#person" label:@"change_face_#person"];
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [self openCamera:UIImagePickerControllerSourceTypePhotoLibrary];
        return;
    }
    UIActionSheet *imageSheet = [[UIActionSheet alloc] initWithTitle:@"修改图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从相册选择", nil];
    imageSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [imageSheet showInView:self.view];
}

- (void)openCamera:(UIImagePickerControllerSourceType)sourceType{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self showPickViewController:picker];
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

#pragma mark –
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        //        portraitImg = [portraitImg imageByScalingToMaxSize];
        // 裁剪
        
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:10];
        
        imgEditorVC.delegate = self;
        [self showCropperViewController:imgEditorVC];
    }];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [self saveImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存图片
- (void)saveImage:(UIImage *)image {
    UIImage *midImage = [ImageTool imageWithImageSimple:image scaledToWidth:100.0f];
    NSData * value = [[HK_Tool GetTimeStamp] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"%@",[value MD5String]]];
    //封装上传图片数据
    HK_UploadImagesModel *model = [[HK_UploadImagesModel alloc] init];
    model.image = midImage;
    model.fileName = imageName;
    model.uploadKey = @"portrait";
    [self.images addObject:image];
    // [self.images setObject:model forKey:model.uploadKey];
    [self uploadHeadImg];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentController:(UIViewController *)controller push:(BOOL)push sender:(id)sender
{
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)dismissController:(UIViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}


-(void)showPickViewController:(UIImagePickerController *)viewController;
{
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void)showCropperViewController:(VPImageCropperViewController *)viewController;
{
    [self presentViewController:viewController animated:YES completion:nil];
}



@end
