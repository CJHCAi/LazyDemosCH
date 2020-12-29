//
//  HKRealNameAuthViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRealNameAuthViewController.h"
#import "HKRealNamePhotoCell.h"
#import "ImageUtil.h"
#import "HK_SingleColumnPickerView.h"
#import "HKSetTool.h"
#import "HKRealAuthResultVc.h"
#import "HK_NetWork.h"
#import "HKDateTool.h"
@interface HKRealNameAuthViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIImage * _frontImage;
    UIImage * _backImage;
    NSInteger _row;
}
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)UITextField *realNameTF;
@property (nonatomic, strong)UITextField *numberTF;
@property (nonatomic, strong)NSMutableArray * imageArr;
@property (nonatomic, strong)UIView*footerV;

@end

@implementation HKRealNameAuthViewController

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
    [AppUtils setPopHidenNavBarForFirstPageVc:self];
    
}
-(NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr =[[NSMutableArray alloc] init];
    }
    return _imageArr;
}
-(UIView *)footerV {
    if (!_footerV) {
        _footerV =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
        _footerV.backgroundColor =[UIColor whiteColor];
        UILabel * message =[[UILabel alloc] initWithFrame:CGRectMake(0,30,kScreenWidth,10)];
        [_footerV addSubview:message];
        [AppUtils getConfigueLabel:message font:PingFangSCRegular10 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"666666"] text:@""];
        NSString * text =@"提交认证代表你已同意 实名认证协议";
        NSMutableAttributedString *art =[[NSMutableAttributedString alloc] initWithString:text];
        [art addAttribute:NSForegroundColorAttributeName value:RGB(42,107,242) range:NSMakeRange(11,6)];
        message.attributedText = art;
    }
    return _footerV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"实名认证";
    self.showCustomerLeftItem = YES;
    [AppUtils addBarButton:self title:@"提交" action:@selector(upload) position:PositionTypeRight];
    [self.view addSubview:self.tableView];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStyleGrouped
                     ];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator =NO;
        [_tableView registerClass:[HKRealNamePhotoCell class] forCellReuseIdentifier:@"realName"];
        _tableView.tableFooterView = self.footerV;
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return 2;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * v =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
    v.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    return  v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section) {
        return  210;
    }
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"One"];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"One"];
        }
        cell.textLabel.font = [UIFont fontWithName:PingFangSCRegular size:15.f];
        cell.textLabel.textColor = RGB(51, 51, 51);
        
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0,49,kScreenWidth,1)];
        line.backgroundColor  =RGB(235,235,235);
        [cell.contentView addSubview:line];
        
        switch (indexPath.row) {
            case  0:
            {
                cell.textLabel.text = @"证件类型";
                 cell.accessoryType   =UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.font =PingFangSCRegular13;
                cell.detailTextLabel.textColor =[UIColor colorFromHexString:@"666666"];
                cell.detailTextLabel.text =@"身份证";
            }
                break;
           case  1:
            {
                cell.textLabel.text = @"真实姓名";
                cell.accessoryType =  UITableViewCellAccessoryNone;
                if (!self.realNameTF) {
                    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectZero];
                    tf.delegate = self;
                    tf.font = [UIFont fontWithName:PingFangSCRegular size:14.f];
                    tf.textColor = RGB(102, 102, 102);
                    tf.textAlignment = NSTextAlignmentRight;
                    tf.placeholder =@"请填写";
                    [cell.contentView addSubview:tf];
                    self.realNameTF = tf;
                    [_realNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(230);
                        make.right.mas_equalTo(cell.mas_right).offset(-16);
                        make.centerY.mas_equalTo(cell);
                        make.height.mas_equalTo(cell);
                    }];
                }
            }break;
            case 2:
            {
                cell.textLabel.text = @"证件号码";
                cell.accessoryType =  UITableViewCellAccessoryNone;
                if (!self.numberTF) {
                    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectZero];
                    tf.delegate = self;
                    tf.font = [UIFont fontWithName:PingFangSCRegular size:14.f];
                    tf.textColor = RGB(102, 102, 102);
                    tf.textAlignment = NSTextAlignmentRight;
                    tf.placeholder =@"请填写";
                    [cell.contentView addSubview:tf];
                    self.numberTF = tf;
                    [_numberTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(230);
                        make.right.mas_equalTo(cell.mas_right).offset(-16);
                        make.centerY.mas_equalTo(cell);
                        make.height.mas_equalTo(cell);
                    }];
                }
            }break;
            default:
                break;
        }
    
        return cell;
    }
    HKRealNamePhotoCell * photoCell =[tableView dequeueReusableCellWithIdentifier:@"realName" forIndexPath:indexPath];
    if (indexPath.row) {
        photoCell.titleLabel.text = @"证件反面照";
        if (_backImage) {
            photoCell.coverImageV.image = _backImage;
            photoCell.messageLabel.hidden =YES;
            photoCell.centerImageV.hidden =YES;
        }
    }else {
        photoCell.titleLabel.text = @"手持证件照";
        if (_frontImage) {
            photoCell.coverImageV.image = _frontImage;
            photoCell.messageLabel.hidden =YES;
            photoCell.centerImageV.hidden =YES;
        }
    }
    return  photoCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0 && indexPath.row == 0) {
       //选证件类型..
        HK_SingleColumnPickerView *picker = [HK_SingleColumnPickerView showWithData:@[@"身份证"] callBackBlock:^(NSString *value, NSInteger selectedIndex) {
            
            UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = value;
        }];
        [self.navigationController.view addSubview:picker];
        [picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.navigationController.view);
        }];
    }
    if (indexPath.section) {
         _row = indexPath.row;
        //点击每一个弹出是否删除按钮
        UIAlertController * alertPicker =[UIAlertController alertControllerWithTitle:@"选择图片" message:@"请上传您的资质资料" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction * defineAc =[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhoto];
        }];
        [alertPicker addAction:defineAc];
        UIAlertAction *cancleAc =[UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pickImage];
            
        }];
        [alertPicker addAction:cancleAc];
        [self presentViewController:alertPicker animated:YES completion:nil];
    }
}
//直接拍照
-(void)takePhoto {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [AppUtils openImagePicker:self sourceType:UIImagePickerControllerSourceTypeCamera allowsEditing:YES];
    }];
}
//从相册里找
- (void)pickImage{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [AppUtils openImagePicker:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:YES];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *img=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    img = [ImageUtil fixImageOrientation:img];
    if (_row) {
        _backImage = img;
    }else {
        _frontImage = img;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}
//提交
-(void)upload {
    if (!_realNameTF.text.length) {
        [EasyShowTextView showText:@"请填写真实姓名"];
        return;
    }
    if (!_numberTF.text.length) {
        [EasyShowTextView showText:@"请输入有效身份证号"];
        return ;
    }
    if (!_backImage ||!_frontImage) {
        [EasyShowTextView showText:@"请上传图片资料"];
        return;
    }
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:_realNameTF.text forKey:@"name"];
    [params setValue:_numberTF.text forKey:@"idNum"];
    [params setValue:HKUSERLOGINID forKey:kloginUid];
    [params setValue:@"1" forKey:@"idType"];
    NSMutableDictionary * images =[[NSMutableDictionary alloc] init];
    HK_UploadImagesModel * modelBack =[[HK_UploadImagesModel alloc] init];
    modelBack.uploadKey =@"idBack";
    modelBack.image =_backImage;
    [images setObject:modelBack forKey:modelBack.uploadKey];
    modelBack.fileName =[HKDateTool getCurrentIMServerTime13];
    HK_UploadImagesModel *modelFont =[[HK_UploadImagesModel alloc] init];
    modelFont.uploadKey =@"idFront";
    modelFont.image =_frontImage;
    modelFont.fileName =[HKDateTool getCurrentIMServerTime13];
    [images setObject:modelFont forKey:modelFont.uploadKey];
    [Toast loading:self.view text:@"提交资料中"];
    [HK_NetWork uploadImageURL:[NSString stringWithFormat:@"%@%@",Host,get_userApplyRealName] parameters:params images:images mimeType:nil progress:^(NSProgress *progress) {
    } callback:^(id responseObject, NSError *error) {
        [Toast loaded];
        if (error) {
           [EasyShowTextView showText:@"资料上传失败"];
        }else {
            if ([[responseObject objectForKey:@"code"] integerValue]==0) {

                HKRealAuthResultVc * vc =[[HKRealAuthResultVc alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [EasyShowTextView showText:[responseObject objectForKey:@"msg"]];
            }
        }
       }
     ];
}
@end
