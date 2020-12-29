//
//  HK_CardsCertificationViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_CardsCertificationViewController.h"
#import "HK_CertficationFailureViewController.h"
#import "ActionSheetStringPicker.h"
#import "VPImageCropperViewController.h"
#import "ImageTool.h"
#import "NSData+EasyExtend.h"
#import "GTMBase64.h"
#import "HK_UploadImagesModel.h"
#import "HK_NetWork.h"
#import "HK_CertificationProcessingViewController.h"
#import "UrlConst.h"
@interface HK_CardsCertificationViewController () <TTTAttributedLabelDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *scrollContentView;
@property (nonatomic, weak) UIButton *photoBg1;
@property (nonatomic, weak) UIButton *photoBg2;
@property (nonatomic, weak) UILabel *tip3Label;
@property (nonatomic, strong) UIImage *image1;  //第一张图
@property (nonatomic, strong) UIImage *image2;  //第二张图
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) BOOL requestFlag;
@end

@implementation HK_CardsCertificationViewController

- (void)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:ScreenRect];
    self.view = scrollView;
    _scrollView = scrollView;
}

- (UIView *)scrollContentView {
    if (!_scrollContentView) {
        UIView *view = [UIView new];
        [self.view addSubview:view];
        _scrollContentView = view;
        [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
            make.width.equalTo(self.view);
        }];
    }
    return _scrollContentView;
}

#pragma mark 设置 nav
- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

//导航右侧按钮点击
- (void)nextStep {
    if (self.image1 == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传身份证照片"];
    } else if (self.image2 == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传营业执照"];
    } else {
        if (self.requestFlag) {
            [self uploadData];
        }
        self.requestFlag = NO;
    }
}

#pragma mark 接口
//上传接口组装数据
- (void)uploadData {
    [self.dataDict setObject:HKUSERLOGINID forKey:@"loginUid"];
    [self Business_Requestdic:self.dataDict];
    
}


-(void)Business_Requestdic:(NSDictionary*)dic
{
    [HK_NetWork uploadImageURL:[Host stringByAppendingString:get_UpdateAuthenticationEnterpriseInfo] parameters:dic images:self.images mimeType:nil progress:^(NSProgress *progress) {
        
    } callback:^(id responseObject, NSError *error) {
        if (!error) {
            HK_CertificationProcessingViewController *vc = [HK_CertificationProcessingViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
             [SVProgressHUD showInfoWithStatus:@"失败"];
        }
         self.requestFlag = YES;
    }];
    
}

//-(void)Business_Request_State:(BusinessRequestType)type statusCode:(NSInteger)statusCode
//{
//    if(BusinessRequestType_get_updateAuthenticationEnterpriseInfo == type)
//    {
//        HK_UpdateAuthenticationEnterpriseInfo *data = [ViewModelLocator sharedModelLocator].updateAuthenticationEnterpriseInfo;
//        if (RequsetStatusCodeSuccess == statusCode)
//        {
//            if (data.code) {
//                if([data.code integerValue] == 1) {
//
//                }else if ([data.code integerValue] == 0) {
//                     [SVProgressHUD showInfoWithStatus:data.msg];
//                }
//            } else {
//
//            }
//
//        }
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"企业认证";
    
    [self setUpUI];
    
    [self setNavItem];
    
    self.requestFlag = YES;
    
   // NSLog(@"%@",self.dataDict);

}

//设置 UI
#define MainColor RGB(241, 241, 241)

