//
//  HKTravelPubLishController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTravelPubLishController.h"
#import "HKTravelPublishTitleCell.h"
#import "VPImageCropperViewController.h"
#import "HKChangeReleaseCategoryViewController.h"
#import "HK_NetWork.h"
#import "UrlConst.h"
#import "HKDateTool.h"
#import "ChinaArea.h"
#import "HKBaseCitySelectorViewController.h"
#import "HK_SingleColumnPickerView.h"
#import "HKBaseViewModel.h"
#import "HKInitializationRespone.h"
#import "ImageUtil.h"
@interface HKTravelPubLishController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HKChangeReleaseCategoryViewControllerDelegate>
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)HKTravelPublishTitleCell * cell;
@property (nonatomic, strong)HKChooseChannelTableViewCell *cityCell;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, strong)NSMutableArray * imageArr;
@property (nonatomic, strong)NSMutableArray *mediaCaterArray;
@end

@implementation HKTravelPubLishController
-(NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr =[[NSMutableArray alloc] init];
    }
    return _imageArr;
}

-(NSMutableArray *)mediaCaterArray {
    if (!_mediaCaterArray) {
        _mediaCaterArray =[[NSMutableArray alloc] init];
    }
    return _mediaCaterArray;
}
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//存草稿
- (void)nextStep {
    
    [super nextStep];
}
-(void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}
//发布游记
- (void)buttonClick {
    [super buttonClick];
    [self.cell getNewStringForContent];
    
    DLog(@"....title==%@...content ==%@",self.cell.title,self.cell.content);
    
    [HKReleaseVideoParam setObject:HKUSERLOGINID key:kloginUid];
    if (self.cell.title) {
        [HKReleaseVideoParam setObject:self.cell.title key:@"title"];
    }else {
        [EasyShowTextView showText:@"请先输入标题"];
        return;
    }
    if (self.cell.content) {
        [HKReleaseVideoParam setObject:self.cell.content key:@"content"];
    }else {
        [EasyShowTextView showText:@"请输入游记内容"];
        return;
    }
    NSMutableArray *imageArr=[[NSMutableArray alloc] init];
    if (self.image) {
        [imageArr addObject:self.image];
    }else {
        [EasyShowTextView showText:@"请先添加游记封面"];
        return;
    }
    if (![HKReleaseVideoParam shareInstance].category.categoryId.length) {
        [EasyShowTextView showText:@"选择发布的分类"];
        return;
    }
    [Toast loading];
    HKReleaseVideoParam *prams =[HKReleaseVideoParam shareInstance];
    
    [HK_NetWork uploadEditImageURL:get_CityAdvSaveCityAdv parameters:prams.dict images:imageArr name:@"coverImgSrc" fileName:[HKDateTool getCurrentIMServerTime13] mimeType:nil specifications:nil progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        DLog(@"res==%@...error==%@",responseObject,error);
        
        [Toast loaded];
        if (error) {
            NSString *meg =[responseObject objectForKey:@"msg"];
            if (meg.length) {
                [EasyShowTextView showText:meg];
            }else {
                [EasyShowTextView showText:@"发布失败"];
            }
            return ;
        }
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            [HKReleaseVideoParam clearParam];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            NSString *meg =[responseObject objectForKey:@"msg"];
            if (meg.length) {
                [EasyShowTextView showText:meg];
            }else {
                [EasyShowTextView showText:@"发布失败"];
            }
        }
    }];
}
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            NSString *cellIdentifier = @"HKChooseChannelTableViewCell";
            HKChooseChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKChooseChannelTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text =@"选择发布游记分类";
                cell.textLabel.textColor =[UIColor colorFromHexString:@"333333"];
                cell.textLabel.font =PingFangSCRegular15;
                cell.istrvel = YES;
            }
            cell.block = ^{
                NSMutableArray * data =[[NSMutableArray alloc] init];
                for (HK_BaseAllCategorys * model in self.mediaCaterArray) {
                    [data addObject:model.name];
                }
                if (self.mediaCaterArray.count>0) {
                    HK_SingleColumnPickerView *picker =[HK_SingleColumnPickerView showWithData:data callBackBlock:^(NSString *value, NSInteger index) {
                        HK_BaseAllCategorys * model =[self.mediaCaterArray objectAtIndex:index];
                        [HKReleaseVideoParam shareInstance].category = model;
                        [HKReleaseVideoParam setObject:model.categoryId key:@"categoryId"];
                        [self.tableView reloadData];
                    }];
                    [self.navigationController.view addSubview:picker];
                    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.navigationController.view);
                    }];
                }
            };
           cell.category = [HKReleaseVideoParam shareInstance].category;
            cell.detailTextLabel.text =  cell.category.name.length>0 ?cell.category.name:@"请选择";
            return cell;
        }
            break;
       case 1:
        {
            NSString *cellIdentifier = @"HKChooseChannelTableViewCell";
            HKChooseChannelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKChooseChannelTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.detailTextLabel.text =@"请选择";
                cell.textLabel.text =@"选择发布游记城市";
                cell.textLabel.textColor =[UIColor colorFromHexString:@"333333"];
                cell.textLabel.font =PingFangSCRegular15;
                cell.istrvel = YES;
                self.cityCell =cell;
            }
            cell.block = ^{
                   @weakify(self)
                [HKBaseCitySelectorViewController showCitySelectorWithProCode:@"" cityCode:@"" areaCode:@"" navVc:self ConfirmBlock:^(HKProvinceModel *proCode, HKCityModel *cityCode, getChinaListAreas *areaCode) {
                    @strongify(self)
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
            };
            return cell;
        }
            break;
        case 2:
        {
            NSString *cellIdentifier = @"HKTitleAndContentCell";
            HKTravelPublishTitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HKTravelPublishTitleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.block = ^(NSInteger index) {
                self.index = index;
                [self showSheet];
            };
            cell.coverImage = self.image;
            self.cell = cell;
            return cell;
        }
            break;
        case 3:
        {
             return [self createDisplayProductCell:indexPath];
        }
            break;
        case 4:
        {
             return [self createLocationCell:indexPath];
        }
            break;
        default:
            return nil;
            break;
    }
}
#pragma mark - ChinaPlckerViewDelegate
- (void)chinaPlckerViewDelegateChinaModel:(ChinaArea *)chinaModel{
    NSMutableString *str = [[NSMutableString alloc] init];
    // 省
    NSString *string1 = @"";
    if (chinaModel.provinceModel.NAME.length > 0) {
        string1 = [NSString stringWithFormat:@"%@",chinaModel.provinceModel.NAME];
        [HKReleaseVideoParam setObject:chinaModel.provinceModel.ID key:@"provinceId"];
    }
    // 市 
    NSString *string2 = @"";
    if (chinaModel.cityModel.NAME.length > 0) {
        string2 = [NSString stringWithFormat:@"%@",chinaModel.cityModel.NAME];
        [HKReleaseVideoParam setObject:chinaModel.cityModel.ID key:@"cityId"];
    }
    // 区
    NSString *string3 =  @"";
    if (chinaModel.areaModel.NAME.length > 0) {
        string3 = [NSString stringWithFormat:@"%@",chinaModel.areaModel.NAME];
       
    }
    [str appendString:string1];
    [str appendString:string2];
    [str appendString:string3];
    //ID 选择...
    self.cityCell.detailTextLabel.text =str;
}
-(void)selectCategoty:(HK_BaseAllCategorys *)model {
    
     [HKReleaseVideoParam setObject:model.categoryId key:@"categoryId"];
     [self.tableView reloadData];
}
#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 350.f;
            break;
        case 3:
            return 141.f;
            break;
        case 4:
            return 45.f;
            break;
        default:
            return 0;
            break;
    }
}
#pragma mark 选择图片...
-(void)showSheet {
    UIActionSheet *imageSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从相册选择", nil];
    imageSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [imageSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    // 判断系统是否支持相机
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self; //设置代理
    imagePickerController.allowsEditing = YES;
    if (buttonIndex == 0) {
        //拍照
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        //相册
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    if (self.index == 1) {
        //传封面...
        self.image = image;
        NSString *width =[NSString stringWithFormat:@"%.f",image.size.width];
        NSString *hight =[NSString stringWithFormat:@"%.f",image.size.height];
        [HKReleaseVideoParam setObject:width key:@"coverImgWidth"];
        [HKReleaseVideoParam setObject:hight key:@"coverImgHeight"];
        [self.tableView reloadData];
    }else {
             [self api_uploadImage:image imageURL:[NSString stringWithFormat:@"image-%@.jpeg",[self stringFromDate:[NSDate date]]]];
        }
}
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}
- (void)api_uploadImage:(UIImage *)image imageURL:(NSString *)imageURL
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    NSString *imageNameAndSuff = [imageURL componentsSeparatedByString:@"/"].lastObject;
    NSString *imageName = [imageNameAndSuff componentsSeparatedByString:@"."].firstObject;
//    NSString *mimeType = [imageNameAndSuff componentsSeparatedByString:@"."].lastObject;
    
    [SVProgressHUD showWithStatus:@"正在上传图片..."];
    [HJNetwork uploadImageURL:[Host stringByAppendingString:get_CityAdvSaveCityAdvPhoto] parameters:dic images:@[image] name:@"imgSrc" fileName:imageName mimeType:@"jpeg" progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
            NSString *imageURL = responseObject[@"data"];
            
            //添加到富文本中去
      NSString * script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", imageURL, imageURL];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"webContent" object:script];
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)dismissController:(UIViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
//header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
//footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGB(241, 241, 241);
        return view;
    }
    return nil;
}
//footer 高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section) {
       return 10.f;
    }
    return 0;
}
////cell 选中处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"发布新游记";
    [self requestLocation];
    [self getItemsFromDB];
    self.boothCount =0;
    [self.tableView reloadData];
}
#pragma mark 从数据库加载数据
- (void)getItemsFromDB {
    //从本地数据读取
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HKBaseViewModel initDataSuccess:^(BOOL isSave, HKInitializationRespone *respone) {
            
            for (HK_BaseAllCategorys * list in respone.data.allCategorys) {
                if (list.type.integerValue ==3) {
                     [self.mediaCaterArray addObject:list];
                }
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
        
        });
    });
}
-(void)dealloc {
     [HKReleaseVideoParam clearParam];
}
@end
