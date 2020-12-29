//
//  HK_ChangeAddressView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_ChangeAddressView.h"
#import "CustomUITextField.h"
#import "XHTextFieldScrollView.h"
#import "BGSTextViewWithPlaceholder.h"
#import "SCNSString+Utils.h"
#import "AMBCircularButton.h"
#import "VPImageCropperViewController.h"
#import "ImageTool.h"
#import "NSData+EasyExtend.h"
#import "GTMBase64.h"
#define DestailRowH 74
#define IdentityRowH 110
#import "HKBaseCitySelectorViewController.h"
#import "ChinaArea.h"
#import "HK_BaseRequest.h"
@interface HK_ChangeAddressView ()<UITextFieldDelegate,UIPickerViewDelegate ,UIPickerViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger row1;
    NSInteger row2;
    NSInteger row3;
    UITableView* myTableViewNew;
    UIImageView * nineImage;
    UIImageView * tenImage2;
    BOOL isPositive;
    BOOL isPositiveState;
    BOOL isNegativeState;
    UIImage *imagePositive;
    UIImage *imageNegative;
    
    UIImageView * sevenImage;
    UIImageView * eightImage;
    
    NSString *card_front;
    NSString *card_back;
    
    NSString *username;
    NSString *phoneNum;
    NSString *postcode;
    NSString *contenttext;
    NSString *identity;
    
    NSString *address_Id;
    
    NSString *province;
    NSString *city;
    NSString *region;
    
    NSString *province_Id;
    NSString *city_Id;
    NSString *region_Id;
    UIButton * _rightB1Two1;
    BOOL _isDefault;
}

@property (nonatomic ,strong) UIPickerView *cityPicker;
//@property (nonatomic, strong) XHTextFieldScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollView;
@property (nonatomic, strong) CustomUITextField *usernameTextField;
@property (nonatomic, strong) CustomUITextField *phoneNumTextField;
@property (nonatomic, strong) CustomUITextField *addressNumTextField;
@property (nonatomic, strong) CustomUITextField *identityField;
@property (nonatomic, strong) CustomUITextField *postcodeField;
@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, strong) BGSTextViewWithPlaceholder * contenttextView;
@property (strong, nonatomic) NSString *areaValue;
@property (nonatomic ,strong) UILabel *cityLabel;
@property (nonatomic, strong) AMBCircularButton *identityFront;
@property (nonatomic, strong) AMBCircularButton *identityBehind;
@property (nonatomic, strong) UILabel *lableDestail;

@end

@implementation HK_ChangeAddressView
@synthesize scrollView,usernameTextField,phoneNumTextField,postcodeField,contenttextView,addressNumTextField;

- (NSMutableArray *)textFields {
    if (!_textFields) {
        _textFields = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _textFields;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self addViewNew];
    isPositiveState =YES;
    isNegativeState =YES;

}

