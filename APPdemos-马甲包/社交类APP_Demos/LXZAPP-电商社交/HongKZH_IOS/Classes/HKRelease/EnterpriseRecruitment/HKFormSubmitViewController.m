//
//  HKFormSubmitViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFormSubmitViewController.h"
#import "PickerView.h"
#import "NSDate+ZXDate.h"
#import "ChinaArea.h"
#import "HKBaseCitySelectorViewController.h"
#import "HK_BaseRecruitIndustrys.h"
@interface HKFormSubmitViewController ()<HK_FormCellDelegate>
@property (nonatomic, strong) NSMutableArray *years;
@end

@implementation HKFormSubmitViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableView];
        _tableView = tableView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

#pragma mark 数据源
-(NSMutableArray *)years {
    if (!_years) {
        NSMutableArray *tempArray = [NSMutableArray array];
        NSInteger year = [[NSDate date] year];
        for (int i = 2000; i < year; i++) {
            [tempArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _years = tempArray;
    }
    return _years;
}

- (NSMutableDictionary *)dataDict {
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

- (NSMutableDictionary *)images {
    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

#pragma mark 设置 nav
- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.rightItemTitle style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

//导航右侧按钮点击
- (BOOL)nextStep {
    DLog(@"下一步");
    [self.view endEditing:YES];
    
    //遍历验证数据
    for (HK_SectionModel *sectionModel in self.groups) {
        for (HK_FormModel * formModel in sectionModel.formItems) {
            __block BOOL flag = NO;
            [formModel verifyDataIntegrityWithFaliureBlock:^(NSString *cellTitle) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@不能为空",cellTitle]];
                flag = YES;
            }];
            if (flag) { //如果有没填的就 return
                return NO;
            }
            //通过验证,添加到 dataDict 中组装数据,传递到下个界面或提交
            if (formModel == self.logoModel) {
                //如果是图片的 model,不用添加,之前已经添加到图片数组中了
            } else {
                if (formModel.required) {   //需要传的参数才要添加到字典中
                    [self.dataDict setObject:formModel.value forKey:formModel.postKey];
                  
                    
                }
            }
        }
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    [self initData];
    [self.tableView reloadData];
}

//初始化数据
- (void)initData {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HK_SectionModel *sectionModel = [self.groups objectAtIndex:section];
    return sectionModel.formItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_SectionModel *sectionModel = self.groups[indexPath.section];
    HK_FormModel *formModel = sectionModel.formItems[indexPath.row];
    //根据 formModel 的不同类型创建不同的 cell
    HK_FormCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([formModel class])];;
    if (cell == nil) {
        if ([formModel isKindOfClass:[HK_TextFieldFormModel class]] ||
            [formModel isKindOfClass:[HK_LogoFormModel class]] ||
            [formModel isKindOfClass:[HK_TextViewFormModel class]]) 
        {
            //如果是 textfield | HK_LogoFormModel | HK_UnableModifyFormModel 类型使用 默认样式
            cell = [[HK_FormCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([formModel class])];
            if ([formModel isKindOfClass:[HK_LogoFormModel class]]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else if ([formModel isKindOfClass:[HK_SeclectFormModel class]] ||
                 [formModel isKindOfClass:[HK_UnableModifyFormModel class]])
        {
            //如果是 HK_SeclectFormModel 类型 使用默认 cell 样式1,并添加箭头
            cell = [[HK_FormCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([formModel class])];
            if ([formModel isKindOfClass:[HK_SeclectFormModel class]]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.detailTextLabel.font = [UIFont fontWithName:PingFangSCRegular size:14.f];
            cell.detailTextLabel.textColor = RGB(102, 102, 102);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //设置数据
    cell.formModel = formModel;
    cell.delegate = self;
    
    
    return cell;
}
-(void)contentStartEditBlock:(CGRect)frameToView{
    self.editFrame = frameToView;
}
#pragma mark UITableViewDelegate

//cell 选中处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self handleTableClick:tableView indexPath:indexPath];
}

- (void)handleTableClick:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    HK_SectionModel *sectionModel = self.groups[indexPath.section];
    HK_FormModel *formModel = sectionModel.formItems[indexPath.row];
    //--------.如果是带箭头的 cell 有下步操作的 cell--------
    if ([formModel isKindOfClass:[HK_SeclectFormModel class]])
    {
        //如果是箭头选择类型的 model
        [self.view endEditing:YES];
        HK_SeclectFormModel *seclectFormModel = (HK_SeclectFormModel *)formModel;
       HKInitializationRespone*model =[NSKeyedUnarchiver unarchiveObjectWithFile:KinitDataPath];
  
        //根据名字来匹配事件
        if ([formModel.cellTitle isEqualToString:@"行业领域"])
        {
            [HK_LeSeeAddProductClassifyMenu showInView:self.navigationController.view withDataSourceType:DataSourceType_Data_RecruitIndustrys animation:YES selectedCallback:^(NSArray *items) {
                HK_BaseRecruitIndustrys *model = [items lastObject];
                seclectFormModel.value = model.ID;
                seclectFormModel.placeHolder = model.name;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }
        else if ([formModel.cellTitle isEqualToString:@"公司规模"])
        {
            //begin
            [self showPickerDataWithType:@"hk_recruit_scale" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
            //end
        }
        else if ([formModel.cellTitle isEqualToString:@"发展阶段"]) {
            [self showPickerDataWithType:@"hk_recruit_stage" model:model seclectFormModel:(HK_SeclectFormModel *)seclectFormModel indexPath:indexPath];
        }
        else if ([formModel.cellTitle isEqualToString:@"所在地区"] ||
                 [formModel.cellTitle isEqualToString:@"工作地点"] ||
                 [formModel.cellTitle isEqualToString:@"所在城市"] ||
                 [formModel.cellTitle isEqualToString:@"期望城市"] ||
                 [formModel.cellTitle isEqualToString:@"居住地"])
        {
            self.areaModel = seclectFormModel;
            self.areaIndexPath = indexPath;
            @weakify(self)
            [HKBaseCitySelectorViewController showCitySelectorWithProCode:@"" cityCode:@"" areaCode:@"" navVc:self ConfirmBlock:^(HKProvinceModel *proCode, HKCityModel *cityCode, getChinaListAreas *areaCode) {
                 @strongify(self);
                ChinaArea*china = [[ChinaArea alloc]init];
                AreaModel*area = [[AreaModel alloc]init];
                area.GRADE = @"4";
                area.ID = [NSString stringWithFormat:@"%@",areaCode.code];
                area.NAME = areaCode.name;
                area.PARENT_AREA_ID =  cityCode.code;
                CityModel*cityM = [[CityModel alloc]init];
                cityM.GRADE = @"3";
                cityM.ID = cityCode.code;
                cityM.NAME = cityCode.name;
                cityM.PARENT_AREA_ID = proCode.code;
                ProvinceModel*proM = [[ProvinceModel alloc]init];
                proM.GRADE = @"2";
                proM.ID=proCode.code;
                proM.NAME = proCode.name;
                china.provinceModel = proM;
                china.cityModel = cityM;
                china.areaModel =area;
                [self chinaPlckerViewDelegateChinaModel:china];
            }];
//            [ChinaPlckerView customChinaPicker:self superView:self.navigationController.view];
        }
        else if ([formModel.cellTitle isEqualToString:@"职位类别"] ||
                   [formModel.cellTitle isEqualToString:@"期望职位"])
        {
            [HK_LeSeeAddProductClassifyMenu showInView:self.navigationController.view withDataSourceType:DataSourceType_Data_RecruitCategorys animation:YES selectedCallback:^(NSArray *items) {
                HK_BaseRecruitIndustrys *model = [items lastObject];
                seclectFormModel.value = model.ID;
                seclectFormModel.placeHolder = model.name;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        } 
        else if ([formModel.cellTitle isEqualToString:@"工作性质"])
        {
            [self showPickerDataWithType:@"hk_recruit_nature" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        }
        else if ([formModel.cellTitle isEqualToString:@"工作经验"])
        {
            [self showPickerDataWithType:@"hk_recruit_experience" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        }
        else if ([formModel.cellTitle isEqualToString:@"学历要求"] ||
                   [formModel.cellTitle isEqualToString:@"最高学历"] ||
                   [formModel.cellTitle isEqualToString:@"学历"])
        {
            [self showPickerDataWithType:@"hk_recruit_education" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        }
        else if ([formModel.cellTitle isEqualToString:@"月薪范围"] ||
                   [formModel.cellTitle isEqualToString:@"期望月薪"] ||
                 [formModel.cellTitle isEqualToString:@"月收入"])
        {
            [self showPickerDataWithType:@"hk_recruit_salary" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        }
        else if ([formModel.cellTitle isEqualToString:@"工作性质"])
        {
            [self showPickerDataWithType:@"hk_recruit_nature" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        }
        else if ([formModel.cellTitle isEqualToString:@"当前状态"])
        {
            [self showPickerDataWithType:@"hk_recruit_state" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        }
        else if ([formModel.cellTitle isEqualToString:@"到岗时间"])
        {
            [self showPickerDataWithType:@"hk_recruit_timeToPost" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        }
        else if ([formModel.cellTitle isEqualToString:@"出生日期"] ||
                 [formModel.cellTitle isEqualToString:@"生日"] ||
                 [formModel.cellTitle isEqualToString:@"入职时间"] ||
                 [formModel.cellTitle isEqualToString:@"离职时间"])
        {
            PickerView *vi = [[PickerView alloc] init];
            vi.type = PickerViewTypeBirthday;
//            @weakify(self);
            vi.block = ^(NSString *result) {
//                @strongify(self);
                seclectFormModel.value = result;
                seclectFormModel.placeHolder = result;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            [self.view addSubview:vi];
        }
        else if ([formModel.cellTitle isEqualToString:@"毕业年份"])
        {
            HK_SingleColumnPickerView *picker = [HK_SingleColumnPickerView showWithData:self.years callBackBlock:^(NSString *value, NSInteger selectedIndex) {
                seclectFormModel.value = value;
                seclectFormModel.placeHolder = value;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            [self.navigationController.view addSubview:picker];
            [picker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.navigationController.view);
            }];
        }
        else if ([formModel.cellTitle isEqualToString:@"性别"])
        {
            [self showPickerDataWithType:@"sex" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        }
        else if ([formModel.cellTitle isEqualToString:@"工作年限"])
        {
            [self showPickerDataWithType:@"hk_recruit_workingLife" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        }
        else if ([formModel.cellTitle isEqualToString:@"年龄"]) {
            [self showPickerDataWithType:@"hk_recruit_age" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        } else if ([formModel.cellTitle isEqualToString:@"身高"]) {
            PickerView *vi = [[PickerView alloc] init];
            vi.type = PickerViewTypeHeigh;
//            @weakify(self);
            vi.block = ^(NSString *result) {
//                @strongify(self);
                seclectFormModel.value = result;
                seclectFormModel.placeHolder = result;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            [self.view addSubview:vi];
        } else if ([formModel.cellTitle isEqualToString:@"婚姻状况"]) {
            [self showPickerDataWithType:@"hk_user_marital" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        } else if ([formModel.cellTitle isEqualToString:@"星座"]) {
            [self showPickerDataWithType:@"hk_user_constellation" model:model seclectFormModel:seclectFormModel indexPath:indexPath];
        } else if ([formModel.cellTitle isEqualToString:@"体重"]) {
            PickerView *vi = [[PickerView alloc] init];
            vi.type = PickerViewTypeWeight;
//            @weakify(self);
            vi.block = ^(NSString *result) {
//                @strongify(self);
                seclectFormModel.value = result;
                seclectFormModel.placeHolder = result;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            [self.view addSubview:vi];
        }
    }
    ////--------.选择图片的 cell --------
    else if ([formModel isKindOfClass:[HK_LogoFormModel class]]) { //如果是图片选择类型的 model
        [self.view endEditing:YES];
        self.logoModel = (HK_LogoFormModel *)formModel;
        //调用相机
        [self showCameraSheet];
    }
    ////--------.其他类型什么不干 --------
    else {
        
    }
}

#pragma mark rootDict 中的选项处理
- (void)showPickerDataWithType:(NSString *)type model:(HKInitializationRespone *)model seclectFormModel:(HK_SeclectFormModel *)seclectFormModel indexPath:(NSIndexPath *)indexPath{
    //begin
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    
        [model.data.dict enumerateObjectsUsingBlock:^(DictModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.type isEqualToString:type]) {
                [dataArray addObject:obj];
                [titles addObject:obj.label];
            }
        }];
//    [model.childNodes enumerateObjectsUsingBlock:^(HK_BaseAllDict*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj.type isEqualToString:type]) {
//            [dataArray addObject:obj];
//            [titles addObject:obj.label];
//        }
//    }];
    if(dataArray.count >0) {
        HK_SingleColumnPickerView *picker = [HK_SingleColumnPickerView showWithData:titles callBackBlock:^(NSString *value, NSInteger selectedIndex) {
            //更新数据模型
//            HK_BaseAllDict *data = [dataArray objectAtIndex:selectedIndex];
            DictModel *data =[dataArray objectAtIndex:selectedIndex];
            seclectFormModel.value = data.ID;
            //更新 UI
            seclectFormModel.placeHolder = data.label;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        }];
        [self.navigationController.view addSubview:picker];
        [picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.navigationController.view);
        }];
    }
}

#pragma mark 地区选择处理
- (void)chinaPlckerViewDelegateChinaModel:(ChinaArea *)chinaModel {
    NSMutableString *str = [[NSMutableString alloc] init];
    // 省
    NSString *string1 = @"";
    if (chinaModel.provinceModel.NAME.length > 0) {
        string1 = [NSString stringWithFormat:@"%@-",chinaModel.provinceModel.NAME];
    }
    // 市
    NSString *string2 = @"";
    if (chinaModel.cityModel.NAME.length > 0) {
        string2 = [NSString stringWithFormat:@"%@-",chinaModel.cityModel.NAME];
    }
    // 区
    NSString *string3 =  @"";
    if (chinaModel.areaModel.NAME.length > 0) {
        string3 = [NSString stringWithFormat:@"%@",chinaModel.areaModel.NAME];
    }
    
    [str appendString:string1];
    [str appendString:string2];
    [str appendString:string3];
    
    self.areaModel.value = chinaModel.areaModel.ID;
    self.areaModel.placeHolder = str;
    [self.tableView reloadRowsAtIndexPaths:@[self.areaIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_SectionModel *sectionModel = self.groups[indexPath.section];
    HK_FormModel *formModel = sectionModel.formItems[indexPath.row];
    return formModel.cellHeight;
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HK_SectionModel *sectionModel = self.groups[section];
    UIView *view = [HKComponentFactory viewWithFrame:CGRectMake(0, 0, kScreenWidth, 25) supperView:nil];
    UILabel *label = [HKComponentFactory labelWithFrame:CGRectMake(15, 6, 200, 12) textColor:RGB(153, 153, 153) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCRegular size:12.f] text:sectionModel.header supperView:nil];
    view.backgroundColor = RGB(241, 241, 241);
    [view addSubview:label];
    return view;
}

//footer内容
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    HK_SectionModel *sectionModel = self.groups[section];
    return sectionModel.footer;
}
//header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HK_SectionModel *sectionModel = self.groups[section];
    if (sectionModel.header) {
        return 25.f;
    } else {
        return 10.f;
    }
}

//footer 高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    HK_SectionModel *sectionModel = self.groups[section];
    if (!sectionModel.footer) { //footer 不存在设置为0.01
        return 0.01f;
    } else {
        return 25.f;
    }
}

//键盘事件
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark 键盘处理
-(void)keyboardWillShow:(NSNotification *)note{
    CGRect frame = _editFrame;
    //保存键盘弹出前tableview的contentOffset偏移
    self.lastContentOffset = self.tableView.contentOffset;
    //获取键盘高度
    NSDictionary *info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //判断键盘弹出是否会遮挡当前编辑cell，frame.size.height是当前编辑cell的高度
    CGFloat offSet = frame.origin.y + frame.size.height - (self.view.frame.size.height - kbSize.height);
    //将试图的Y坐标向上移动offset个单位，以使线面腾出开的地方用于软键盘的显示
    if (offSet > 0.01) {
        //有遮挡时，tableview需要的偏移量应该是在原先的基础上再往上上移的，这里我们默认增加10个单位的空白
        offSet += self.lastContentOffset.y + 10;
        [UIView animateWithDuration:0.1 animations:^{
            self.tableView.contentOffset = CGPointMake(0, offSet);
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.1 animations:^{
        self.tableView.contentOffset = self.lastContentOffset;
    }];
}

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
    model.uploadKey = self.logoModel.postKey;
    [self.images setObject:model forKey:model.uploadKey];
    //    [ImageTool saveImage:midImage WithName:imageName];
    //    NSString * localPath = [NSString stringWithFormat:@"%@/%@",[FCFileManager pathForDocumentsDirectory],imageName];
    //保存图片路径到 value 中,下个界面用来获得图片,上传认证
    self.logoModel.value = model;
    [self.tableView reloadData];
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