- (void)setUpUI {
    self.view.backgroundColor = [UIColor whiteColor];
    //顶部提示
    UIView *topBg = [HKComponentFactory viewWithFrame:CGRectZero supperView:self.scrollContentView];
    [topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.scrollContentView);
        make.height.mas_equalTo(25);
    }];
    topBg.backgroundColor = MainColor;
    UILabel *topTipLabel = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(153, 153, 153) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCRegular size:12.f] text:@"2/2 企业身份材料审核" supperView:topBg];
    [topBg addSubview:topTipLabel];
    [topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(topBg);
    }];
    
    //手持身份证 Label
    UILabel *tip1Label = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(51, 51, 51) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCRegular size:15.f] text:@"手持身份证" supperView:self.scrollContentView];
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(topBg.mas_bottom).offset(18);
    }];
    
    UIButton *photoBg1 = [HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectZero taget:self action:@selector(uploadPhoto:) supperView:self.scrollContentView];
    photoBg1.tag = 10001;
    photoBg1.backgroundColor = [UIColor blueColor];
    
    [[photoBg1 imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [photoBg1 setBackgroundImage:[UIImage imageNamed:@"tjtup"] forState:UIControlStateNormal];
    [photoBg1 setAdjustsImageWhenHighlighted:NO];
    CGFloat width = kScreenWidth-30;
    CGFloat height = 180*width/345;
    [photoBg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollContentView).offset(15);
        make.width.mas_equalTo(kScreenWidth-30);
        make.height.mas_equalTo(height);
        make.top.mas_equalTo(tip1Label.mas_bottom).offset(19);
    }];
    self.photoBg1 = photoBg1;
    
    
    //上传营业执照
    UILabel *tip2Label = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(51, 51, 51) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCRegular size:15.f] text:@"上传营业执照" supperView:self.scrollContentView];
    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tip1Label);
        make.top.mas_equalTo(photoBg1.mas_bottom).offset(26);
    }];
    
    UIButton *photoBg2 = [HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectZero taget:self action:@selector(uploadPhoto:) supperView:self.scrollContentView];
    photoBg2.tag = 10002;
    [[photoBg2 imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [photoBg2 setBackgroundImage:[UIImage imageNamed:@"tjtup"] forState:UIControlStateNormal];
    [photoBg2 setAdjustsImageWhenHighlighted:NO];
    [photoBg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(photoBg1);
        make.top.mas_equalTo(tip2Label.mas_bottom).offset(19);
    }];
    self.photoBg2 = photoBg2;
    
    UILabel *tip3Label = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(153, 153, 153) textAlignment:NSTextAlignmentCenter font:[UIFont fontWithName:PingFangSCRegular size:10.f] text:@"确保公司全称与提交认证／审核公司一致；如为复印件、黑白扫描件，需加盖公司公章；不支持屏幕截图、翻拍图片、电子版营业执照;" supperView:photoBg2];
    //tip3Label.backgroundColor = [UIColor greenColor];
    tip3Label.numberOfLines = 0;
    tip3Label.lineBreakMode = NSLineBreakByWordWrapping;
    [tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(photoBg2);
        make.width.mas_equalTo(photoBg2.mas_width).offset(-40);
        make.bottom.mas_equalTo(photoBg2).offset(-18);
    }];
    self.tip3Label = tip3Label;

    //添加富文本
    TTTAttributedLabel *tip4Label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    tip4Label.delegate = self;
    tip4Label.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"提交认证代表你已同意 企业认证协议 "];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"hk://"
                             range:[[attributedString string] rangeOfString:@" 企业认证协议 "]];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:PingFangSCRegular size:10.f] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(0, attributedString.length)];
    //对齐方式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    tip4Label.linkAttributes = @{NSForegroundColorAttributeName: RGB(64, 144, 247),
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    tip4Label.text = attributedString;
    //tip4Label.numberOfLines = 0;
    [self.scrollContentView addSubview:tip4Label];
    
    [tip4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.scrollContentView);
        make.top.mas_equalTo(photoBg2.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
    
    //设置过渡 view 的底部约束
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tip4Label.mas_bottom).offset(30);
    }];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    DLog(@"%@",url.scheme);
    if ([url.scheme isEqualToString:@"hk"]) {
        [SVProgressHUD showInfoWithStatus:@"协议"];
    }
}

//选择图片
#define image1Tag 10001
#define image2Tag 10002
- (void)uploadPhoto:(UIButton *)button {
    self.flag = button.tag;
    [self showCameraSheet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        // 裁剪
        [self saveImage:portraitImg];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存图片
- (void)saveImage:(UIImage *)image {
    //保存图片到沙盒
    UIImage *midImage = [ImageTool imageWithImageSimple:image scaledToWidth:200.0f];
    NSData * value = [[HK_Tool GetTimeStamp] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"%@",[value MD5String]]];
//    [ImageTool saveImage:midImage WithName:imageName];
//    NSString * localPath = [NSString stringWithFormat:@"%@/%@",[FCFileManager pathForDocumentsDirectory],imageName];
    if (self.flag == image1Tag) {
        self.image1 = midImage;
        //封装上传图片数据
        HK_UploadImagesModel *model = [[HK_UploadImagesModel alloc] init];
        model.image = midImage;
        model.fileName = imageName;
        model.uploadKey = @"idCardImg";
        [self.images setObject:model forKey:model.uploadKey];
        //更新 UI
        [self.photoBg1 setImage:midImage forState:UIControlStateNormal];
        [self.photoBg1 setImage:midImage forState:UIControlStateHighlighted];
    } else if (self.flag == image2Tag) {
        self.image2 = midImage;
        self.tip3Label.hidden = YES;
        //封装上传图片数据
        HK_UploadImagesModel *model = [[HK_UploadImagesModel alloc] init];
        model.image = midImage;
        model.fileName = imageName;
        model.uploadKey = @"businessLicense";
        [self.images setObject:model forKey:model.uploadKey];
        //更新 UI
        [self.photoBg2 setImage:midImage forState:UIControlStateNormal];
        [self.photoBg2 setImage:midImage forState:UIControlStateHighlighted];
    }
}


-(void)showPickViewController:(UIImagePickerController *)viewController;
{
    [self presentViewController:viewController animated:YES completion:nil];
}


@end