-(void)addViewNew
{
    CGRect rect = self.view.bounds;
    if (@available(iOS 11.0, *)) {
        rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-SafeAreaBottomHeight);
    }
    rect.origin.y -=0;
    rect.origin.x = 0;
    rect.size.height-=44;
    rect.size.width = kScreenWidth;
    imagePositive = [[UIImage alloc] init];
    imageNegative = [[UIImage alloc] init];
    
    myTableViewNew = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    myTableViewNew.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableViewNew.dataSource = self;
    myTableViewNew.delegate = self;
    myTableViewNew.scrollEnabled = YES;
    myTableViewNew.tag = 293829382983;
    [myTableViewNew setBackgroundColor:UICOLOR_RGB_Alpha(0Xf1f1f1, 1)];
    [self.view addSubview:myTableViewNew];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = nil;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            //            [self setContentCell1:cell];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 331;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.mj_w, 331)];
    cell.backgroundColor = [UIColor whiteColor];
    //    cell.userInteractionEnabled = YES;
    
    
    
    CGRect rect1 = cell.frame;
    rect1.size.height = 331;
    rect1.size.width = kScreenWidth;
    cell.frame = rect1;
    
    UIImageView * topImage = [UIImageView new];
    topImage.backgroundColor =UICOLOR_RGB_Alpha(0xf1f1f1, 1);
    [cell addSubview:topImage];
    [topImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 10));
    }];
    
    UILabel *lableOne = [UILabel new];
    lableOne.backgroundColor = [UIColor clearColor];
    lableOne.font = [UIFont systemFontOfSize: 15.0];
    lableOne.textAlignment = NSTextAlignmentCenter;
    lableOne.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    lableOne.text = @"收货人";
    [cell addSubview:lableOne];
    [lableOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(10);
        make.left.equalTo(cell).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(74, 50));
    }];
    
    UILabel *lableTwo = [UILabel new];
    lableTwo.backgroundColor = [UIColor clearColor];
    lableTwo.font = [UIFont systemFontOfSize: 15.0];
    lableTwo.textAlignment = NSTextAlignmentCenter;
    lableTwo.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    lableTwo.text = @"手机号";
    [cell addSubview:lableTwo];
    [lableTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(50+10);
        make.left.equalTo(cell).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(74, 50));
    }];
    
    UILabel *lableThree = [UILabel new];
    lableThree.backgroundColor = [UIColor clearColor];
    lableThree.font = [UIFont systemFontOfSize: 15.0];
    lableThree.textAlignment = NSTextAlignmentLeft;
    lableThree.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    lableThree.text = @"收货时间     周一至周五发货";
    [cell addSubview:lableThree];
    [lableThree mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(100+10);
        make.left.equalTo(cell).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-30, 50));
    }];
    
    UIImageView * oneImage = [UIImageView new];
    oneImage.backgroundColor =UICOLOR_RGB_Alpha(0xf1f1f1, 1);
    [cell addSubview:oneImage];
    [oneImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lableThree.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 10));
    }];
    
    UILabel *lableFour = [UILabel new];
    lableFour.backgroundColor = [UIColor clearColor];
    lableFour.font = [UIFont systemFontOfSize: 15.0];
    lableFour.textAlignment = NSTextAlignmentCenter;
    lableFour.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    lableFour.text = @"所在地区";
    [cell addSubview:lableFour];
    [lableFour mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneImage.mas_bottom).with.offset(0);
        make.left.equalTo(cell).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(89, 50));
    }];
    
    UILabel *lableFive = [UILabel new];
    lableFive.backgroundColor = [UIColor clearColor];
    lableFive.font = [UIFont systemFontOfSize: 15.0];
    lableFive.textAlignment = NSTextAlignmentCenter;
    lableFive.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    lableFive.text = @"详细地址";
    [cell addSubview:lableFive];
    [lableFive mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lableFour.mas_bottom).with.offset(0);
        make.left.equalTo(cell).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(89, 50));
    }];
    
    UIImageView * twoImage = [UIImageView new];
    twoImage.backgroundColor =UICOLOR_RGB_Alpha(0xf1f1f1, 1);
    [cell addSubview:twoImage];
    [twoImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lableFive.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 10));
    }];
    
    
    
    
    UIButton *rightB1Two1= [UIButton new];
    _rightB1Two1 = rightB1Two1;
    rightB1Two1.backgroundColor = [UIColor clearColor];
    [rightB1Two1 setTitle:@"" forState:UIControlStateNormal];
    [rightB1Two1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightB1Two1 addTarget:self action:@selector(gotoRankingsView) forControlEvents:UIControlEventTouchUpInside];
    if (_isDefault) {
          [rightB1Two1 setBackgroundImage:[UIImage imageNamed:@"limit_red"] forState:UIControlStateNormal];
    }else {
           [rightB1Two1 setBackgroundImage:[UIImage imageNamed:@"limit_gray"] forState:UIControlStateNormal];
    }
    rightB1Two1.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [rightB1Two1.layer setCornerRadius:0];
    rightB1Two1.titleLabel.textColor = [UIColor lightGrayColor];
    [cell addSubview:rightB1Two1];
    [rightB1Two1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoImage.mas_bottom).with.offset(16);
        make.left.equalTo(cell).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(18,18));
    }];
    
    
    UILabel *lableSix = [UILabel new];
    lableSix.backgroundColor = [UIColor clearColor];
    lableSix.font = [UIFont systemFontOfSize: 15.0];
    lableSix.textAlignment = NSTextAlignmentCenter;
    lableSix.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    lableSix.text = @"设为默认";
    [cell addSubview:lableSix];
    [lableSix mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoImage.mas_bottom).with.offset(0);
        make.left.equalTo(rightB1Two1.mas_right).with.offset(11);
        make.size.mas_equalTo(CGSizeMake(89, 50));
    }];
    
    usernameTextField = [[CustomUITextField alloc] initWithFrame:CGRectMake(74, 10, kScreenWidth-40, 50)];
    usernameTextField.placeholder = @"请输入收货人真实姓名";
//    if ([username length] > 0) {
//       usernameTextField.placeholder = @"";
//    }
    usernameTextField.backgroundColor = [UIColor clearColor];
    usernameTextField.font = [UIFont systemFontOfSize:16];
    usernameTextField.text = username;
    [usernameTextField setValue:UICOLOR_RGB_Alpha(0xcccccc, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [usernameTextField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    usernameTextField.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    //    usernameTextField.delegate = self;
    [cell addSubview:usernameTextField];
    
    phoneNumTextField = [[CustomUITextField alloc] initWithFrame:CGRectMake(74, 50+10, kScreenWidth-40, 50)];
    phoneNumTextField.placeholder = @"请输入收货人手机号";
    phoneNumTextField.text = phoneNum;
    phoneNumTextField.backgroundColor = [UIColor clearColor];
    phoneNumTextField.font = [UIFont systemFontOfSize:16];
    [phoneNumTextField setValue:UICOLOR_RGB_Alpha(0xcccccc, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [phoneNumTextField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    phoneNumTextField.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    //    phoneNumTextField.delegate = self;
    [cell addSubview:phoneNumTextField];
    
    postcodeField = [[CustomUITextField alloc] initWithFrame:CGRectMake(12, 50+50, kScreenWidth-40, 50)];
    postcodeField.placeholder = @"邮编";
    postcodeField.text = postcode;
    postcodeField.backgroundColor = [UIColor clearColor];
    postcodeField.font = [UIFont systemFontOfSize:16];
    [postcodeField setValue:UICOLOR_RGB_Alpha(0x999999, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [postcodeField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    postcodeField.textColor = UICOLOR_RGB_Alpha(0x1a1a1a, 1);
    postcodeField.keyboardType = UIKeyboardTypeNumberPad;
    //    postcodeField.delegate = self;
    [cell addSubview:postcodeField];
    
    postcodeField.hidden = YES;
    
    [usernameTextField setFieldType:kXHOtherField];
    [self.textFields addObject:usernameTextField];
    
    [phoneNumTextField setFieldType:kXHOtherField];
    [self.textFields addObject:phoneNumTextField];
    
    [postcodeField setFieldType:kXHOtherField];
    [self.textFields addObject:postcodeField];
    
    
    CGRect rect = self.view.frame;
    rect.origin.y = 100+50+50+10+10;
    rect.origin.x = 89;
    rect.size.width-=89;
    rect.size.height = 50;
    contenttextView = [[BGSTextViewWithPlaceholder alloc] initWithFrame:rect];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"请输入详细收货地址"];
    if ([contenttext length] > 0) {
        str = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    [contenttextView setStrPlaceholder:str];
    contenttextView.backgroundColor = [UIColor clearColor];
    contenttextView.font = [UIFont systemFontOfSize:16];
    contenttextView.text = contenttext;
    //    [self setAreaValue:nil];
    [cell addSubview:contenttextView];
    [self.textFields addObject:contenttextView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
    
    UIImageView * onLneImage = [UIImageView new];
    onLneImage.backgroundColor =UICOLOR_RGB_Alpha(0xe2e2e2, 1);
    [cell addSubview:onLneImage];
    [onLneImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(49.5+10);
        make.left.equalTo(cell).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-15, 0.5));
    }];
    
    UIImageView * twoImage1 = [UIImageView new];
    twoImage1.backgroundColor =UICOLOR_RGB_Alpha(0xe2e2e2, 1);
    [cell addSubview:twoImage1];
    [twoImage1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(99.5+10);
        make.left.equalTo(cell).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-15, 0.5));
    }];
    
    UIImageView * tenImage = [UIImageView new];
    tenImage.backgroundColor =UICOLOR_RGB_Alpha(0xe2e2e2, 1);
    [cell addSubview:tenImage];
    [tenImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell).with.offset(220-0.5);
        make.left.equalTo(cell).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-15, 0.5));
    }];
    addressNumTextField = [[CustomUITextField alloc] initWithFrame:CGRectMake(89, 100+50+10+10, self.view.bounds.size.width-89, 50)];
    addressNumTextField.placeholder = @"所在地区";
    [addressNumTextField setValue:UICOLOR_RGB_Alpha(0x333333, 1) forKeyPath:@"_placeholderLabel.textColor"];
    addressNumTextField.backgroundColor = [UIColor clearColor];
    [addressNumTextField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    addressNumTextField.font = [UIFont systemFontOfSize:15];
    addressNumTextField.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    addressNumTextField.delegate = self;
    
    
    NSMutableString *address1 = [[NSMutableString alloc] init];
    if ([province length] >0  &&[province isKindOfClass:[NSString class] ]) {
        // 省
        NSString *string1 = [NSString stringWithFormat:@"%@",province];
        [address1 appendString:string1];
    }
    if ([city length] >0  &&[city isKindOfClass:[NSString class] ]) {
        // 市
        NSString *string2 = [NSString stringWithFormat:@"%@",city];
        [address1 appendString:string2];
    }
    if ([region length] >0  &&[region isKindOfClass:[NSString class] ]) {
        // 区    z
        NSString *string3 = [NSString stringWithFormat:@"%@",region];
        [address1 appendString:string3];
    }
    
    
    
    if ([address1 length] >0  &&[address1 isKindOfClass:[NSMutableString class] ]) {
        addressNumTextField.text= address1;
    }
    
    [cell addSubview:addressNumTextField];
    
    
    [addressNumTextField setFieldType:kXHOtherField];
    [self.textFields addObject:addressNumTextField];
    
    return cell;
}
//更改地址的默认状态
-(void)gotoRankingsView
{
    _isDefault = !_isDefault;
    if (_isDefault) {
         [_rightB1Two1 setBackgroundImage:[UIImage imageNamed:@"limit_red"] forState:UIControlStateNormal];
    }else {
        [_rightB1Two1 setBackgroundImage:[UIImage imageNamed:@"limit_gray"] forState:UIControlStateNormal];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            //            [self showCameraSheet];
            break;
            
        default:
            break;
    }
}
-(void)showPositive
{
    isPositive = YES;
    [self showCameraSheet];
}

-(void)showNegative
{
    isPositive = NO;
    [self showCameraSheet];
}

-(void)initNav
{
    self.title = @"修改收货地址";
    if (@available(iOS 11.0, *)) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBtnPressed:) image:[UIImage imageNamed:@"selfMediaClass_back"]];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBtnPressed:) title:@"保存" font:[UIFont systemFontOfSize:16] titleColor:[UIColor blackColor] highlightedColor:[UIColor blackColor] titleEdgeInsets:UIEdgeInsetsZero];
    }else{
        
        UIButton *backButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        /**
         *  设置frame只能控制按钮的大小
         */
        backButton.frame= CGRectMake(0, 0, 62, 36);
        [backButton setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -5;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
        
        
        UIButton *backButton1  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        /**
         *  设置frame只能控制按钮的大小
         */
        backButton1.frame= CGRectMake(0, 0, 62, 36);
        [backButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [backButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [backButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton1 setTitle:@"保存" forState:UIControlStateNormal];
        [backButton1 addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        backButton1.titleLabel.font = [UIFont systemFontOfSize:16];
        UIBarButtonItem *btn_right1 = [[UIBarButtonItem alloc] initWithCustomView:backButton1];
        UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer1.width = -5;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer1, btn_right1, nil];
    }
}

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
        
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f+(self.view.frame.size.width/85.6*54)/2, self.view.frame.size.width, self.view.frame.size.width/85.6*54) limitScaleRatio:10];
        
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

- (void)saveImage:(UIImage *)image {
    
    UIImage *midImage = [ImageTool imageWithImageSimple:image scaledToWidth:100.0f];
    
    NSData * value = [[NSData alloc] init];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"%@",[value MD5String]]];
    [ImageTool saveImage:midImage WithName:imageName];
    NSString * localPath = [NSString stringWithFormat:@"%@/%@",[FCFileManager pathForDocumentsDirectory],imageName];
    [self callBackPath:localPath];
    if (isPositive == YES) {
        imagePositive = midImage;
        nineImage.hidden = YES;
        isPositiveState = NO;
    }
    else
    {
        imageNegative = midImage;
        tenImage2.hidden = YES;
        isNegativeState = NO;
    }
    username = usernameTextField.text;
    contenttext = contenttextView.text;
    phoneNum = phoneNumTextField.text;
    identity = _identityField.text;
    postcode = postcodeField.text;
    [myTableViewNew reloadData];
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

-(void)callBackPath:(NSString *)localPath;
{
    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
    
    NSData *dataObj = UIImageJPEGRepresentation(image, 1.0);
    
    NSData* body = nil;
    body = [GTMBase64 encodeData:dataObj];
    
    NSString * str = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    if (isPositive == YES) {
        card_front = str;
        
        //        NSString * stringSeven = str;
        //        NSData* body = [stringSeven dataUsingEncoding:NSUTF8StringEncoding];
        //        NSData *body1 = [GTMBase64 decodeData:body];
        //        imagePositive = [UIImage imageWithData:body1];
    }
    else
    {
        card_back = str;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * datadic = [[NSMutableDictionary alloc] init];
    
    //    [[ViewModelLocator Instance] getUserinfo];
    
    //    [datadic setObject: [ViewModelLocator Instance].rootuserModel.useruid forKey:@"uid"];
    [datadic setObject:str forKey:@"icon"];
    
    
    [dic setObject:datadic forKey:@"id_card_front"];
    [dic setObject:datadic forKey:@"id_card_back"];
    
    //    [myTableViewNew reloadData];
    //    [self Business_Request:BusinessRequestType_Update_user_iconRequest dic:dic cache:YES];
}



-(void)buttonClick:(id)sender
{
    //2.0统计//
    //    [HK_Tool event:@"clk_nadr_#madr" label:@"click_newaddress_#manageaddress"];
    
    [self rightBtnPressed:sender];
    
    
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [usernameTextField resignFirstResponder];
    [phoneNumTextField resignFirstResponder];
    [contenttextView resignFirstResponder];
    self.cityPicker.hidden = YES;
    
    [self.view endEditing:YES];
}

-(void)pressBut:(id)sender{
    NSInteger tag=((UIView *)sender).tag;
    DLog(@"%ld",(long)tag);
    if (tag == 2) {
        [self addPicker];
    }
}

-(void)addPicker
{
    [usernameTextField resignFirstResponder];
    [phoneNumTextField resignFirstResponder];
    [contenttextView resignFirstResponder];
    row1 = 0;
    row2 = 0;
    row3 = 0;
    if (!self.cityPicker) {
        self.cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight-180  , kScreenWidth, 180)];
        self.cityPicker.tag = 0;
        self.cityPicker.delegate = self;
        self.cityPicker.dataSource = self;
        self.cityPicker.showsSelectionIndicator = YES;
        [self.view addSubview:self.cityPicker];
        self.cityPicker.backgroundColor = [UIColor grayColor];
    }
    else
    {
        self.cityPicker.hidden = NO;
    }
}

#pragma mark - handler

- (CustomUITextField *)validateInputInView:(UIView*)view
{
    CustomUITextField *customUITextField = nil;
    for(UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]])
            return [self validateInputInView:subView];
        
        if ([subView isKindOfClass:[CustomUITextField class]]) {
            if (![(CustomUITextField*)subView validate]) {
                customUITextField = (CustomUITextField*)subView;
                return customUITextField;
            }
        }
    }
    return customUITextField;
}

-(void)leftBtnPressed:(id)sender
{
#pragma mark--**点击“后退”按钮
    //2.0统计//
    //    [HK_Tool event:@"clk_back_#nadr" label:@"click_back_#newaddress"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnPressed:(id)sender
{
    if (contenttextView.text.length<=0) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"内容不能为空"
         ];
        return;
    }
    else if (usernameTextField.text.length<=0) {
         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"收货人不能为空"
         ];
        return;
    }
    else if (phoneNumTextField.text.length<=0) {
         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"
         ];
        return;
    }
    else if (addressNumTextField.text.length<=0) {
         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"请选择省，市，区"
         ];
        return;
    }
    else if (![AppUtils verifyPhoneNumbers:phoneNumTextField.text])
    {
         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"请输入合法手机号"
         ];
        return;
    }
    else if (contenttextView.text.length>=250)
    {
         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"请输入正确的地址"
         ];
        return;
    }
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if (address_Id.length > 0) {
        [dic setObject:address_Id forKey:@"addressId"];
    }
    [dic setObject:usernameTextField.text forKey:@"realname"];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    [dic setObject:usernameTextField.text forKey:@"consignee"];
    [dic setObject:phoneNumTextField.text forKey:@"phone"];
    [dic setObject:contenttextView.text forKey:@"address"];
#pragma mark 根据是否选择默认
    if (_isDefault) {
        [dic setObject:@"1" forKey:@"isDefault"];
    }else {
        [dic setObject:@"0" forKey:@"isDefault"];
    }
    if ([province_Id length] > 0) {
        [dic setObject:province_Id forKey:@"provinceId"];
    }
    if ([city_Id length] > 0) {
        [dic setObject:city_Id forKey:@"cityId"];
    }
    if ([region_Id length] > 0) {
        [dic setObject:region_Id forKey:@"areaId"];
    }
    
    //修改收货地址
    [HK_BaseRequest buildPostRequest:get_addUserDeliveryAddress body:dic success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] ==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [EasyShowTextView showText:@"操作失败"];
        }
    } failure:^(NSError * _Nullable error) {
        [EasyShowTextView showText:@"操作失败"];
    }];
    
    
    
}
-(void)addData:(HK_UserDeliveryAddressListModel *)userAddrData
{
    if ([userAddrData.provinceName length] >0  &&[userAddrData.provinceName isKindOfClass:[NSString class] ]) {
        // 省
        province = [NSString stringWithFormat:@"%@",userAddrData.provinceName];
    }
    if ([userAddrData.cityName length] >0  &&[userAddrData.cityName isKindOfClass:[NSString class] ]) {
        // 市
        city = [NSString stringWithFormat:@"%@",userAddrData.cityName];
    }
    if ([userAddrData.areaName length] >0  &&[userAddrData.areaName isKindOfClass:[NSString class] ]) {
        // 区
       region = [NSString stringWithFormat:@"%@",userAddrData.areaName];
    }
    
    //是否为默认或者设置默认与否
#pragma mark 根据是否选择默认
    if (userAddrData.isDefault.integerValue) {
        _isDefault = YES;
        [_rightB1Two1 setBackgroundImage:[UIImage imageNamed:@"limit_red"] forState:UIControlStateNormal];
        
    }else {
        _isDefault = NO;
        [_rightB1Two1 setBackgroundImage:[UIImage imageNamed:@"limit_gray"] forState:UIControlStateNormal];
        
    }
    if ([userAddrData.address length] >0  &&[userAddrData.address isKindOfClass:[NSString class] ]) {
        contenttext = [NSString stringWithFormat:@"%@",userAddrData.address];
    }
    
    postcode = postcodeField.text;
    if (userAddrData.consignee && [userAddrData.consignee length] >0  &&[userAddrData.consignee isKindOfClass:[NSString class] ])
    {
        username = userAddrData.consignee;
    }
    
    if (userAddrData.phone && [userAddrData.phone length] >0  &&[userAddrData.phone isKindOfClass:[NSString class] ])
    {
        phoneNum = userAddrData.phone;
    }
    
    if (userAddrData.addressId && [userAddrData.addressId length] >0  &&[userAddrData.addressId isKindOfClass:[NSString class] ])
    {
        address_Id = userAddrData.addressId;
    }
    //获取市区ID
    if (userAddrData.provinceId && [userAddrData.provinceId length] >0  &&[userAddrData.provinceId isKindOfClass:[NSString class] ])
    {
        province_Id = userAddrData.provinceId;
    }
    if (userAddrData.cityId && [userAddrData.cityId length] >0  &&[userAddrData.cityId isKindOfClass:[NSString class] ])
    {
        city_Id = userAddrData.cityId;
    }
    if (userAddrData.areaId && [userAddrData.areaId length] >0  &&[userAddrData.areaId isKindOfClass:[NSString class] ])
    {
        region_Id = userAddrData.areaId;
    }
}
-(NSString *)cha:(NSString *)str
{
    NSTimeInterval time=[str doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        _areaValue = areaValue;
        self.contenttextView.text = areaValue;
    }
}

#pragma mark - ChinaPlckerViewDelegate
- (void)chinaPlckerViewDelegateChinaModel:(ChinaArea *)chinaModel{
    NSMutableString *str = [[NSMutableString alloc] init];
    // 省
    NSString *string1 = @"";
    if (chinaModel.provinceModel.NAME.length > 0) {
        string1 = [NSString stringWithFormat:@"%@",chinaModel.provinceModel.NAME];
        province_Id = chinaModel.provinceModel.ID;
    }
    // 市
    NSString *string2 = @"";
    if (chinaModel.cityModel.NAME.length > 0) {
        string2 = [NSString stringWithFormat:@"%@",chinaModel.cityModel.NAME];
        city_Id = chinaModel.cityModel.ID;
    }
    // 区
    NSString *string3 =  @"";
    if (chinaModel.areaModel.NAME.length > 0) {
        string3 = [NSString stringWithFormat:@"%@",chinaModel.areaModel.NAME];
        region_Id = chinaModel.areaModel.ID;
    }

    province = string1;
    city = string2;
    region = string3;


    [str appendString:string1];
    [str appendString:string2];
    [str appendString:string3];

    self.addressNumTextField.text = str;
}


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:addressNumTextField]) {
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
    } else {
        self.cityPicker.hidden = YES;
        
    }
    return NO;
}

//返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //    if (pickerView == self.cityPicker) {
    return 2;
    //    }
    //    else
    //        return 1;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}


@end
