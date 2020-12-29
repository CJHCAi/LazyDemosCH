//
//  SettingsViewController.m
//  SportForum
//
//  Created by zyshi on 14-9-12.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIViewController+SportFormu.h"
#import "TRSDialScrollView.h"
#import "ImageEditViewController.h"
#import "CustomMenuViewController.h"
#import "UIImageView+WebCache.h"
#import "AlertManager.h"
#import "MWPhotoBrowser.h"
#import "ZYQAssetPickerController.h"
#import "RecommendViewController.h"
#import "HTAutocompleteTextField.h"
#import "HTAutocompleteManager.h"

#define MAX_PUBLISH_PNG_COUNT 6

@interface SettingsViewController ()  <UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate, MWPhotoBrowserDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@end

@implementation SettingsViewController
{
    UIView * _viewSettings[4];
    CSButton * _btnNext[4];
    CSButton *_btnSelectSex;
    UILabel * _lbSexValue;
    UIImageView * _imgSelectArrow;
    UILabel * _lbWeightValue;
    UILabel * _lbHeightValue;
    UILabel * _lbAgeValue;
    UIImageView * _imgWeight;
    UIImageView * _imgHeight;
    UIImageView * _imgAge;

    UIImageView * _imgHead;
    UITextField * _leNikeName;
    HTAutocompleteTextField * _leRing;
    HTAutocompleteTextField * _leShoes;
    HTAutocompleteTextField * _lePhone;
    UILabel * _lbPicture;
    CSButton * _btnAddPng;
    UILabel * _lbLastSeparate;
    UIView * _viewAddPhoto;
    UIButton * _btnBackMain;
    TRSDialScrollView * _dialView[3];
    ImageEditViewController* _imageEditViewController;
    CustomMenuViewController* _customMenuViewController;
    
    UIView * m_pickerFrame;
    UIPickerView * m_pickerSelect;
    
    UserUpdateInfo * _updateInfo;
    EquipmentInfo * _equipmentInfo;
    NSString * _strProfileImageID;

    NSMutableArray * _imgUrlArray;
    NSMutableArray * _imgViewArray;
    NSMutableArray * _imgBtnArray;
    NSMutableArray * _imgBackFrameArray;
    NSMutableArray *_photos;
    
    BOOL _bPopSetPhotos;
    BOOL _bUpdatePhotos;
    id m_processWindow;
    int _nSelectType;
    
    int _nType;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _updateInfo = [[UserUpdateInfo alloc] init];
        _equipmentInfo = [[EquipmentInfo alloc] init];
        _strProfileImageID = @"";
        _nType = SETTING_TYPE_ALL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _imgUrlArray = [[NSMutableArray alloc]init];
    _imgViewArray = [[NSMutableArray alloc]init];
    _imgBtnArray = [[NSMutableArray alloc]init];
    _imgBackFrameArray = [[NSMutableArray alloc]init];
    _photos = [[NSMutableArray alloc]init];
    _bUpdatePhotos = NO;
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];

    for(int i = 0; i < 4; i++)
    {
        _viewSettings[i] = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_viewSettings[i]];
        _viewSettings[i].hidden = YES;
    }
    _viewSettings[0].hidden = NO;
    [self generateCommonViewInParent:_viewSettings[0] Title:@"编辑个人信息" IsNeedBackBtn:NO];
    [self generateCommonViewInParent:_viewSettings[1] Title:@"体重" IsNeedBackBtn:NO];
    [self generateCommonViewInParent:_viewSettings[2] Title:@"身高" IsNeedBackBtn:NO];
    [self generateCommonViewInParent:_viewSettings[3] Title:@"出生年份" IsNeedBackBtn:NO];
    [self generateCommonViewInParent:_viewSettings[4] Title:@"编辑个人信息" IsNeedBackBtn:NO];
    CSButton * btnBack[4];
    UIImageView *imgView[4];
    UIScrollView * viewBody[4];
    for(int i = 0; i < 4; i++)
    {
        imgView[i] = [[UIImageView alloc]initWithFrame:CGRectMake(7, 27, 37, 37)];
        [imgView[i] setImage:[UIImage imageNamed:@"back-btn"]];
        [_viewSettings[i] addSubview:imgView[i]];
        
        btnBack[i] = [CSButton buttonWithType:UIButtonTypeCustom];
        btnBack[i].frame = CGRectMake(5, 20, 55, 45);
        btnBack[i].backgroundColor = [UIColor clearColor];
        [_viewSettings[i] addSubview:btnBack[i]];
        [_viewSettings[i] bringSubviewToFront:btnBack[i]];
        
        UIView * viewBodyParent = [_viewSettings[i] viewWithTag:GENERATE_VIEW_BODY];
        viewBodyParent.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:254 / 255.0 blue:240 / 255.0 alpha:1.0];
        CGRect rect = viewBodyParent.frame;
        rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
        viewBodyParent.frame = rect;
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBodyParent.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = viewBody[i].bounds;
        maskLayer.path = maskPath.CGPath;
        viewBodyParent.layer.mask = maskLayer;

        viewBody[i] = [[UIScrollView alloc] initWithFrame:viewBodyParent.bounds];
        [viewBodyParent addSubview:viewBody[i]];
        viewBody[i].contentSize = CGSizeMake(viewBodyParent.bounds.size.width, 500);
        viewBody[i].backgroundColor = [UIColor clearColor];
    }
    
    _btnBackMain = btnBack[0];
    UIImage * imgButton = [UIImage imageNamed:@"btn-3-yellow"];
    
    //View1
    _imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(viewBody[0].bounds.size.width / 2 - 35, 10, 70, 70)];
    [_imgHead sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _imgHead.layer.cornerRadius = 8.0;
    _imgHead.clipsToBounds = YES;
    [viewBody[0] addSubview:_imgHead];
    
    UIImageView * imgCamera = [[UIImageView alloc] initWithFrame:CGRectMake(_imgHead.frame.origin.x + 50, 50, 33, 33)];
    imgCamera.image = [UIImage imageNamed:@"camera"];
    [viewBody[0] addSubview:imgCamera];
    
    CSButton * btnCamera = [CSButton buttonWithType:UIButtonTypeCustom];
    btnCamera.frame = CGRectMake(_imgHead.frame.origin.x, _imgHead.frame.origin.y, 90, 90);
    [viewBody[0] addSubview:btnCamera];
    
    UILabel * lbSeparate1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, viewBody[0].frame.size.width, 1)];
    lbSeparate1.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewBody[0] addSubview:lbSeparate1];
    
    UILabel * lbNikeName = [[UILabel alloc] initWithFrame:CGRectMake(10, 98, 70, 25)];
    lbNikeName.backgroundColor = [UIColor clearColor];
    lbNikeName.text = @"昵称：";
    lbNikeName.font = [UIFont boldSystemFontOfSize:16];
    lbNikeName.textAlignment = NSTextAlignmentLeft;
    [viewBody[0] addSubview:lbNikeName];
    
    _leNikeName = [[UITextField alloc] initWithFrame:CGRectMake(95, 98, viewBody[0].bounds.size.width - 110, 25)];
    _leNikeName.font = [UIFont boldSystemFontOfSize:12];
    _leNikeName.text = userInfo.nikename;
    _leNikeName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _leNikeName.backgroundColor = [UIColor whiteColor];
    _leNikeName.layer.borderColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222 / 255.0 alpha:1.0].CGColor;
    _leNikeName.delegate = self;
    _leNikeName.layer.borderWidth = 1.0;
    _leNikeName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _leNikeName.leftViewMode = UITextFieldViewModeAlways;
    [viewBody[0] addSubview:_leNikeName];
    
    UILabel * lbSeparate2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, viewBody[0].frame.size.width, 1)];
    lbSeparate2.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewBody[0] addSubview:lbSeparate2];
    
    UILabel * lbSex = [[UILabel alloc] initWithFrame:CGRectMake(10, 138, 55, 25)];
    lbSex.backgroundColor = [UIColor clearColor];
    lbSex.text = @"性别：";
    lbSex.font = [UIFont boldSystemFontOfSize:16];
    lbSex.textAlignment = NSTextAlignmentLeft;
    [viewBody[0] addSubview:lbSex];
    
    _lbSexValue = [[UILabel alloc] initWithFrame:CGRectMake(viewBody[0].frame.size.width - 50, 138, 20, 25)];
    _lbSexValue.backgroundColor = [UIColor clearColor];
    _lbSexValue.font = [UIFont boldSystemFontOfSize:16];
    _lbSexValue.textAlignment = NSTextAlignmentLeft;
    [viewBody[0] addSubview:_lbSexValue];
    
    _imgSelectArrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lbSexValue.frame), 148, 22, 12)];
    _imgSelectArrow.image = [UIImage imageNamed:@"dropdown-arrow"];
    [viewBody[0] addSubview:_imgSelectArrow];
    
    _btnSelectSex = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnSelectSex.frame = CGRectMake(0, 130, viewBody[0].frame.size.width, 40);
    [viewBody[0] addSubview:_btnSelectSex];
    
    UILabel * lbSeparate3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, viewBody[0].frame.size.width, 1)];
    lbSeparate3.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewBody[0] addSubview:lbSeparate3];
    
    UILabel * lbEquipment = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 55, 25)];
    lbEquipment.backgroundColor = [UIColor clearColor];
    lbEquipment.text = @"装备：";
    lbEquipment.font = [UIFont boldSystemFontOfSize:16];
    lbEquipment.textAlignment = NSTextAlignmentLeft;
    [viewBody[0] addSubview:lbEquipment];
    
    UIImageView * imgRing = [[UIImageView alloc] initWithFrame:CGRectMake(70, 180, 20, 20)];
    imgRing.image = [UIImage imageNamed:@"equipment-wearable"];
    [viewBody[0] addSubview:imgRing];
    
    _leRing = [[HTAutocompleteTextField alloc] initWithFrame:CGRectMake(95, 180, viewBody[0].bounds.size.width - 110, 25)];
    _leRing.font = [UIFont boldSystemFontOfSize:12];
    _leRing.autocompleteType = HTAutocompleteTypeEquip;
    _leRing.placeholder = @"可穿戴设备";
    _leRing.clearButtonMode = UITextFieldViewModeWhileEditing;
    _leRing.text = userInfo.user_equipInfo.ele_product.data.count ? userInfo.user_equipInfo.ele_product.data[0] : @"";
    _leRing.backgroundColor = [UIColor whiteColor];
    _leRing.layer.borderColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222 / 255.0 alpha:1.0].CGColor;
    _leRing.layer.borderWidth = 1.0;
    _leRing.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _leRing.leftViewMode = UITextFieldViewModeAlways;
    [viewBody[0] addSubview:_leRing];
    
    UIImageView * imgShoes = [[UIImageView alloc] initWithFrame:CGRectMake(70, 215, 20, 20)];
    imgShoes.image = [UIImage imageNamed:@"equipment-shoe"];
    [viewBody[0] addSubview:imgShoes];
    
    _leShoes = [[HTAutocompleteTextField alloc] initWithFrame:CGRectMake(95, 215, viewBody[0].bounds.size.width - 110, 25)];
    _leShoes.font = [UIFont boldSystemFontOfSize:12];
    _leShoes.autocompleteType = HTAutocompleteTypeShoes;
    _leShoes.placeholder = @"跑鞋";
    _leShoes.clearButtonMode = UITextFieldViewModeWhileEditing;
    _leShoes.text = userInfo.user_equipInfo.run_shoe.data.count ? userInfo.user_equipInfo.run_shoe.data[0] : @"";
    _leShoes.backgroundColor = [UIColor whiteColor];
    _leShoes.layer.borderColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222 / 255.0 alpha:1.0].CGColor;
    _leShoes.layer.borderWidth = 1.0;
    _leShoes.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _leShoes.leftViewMode = UITextFieldViewModeAlways;
    [viewBody[0] addSubview:_leShoes];
    
    UIImageView * imgPhone = [[UIImageView alloc] initWithFrame:CGRectMake(70, 250, 20, 20)];
    imgPhone.image = [UIImage imageNamed:@"equipment-software"];
    [viewBody[0] addSubview:imgPhone];
    
    _lePhone = [[HTAutocompleteTextField alloc] initWithFrame:CGRectMake(95, 250, viewBody[0].bounds.size.width - 110, 25)];
    _lePhone.font = [UIFont boldSystemFontOfSize:12];
    _lePhone.autocompleteType = HTAutocompleteTypeSoftware;
    _lePhone.placeholder = @"软件应用";
    _lePhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    _lePhone.text = userInfo.user_equipInfo.step_tool.data.count ? userInfo.user_equipInfo.step_tool.data[0] : @"";
    _lePhone.backgroundColor = [UIColor whiteColor];
    _lePhone.layer.borderColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222 / 255.0 alpha:1.0].CGColor;
    _lePhone.layer.borderWidth = 1.0;
    _lePhone.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _lePhone.leftViewMode = UITextFieldViewModeAlways;
    [viewBody[0] addSubview:_lePhone];

    UILabel * lbSeparate4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, viewBody[0].frame.size.width, 1)];
    lbSeparate4.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewBody[0] addSubview:lbSeparate4];
    
    _lbPicture = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, viewBody[0].frame.size.width - 20, 25)];
    _lbPicture.backgroundColor = [UIColor clearColor];
    _lbPicture.text = @"来点生活照呗：";
    _lbPicture.font = [UIFont boldSystemFontOfSize:16];
    _lbPicture.textAlignment = NSTextAlignmentLeft;
    [viewBody[0] addSubview:_lbPicture];
    
    _btnAddPng = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(_lbPicture.frame) + 10, 60, 60);
    [_btnAddPng setImage:[UIImage imageNamed:@"add-images"] forState:UIControlStateNormal];
    [viewBody[0] addSubview:_btnAddPng];
    
    _lbLastSeparate = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnAddPng.frame) + 10, viewBody[0].frame.size.width, 1)];
    _lbLastSeparate.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewBody[0] addSubview:_lbLastSeparate];
    _lbLastSeparate.hidden = YES;
    
    _btnNext[0] = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnNext[0].frame = CGRectMake(viewBody[0].bounds.size.width - 143, viewBody[0].contentSize.height - 60, 123, 38);
    [_btnNext[0] setBackgroundImage:imgButton forState:UIControlStateNormal];
    [_btnNext[0] setTitle:@"下一步" forState:UIControlStateNormal];
    [_btnNext[0] setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_btnNext[0] setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnNext[0].titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [viewBody[0] addSubview:_btnNext[0]];
    
    //View2
    _imgWeight = [[UIImageView alloc] initWithFrame:CGRectMake(104, 20, 92, 243)];
    _imgWeight.image = [UIImage imageNamed:@"boy"];
    [viewBody[1] addSubview:_imgWeight];
    
    _lbWeightValue = [[UILabel alloc] initWithFrame:CGRectMake(viewBody[1].bounds.size.width / 2 - 20, 260, 40, 40)];
    _lbWeightValue.backgroundColor = [UIColor clearColor];
    _lbWeightValue.textColor = [UIColor colorWithRed:255 / 255.0 green:180 / 255.0 blue:50 / 255.0 alpha:1.0];
    _lbWeightValue.font = [UIFont boldSystemFontOfSize:24];
    _lbWeightValue.textAlignment = NSTextAlignmentCenter;
    [viewBody[1] addSubview:_lbWeightValue];
    
    UILabel * lbWeightUnit = [[UILabel alloc] initWithFrame:CGRectMake(viewBody[1].bounds.size.width / 2 + 20, 270, 40, 20)];
    lbWeightUnit.backgroundColor = [UIColor clearColor];
    lbWeightUnit.textColor = [UIColor grayColor];
    lbWeightUnit.text = @"公斤";
    lbWeightUnit.font = [UIFont boldSystemFontOfSize:12];
    lbWeightUnit.textAlignment = NSTextAlignmentLeft;
    [viewBody[1] addSubview:lbWeightUnit];
    
    UIEdgeInsets insetsBox = UIEdgeInsetsMake(12, 12, 12,12);
    UIImage * imgBoxHorizon = [UIImage imageNamed:@"select-box-horizon-transp"];
    UIImage * imgBoxVertical = [UIImage imageNamed:@"select-box-transp"];
    imgBoxHorizon = [imgBoxHorizon resizableImageWithCapInsets:insetsBox];
    imgBoxVertical = [imgBoxVertical resizableImageWithCapInsets:insetsBox];
    UIImageView * imgBK[3];
    imgBK[0] = [[UIImageView alloc] init];
    imgBK[1] = [[UIImageView alloc] init];
    imgBK[2] = [[UIImageView alloc] init];
    _dialView[0] = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(15, 300, 280, 80)];
    _dialView[1] = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(180, 20, 80, 340)];
    _dialView[2] = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(15, 300, 280, 80)];
    imgBK[0].frame = CGRectInset(_dialView[0].frame, -8, 0);
    imgBK[1].frame = CGRectInset(_dialView[1].frame, -8, 0);
    imgBK[2].frame = CGRectInset(_dialView[2].frame, -8, 0);
    imgBK[0].image = imgBoxHorizon;
    imgBK[1].image = imgBoxVertical;
    imgBK[2].image = imgBoxHorizon;
    imgBK[0].userInteractionEnabled = NO;
    imgBK[1].userInteractionEnabled = NO;
    imgBK[2].userInteractionEnabled = NO;
    for(int i = 0; i < 3; i++)
    {
        [_dialView[i] setMinorTicksPerMajorTick:10];
        [_dialView[i] setMinorTickDistance:8];
        
        [_dialView[i] setBackgroundColor:[UIColor whiteColor]];
        
        [_dialView[i] setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
        [_dialView[i] setLabelStrokeWidth:0.1f];
        [_dialView[i] setLabelFillColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.000]];
        
        [_dialView[i] setLabelFont:[UIFont fontWithName:@"Avenir" size:16]];
        
        [_dialView[i] setMinorTickColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.000]];
        [_dialView[i] setMinorTickLength:15.0];
        [_dialView[i] setMinorTickWidth:1.0];
        
        [_dialView[i] setMajorTickColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.000]];
        [_dialView[i] setMajorTickLength:30.0];
        [_dialView[i] setMajorTickWidth:2.0];
        
        [_dialView[i] setShadowColor:[UIColor colorWithRed:0.593 green:0.619 blue:0.643 alpha:1.000]];
        [_dialView[i] setShadowOffset:CGSizeMake(0, 1)];
        [_dialView[i] setShadowBlur:0.9f];
    }
    
    [_dialView[0] setDialRangeFrom:30 to:150];
    _dialView[0].currentValue = userInfo.weight;
    _dialView[0].delegate = self;
    [viewBody[1] addSubview:_dialView[0]];
    [viewBody[1] addSubview:imgBK[0]];
    _lbWeightValue.text = [NSString stringWithFormat:@"%ld", (long)_dialView[0].currentValue];
    
    _btnNext[1] = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnNext[1].frame = CGRectMake(viewBody[1].bounds.size.width - 143, viewBody[1].contentSize.height - 60, 123, 38);
    [_btnNext[1] setBackgroundImage:imgButton forState:UIControlStateNormal];
    [_btnNext[1] setTitle:@"下一步" forState:UIControlStateNormal];
    [_btnNext[1] setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_btnNext[1] setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnNext[1].titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [viewBody[1] addSubview:_btnNext[1]];

    //View3
    _imgHeight = [[UIImageView alloc] initWithFrame:CGRectMake(50, 120, 92, 243)];
    _imgHeight.image = [UIImage imageNamed:@"boy"];
    [viewBody[2] addSubview:_imgHeight];
    
    _lbHeightValue = [[UILabel alloc] initWithFrame:CGRectMake(50, 80, 110, 30)];
    _lbHeightValue.backgroundColor = [UIColor clearColor];
    _lbHeightValue.textAlignment = NSTextAlignmentCenter;
    [viewBody[2] addSubview:_lbHeightValue];
    
    [_dialView[1] setDirection:NO];
    [_dialView[1] setDialRangeFrom:40 to:250];
    [_dialView[1] setOffset:12];
    _dialView[1].currentValue = userInfo.height;
    _dialView[1].delegate = self;
    [viewBody[2] addSubview:_dialView[1]];
    [viewBody[2] addSubview:imgBK[1]];
    
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:160 / 255.0 blue:0.0 alpha:1.0]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", _dialView[1].currentValue] attributes:attribs];
    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@" 厘米" attributes:attribs];
    NSMutableAttributedString * strMix = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strMix appendAttributedString:strPart2Value];
    _lbHeightValue.attributedText = strMix;
    
    _btnNext[2] = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnNext[2].frame = CGRectMake(viewBody[2].bounds.size.width - 143, viewBody[2].contentSize.height - 60, 123, 38);
    [_btnNext[2] setBackgroundImage:imgButton forState:UIControlStateNormal];
    [_btnNext[2] setTitle:@"下一步" forState:UIControlStateNormal];
    [_btnNext[2] setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_btnNext[2] setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnNext[2].titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [viewBody[2] addSubview:_btnNext[2]];

    //View4
    _imgAge = [[UIImageView alloc] initWithFrame:CGRectMake(104, 20, 92, 243)];
    _imgAge.image = [UIImage imageNamed:@"boy"];
    [viewBody[3] addSubview:_imgAge];
    
    _lbAgeValue = [[UILabel alloc] initWithFrame:CGRectMake(viewBody[3].bounds.size.width / 2 - 30, 260, 60, 40)];
    _lbAgeValue.backgroundColor = [UIColor clearColor];
    _lbAgeValue.textColor = [UIColor colorWithRed:255 / 255.0 green:180 / 255.0 blue:50 / 255.0 alpha:1.0];
    _lbAgeValue.font = [UIFont boldSystemFontOfSize:24];
    _lbAgeValue.textAlignment = NSTextAlignmentCenter;
    [viewBody[3] addSubview:_lbAgeValue];
    
    UILabel * lbAgeUnit = [[UILabel alloc] initWithFrame:CGRectMake(viewBody[3].bounds.size.width / 2 + 30, 270, 40, 20)];
    lbAgeUnit.backgroundColor = [UIColor clearColor];
    lbAgeUnit.textColor = [UIColor grayColor];
    lbAgeUnit.text = @"年出生";
    lbAgeUnit.font = [UIFont boldSystemFontOfSize:12];
    lbAgeUnit.textAlignment = NSTextAlignmentLeft;
    [viewBody[3] addSubview:lbAgeUnit];

    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSInteger year = [comps year];
    [_dialView[2] setDialRangeFrom:1900 to:year];
    NSDate * dateBirthday = [NSDate dateWithTimeIntervalSince1970:userInfo.birthday];
    comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dateBirthday];
    NSInteger birthdayYear = [comps year];
    NSDateComponents * comps2 =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    year = [comps2 year];
    _dialView[2].currentValue = year - birthdayYear;
    _dialView[2].delegate = self;
    [viewBody[3] addSubview:_dialView[2]];
    [viewBody[3] addSubview:imgBK[2]];
    _lbAgeValue.text = [NSString stringWithFormat:@"%ld", (long)_dialView[2].currentValue];
    
    _btnNext[3] = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnNext[3].frame = CGRectMake(viewBody[3].bounds.size.width - 143, viewBody[3].contentSize.height - 60, 123, 38);
    [_btnNext[3] setBackgroundImage:imgButton forState:UIControlStateNormal];
    [_btnNext[3] setTitle:@"完成" forState:UIControlStateNormal];
    [_btnNext[3] setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_btnNext[3] setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnNext[3].titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [viewBody[3] addSubview:_btnNext[3]];
    
    _viewAddPhoto = viewBody[0];
    
    if([userInfo.sex_type isEqualToString:@"female"])
    {
        _imgWeight.image = [UIImage imageNamed:@"girl"];
        _imgHeight.image = [UIImage imageNamed:@"girl"];
        _imgAge.image = [UIImage imageNamed:@"girl"];
    }
    else
    {
        _imgWeight.image = [UIImage imageNamed:@"boy"];
        _imgHeight.image = [UIImage imageNamed:@"boy"];
        _imgAge.image = [UIImage imageNamed:@"boy"];
    }
    
    //Create Picker View Controller
    m_pickerFrame = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 230)];
    m_pickerFrame.hidden = YES;
    [self.view addSubview:m_pickerFrame];
    [self.view bringSubviewToFront:m_pickerFrame];
    m_pickerFrame.backgroundColor = [UIColor lightGrayColor];
    
    CGRect rect = CGRectMake(0, 10, self.view.frame.size.width, 20);
    UILabel *lbPickTitle = [[UILabel alloc]initWithFrame:rect];
    lbPickTitle.backgroundColor = [UIColor clearColor];
    lbPickTitle.textColor = [UIColor blackColor];
    lbPickTitle.font = [UIFont systemFontOfSize:18];
    lbPickTitle.text = @"选择性别";
    lbPickTitle.textAlignment = NSTextAlignmentCenter;
    [m_pickerFrame addSubview:lbPickTitle];
    
    rect = CGRectMake(0, 25, rect.size.width, 180);
    m_pickerSelect = [[UIPickerView alloc] initWithFrame:rect];
    m_pickerSelect.delegate = self;
    m_pickerSelect.dataSource = self;
    m_pickerSelect.showsSelectionIndicator = YES;
    m_pickerSelect.backgroundColor = [UIColor clearColor];
    [m_pickerFrame addSubview:m_pickerSelect];
    
    rect = CGRectMake(0, m_pickerSelect.frame.size.height + m_pickerSelect.frame.origin.y - 20, m_pickerFrame.frame.size.width, 35);
    CSButton *btnCancel = [CSButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = rect;
    btnCancel.backgroundColor = [UIColor clearColor];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor colorWithRed:0 green:145 / 255.0 blue:1.0 alpha:1] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[[CommonUtility sharedInstance] createImageWithColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]] forState:UIControlStateHighlighted];
    [btnCancel.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [m_pickerFrame addSubview:btnCancel];

    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    __weak __typeof(self) weakSelf = self;
    
    btnBack[0].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_leNikeName resignFirstResponder];
        [strongSelf->_leRing resignFirstResponder];
        [strongSelf->_leShoes resignFirstResponder];
        [strongSelf->_lePhone resignFirstResponder];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };
    btnBack[1].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        if(strongSelf->_nType == SETTING_TYPE_WEIGHT)
        {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            strongSelf->_viewSettings[0].hidden = NO;
            strongSelf->_viewSettings[1].hidden = YES;
        }
    };
    btnBack[2].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        if(strongSelf->_nType == SETTING_TYPE_HEIGHT)
        {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            strongSelf->_viewSettings[1].hidden = NO;
            strongSelf->_viewSettings[2].hidden = YES;
        }
    };
    btnBack[3].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        if(strongSelf->_nType == SETTING_TYPE_AGE)
        {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            strongSelf->_viewSettings[2].hidden = NO;
            strongSelf->_viewSettings[3].hidden = YES;
        }
    };
    _btnNext[0].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        if (strongSelf->_leNikeName.text.length == 0) {
            [AlertManager showAlertText:@"亲，昵称不能为空，不然你的好友找不到你哦！" InView:strongSelf.view hiddenAfter:2];
        }
        else
        {
            [strongSelf->_leNikeName resignFirstResponder];
            [strongSelf->_leRing resignFirstResponder];
            [strongSelf->_leShoes resignFirstResponder];
            [strongSelf->_lePhone resignFirstResponder];
            if(strongSelf->_nType == SETTING_TYPE_IMAGE)
            {
                [strongSelf updatePersonalInfo];
            }
            else
            {
                strongSelf->_viewSettings[0].hidden = YES;
                strongSelf->_viewSettings[1].hidden = NO;
            }
        }
    };
    _btnNext[1].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        if(strongSelf->_nType == SETTING_TYPE_WEIGHT)
        {
            [strongSelf updatePersonalInfo];
        }
        else
        {
            strongSelf->_viewSettings[1].hidden = YES;
            strongSelf->_viewSettings[2].hidden = NO;
        }
    };
    _btnNext[2].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        if(strongSelf->_nType == SETTING_TYPE_HEIGHT)
        {
            [strongSelf updatePersonalInfo];
        }
        else
        {
            strongSelf->_viewSettings[2].hidden = YES;
            strongSelf->_viewSettings[3].hidden = NO;
        }
    };
    _btnNext[3].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf updatePersonalInfo];
    };
    
    btnCamera.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_leNikeName endEditing:YES];
        [strongSelf->_leRing endEditing:YES];
        [strongSelf->_leShoes endEditing:YES];
        [strongSelf->_lePhone endEditing:YES];
        strongSelf->_nSelectType = 0;
        [strongSelf showPicSelect];
    };
    _btnAddPng.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_leNikeName endEditing:YES];
        [strongSelf->_leRing endEditing:YES];
        [strongSelf->_leShoes endEditing:YES];
        [strongSelf->_lePhone endEditing:YES];
        strongSelf->_nSelectType = 1;
        [strongSelf showPicSelect];
    };
    
    _btnSelectSex.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        if(strongSelf->_nType != SETTING_TYPE_ALL)
        {
            return;
        }
        
        int nIndex = [strongSelf->_lbSexValue.text isEqualToString:@"男"] ? 0 : 1;
        
        [strongSelf->_leNikeName endEditing:YES];
        [strongSelf->_leRing endEditing:YES];
        [strongSelf->_leShoes endEditing:YES];
        [strongSelf->_lePhone endEditing:YES];
        
        strongSelf->m_pickerFrame.hidden = NO;
        [strongSelf.view bringSubviewToFront:strongSelf->m_pickerFrame];
        [strongSelf->m_pickerSelect reloadAllComponents];
        [strongSelf->m_pickerSelect selectRow:nIndex inComponent:0 animated:NO];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        CGRect rect = CGRectMake(0, strongSelf.view.frame.size.height - 230, 320, 230);
        strongSelf->m_pickerFrame.frame = rect;
        [UIView setAnimationDelegate:strongSelf];
        [UIView commitAnimations];
    };
    
    btnCancel.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf closePicker];
    };
    
    [self reloadUserData];
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [_leNikeName endEditing:YES];
    [_leRing endEditing:YES];
    [_leShoes endEditing:YES];
    [_lePhone endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hidenCommonProgress];
    [_leNikeName removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_lePhone removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_leShoes removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_leRing removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_leNikeName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_leRing addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_leShoes addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_lePhone addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_btnNext[0] setTitle:(_nType == SETTING_TYPE_IMAGE) ? @"完成" : @"下一步" forState:UIControlStateNormal];
    [_btnNext[1] setTitle:(_nType == SETTING_TYPE_WEIGHT) ? @"完成" : @"下一步" forState:UIControlStateNormal];
    [_btnNext[2] setTitle:(_nType == SETTING_TYPE_HEIGHT) ? @"完成" : @"下一步" forState:UIControlStateNormal];
    _viewSettings[0].hidden = (_nType != SETTING_TYPE_IMAGE && _nType != SETTING_TYPE_ALL);
    _viewSettings[1].hidden = (_nType != SETTING_TYPE_WEIGHT);
    _viewSettings[2].hidden = (_nType != SETTING_TYPE_HEIGHT);
    _viewSettings[3].hidden = (_nType != SETTING_TYPE_AGE);
    _imgSelectArrow.hidden = (_nType != SETTING_TYPE_ALL);
    _btnSelectSex.hidden = (_nType != SETTING_TYPE_ALL);
    _btnBackMain.hidden = (_nType == SETTING_TYPE_ALL);
    
    if (_bPopSetPhotos) {
        _bPopSetPhotos = NO;
        _btnAddPng.actionBlock();
    }
    
    [self refreshImageViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"SettingsViewController dealloc called!");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setType:(int)nType
{
    _nType = nType;
}

- (void)setUserLifePhotos
{
    _bPopSetPhotos = YES;
}

- (void)updatePersonalInfo
{
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    
    if (userInfo != nil) {
        if (userInfo.ban_time > 0) {
            [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
        else if(userInfo.ban_time < 0)
        {
            [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
    }

    _updateInfo.weight = _dialView[0].currentValue > 0 ? _dialView[0].currentValue : 65;
    _updateInfo.height = _dialView[1].currentValue > 0 ? _dialView[1].currentValue : 170;
    NSInteger nYear = _dialView[2].currentValue > 0 ? _dialView[2].currentValue : 1990;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate * date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%.4ld", nYear]];
    _updateInfo.birthday = [date timeIntervalSince1970];
    _leNikeName.text = [_leNikeName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _updateInfo.nikename = _leNikeName.text;
    _updateInfo.sex_type = [_lbSexValue.text isEqualToString:@"男"] ? @"male" : @"female";
    _equipmentInfo.run_shoe.data = [NSMutableArray arrayWithArray:@[_leShoes.text]];
    _equipmentInfo.ele_product.data = [NSMutableArray arrayWithArray:@[_leRing.text]];
    _equipmentInfo.step_tool.data = [NSMutableArray arrayWithArray:@[_lePhone.text]];
    
    [[SportForumAPI sharedInstance] userSetInfoByUpdateInfo:_updateInfo FinishedBlock:^void(int errorCode, NSString* strDescErr)
     {
         if (errorCode != 0) {
             [AlertManager showAlertText:strDescErr];
         }
         
         [[SportForumAPI sharedInstance] userUpdateEquipment:_equipmentInfo FinishedBlock:^void(int errorCode, ExpEffect* expEffect)
          {
              [[SportForumAPI sharedInstance] userSetLifePhotos:_imgUrlArray FinishedBlock:^void(int errorCode, ExpEffect* expEffect)
               {
                   if(![_strProfileImageID isEqualToString:@""])
                   {
                       [[SportForumAPI sharedInstance] userSetProImageByImageId:_strProfileImageID FinishedBlock:^void(int errorCode, ExpEffect* expEffect)
                        {
                            UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                            
                            [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                             {
                                 if (errorCode == 0)
                                 {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
                                 }
                             }];
                        }];
                   }
                   else
                   {
                       UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                       [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                        {
                            if (errorCode == 0)
                            {
                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
                            }
                        }];
                   }
               }];
          }];
     }];
    
    if (_nType == SETTING_TYPE_ALL) {
        
        RecommendViewController *recommendViewController = [[RecommendViewController alloc]init];
        [self.navigationController pushViewController:recommendViewController animated:NO];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _lbWeightValue.text = [NSString stringWithFormat:@"%ld", (long)_dialView[0].currentValue];
    
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:160 / 255.0 blue:0.0 alpha:1.0]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)_dialView[1].currentValue] attributes:attribs];
    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@" 厘米" attributes:attribs];
    NSMutableAttributedString * strMix = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strMix appendAttributedString:strPart2Value];
    _lbHeightValue.attributedText = strMix;
    
    _lbAgeValue.text = [NSString stringWithFormat:@"%ld", (long)_dialView[2].currentValue];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _lbWeightValue.text = [NSString stringWithFormat:@"%ld", _dialView[0].currentValue];
    
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:160 / 255.0 blue:0.0 alpha:1.0]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", _dialView[1].currentValue] attributes:attribs];
    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@" 厘米" attributes:attribs];
    NSMutableAttributedString * strMix = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strMix appendAttributedString:strPart2Value];
    _lbHeightValue.attributedText = strMix;
    
    _lbAgeValue.text = [NSString stringWithFormat:@"%ld", _dialView[2].currentValue];
}

-(void)reloadUserData
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if(userInfo.userid.length > 0)
    {
        _dialView[0].currentValue = (userInfo.weight != 0) ? userInfo.weight : 60;
        _dialView[1].currentValue = (userInfo.height != 0) ? userInfo.height : 170;
        NSDate * dateBirthday = [NSDate dateWithTimeIntervalSince1970:userInfo.birthday];
        NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dateBirthday];
        NSInteger birthdayYear = [comps year];
        _dialView[2].currentValue = (userInfo.birthday != 0) ? birthdayYear : 1990;
        _lbAgeValue.text = [NSString stringWithFormat:@"%ld", _dialView[2].currentValue];
        _leNikeName.text = userInfo.nikename;
        _lbSexValue.text = [userInfo.sex_type isEqualToString:@"female"] ? @"女" : @"男";
        _leRing.text = userInfo.user_equipInfo.ele_product.data.count ? userInfo.user_equipInfo.ele_product.data[0] : @"";
        _leShoes.text = userInfo.user_equipInfo.run_shoe.data.count ? userInfo.user_equipInfo.run_shoe.data[0] : @"";
        _lePhone.text = userInfo.user_equipInfo.step_tool.data.count ? userInfo.user_equipInfo.step_tool.data[0] : @"";
        
        for (UIImageView* imageView in _imgViewArray)
        {
            [imageView removeFromSuperview];
        }
        
        for (CSButton *btnImage in _imgBtnArray)
        {
            [btnImage removeFromSuperview];
        }
        
        [_imgUrlArray removeAllObjects];
        [_imgViewArray removeAllObjects];
        [_imgBtnArray removeAllObjects];
        
        _btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(_lbPicture.frame) + 10, 60, 60);
        _lbLastSeparate.frame = CGRectMake(0, CGRectGetMaxY(_btnAddPng.frame) + 10, _lbLastSeparate.frame.size.width, 1);
        _bUpdatePhotos = NO;
        
        [self generateImageViewByUrls:userInfo.user_images.data];
    }
    else
    {
        _dialView[0].currentValue = 60;
        _dialView[1].currentValue = 170;
        _dialView[2].currentValue = 1990;
        _lbSexValue.text = @"男";
    }
    
    _lbWeightValue.text = [NSString stringWithFormat:@"%ld", _dialView[0].currentValue];
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24], NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:160 / 255.0 blue:0.0 alpha:1.0]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", _dialView[1].currentValue] attributes:attribs];
    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName:[UIColor blackColor]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@" 厘米" attributes:attribs];
    NSMutableAttributedString * strMix = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strMix appendAttributedString:strPart2Value];
    _lbHeightValue.attributedText = strMix;
    _lbAgeValue.text = [NSString stringWithFormat:@"%ld", _dialView[2].currentValue];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.markedTextRange == nil && textField.text.length > 14) {
        textField.text = [textField.text substringToIndex:14];
    }
    else
    {
        NSString * strFixedContent = [[CommonUtility sharedInstance]disable_emoji:textField.text];
        
        if(![textField.text isEqualToString:strFixedContent])
        {
            textField.text = strFixedContent;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL bAllowWord = YES;
    
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    NSString * strFinalContent = [NSString stringWithString:newtxt];
    
    if ([newtxt length] > 14)
    {
        bAllowWord = NO;
    }
    else
    {
        NSString * strFixedContent = [[CommonUtility sharedInstance]disable_emoji:strFinalContent];
        
        if(![strFinalContent isEqualToString:strFixedContent])
        {
            bAllowWord = NO;
        }
    }

    return bAllowWord;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _leNikeName) {
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        
        _leNikeName.text = [_leNikeName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (![_leNikeName.text isEqualToString:userInfo.nikename] && _leNikeName.text.length > 0) {
            [[SportForumAPI sharedInstance] userIsNikeNameUsed:_leNikeName.text FinishedBlock:^void(int errorCode, BOOL bUsed){
                if (bUsed) {
                    [AlertManager showAlertText:@"亲，该昵称已被使用，再起个名呗~" InView:self.view hiddenAfter:2];
                }
            }];
        }
    }
}

-(void)showCommonProgress{
    m_processWindow = [AlertManager showCommonProgress];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
}

//Upload Publish pngs
-(void)showPicSelect {
    __weak __typeof(self) thisPointer = self;
    
    _customMenuViewController = [[CustomMenuViewController alloc]init];
    
    [_customMenuViewController addButtonFromBackTitle:@"取消" ActionBlock:^(id sender) {
    }];
    
    [_customMenuViewController addButtonFromBackTitle:@"从本地选取" ActionBlock:^(id sender) {
        [thisPointer actionSelectPhoto:sender];
    }];
    
    [_customMenuViewController addButtonFromBackTitle:@"立即拍照" Hightlight:YES ActionBlock:^(id sender) {
        [thisPointer actionTakePhoto:sender];
    }];
    
    [_customMenuViewController showInView:self.navigationController.view];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser deletePhotoAtIndex:(NSUInteger)index {
    if (index <= _photos.count)
    {
        MWPhoto *mwPhoto = [_photos objectAtIndex:index];
        
        if ([mwPhoto.photoURL description].length > 0) {
            [[SportForumAPI sharedInstance]userDelLifePhotoById:[mwPhoto.photoURL description] FinishedBlock:^(int errorCode){
                if (errorCode == 0) {
                    _bUpdatePhotos = YES;
                    [_photos removeObjectAtIndex:index];
                    [photoBrowser reloadData];
                }
            }];
        }
    }
}

-(void)onClickImageViewByIndex:(NSUInteger)index
{
    [_photos removeAllObjects];
    
    for (NSString *strUrl in _imgUrlArray) {
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:strUrl]]];
    }
    
    // Create browser
	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayDeleteButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:index];
    
    [self.navigationController pushViewController:browser animated:YES];
}

-(void)refreshImageViews
{
    if (_bUpdatePhotos) {
        for (UIImageView* imageView in _imgViewArray) {
            [imageView removeFromSuperview];
        }
        
        for (CSButton *btnImage in _imgBtnArray) {
            [btnImage removeFromSuperview];
        }
        
        for (UIView *view in _imgBackFrameArray) {
            [view removeFromSuperview];
        }
        
        [_imgUrlArray removeAllObjects];
        [_imgViewArray removeAllObjects];
        [_imgBtnArray removeAllObjects];
        [_imgBackFrameArray removeAllObjects];
        
        _btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(_lbPicture.frame) + 10, 60, 60);
        _lbLastSeparate.frame = CGRectMake(0, CGRectGetMaxY(_btnAddPng.frame) + 10, _lbLastSeparate.frame.size.width, 1);
        _bUpdatePhotos = NO;
        _btnAddPng.hidden = NO;
        
        NSMutableArray *arrayUrls = [[NSMutableArray alloc]init];
        
        for (MWPhoto *mwPhoto in _photos) {
            [arrayUrls addObject:[mwPhoto.photoURL description]];
        }
        
        [self generateImageViewByUrls:arrayUrls];
    }
}

-(void)generateImageViewByUrls:(NSMutableArray*)arrayUrls
{
    if ([arrayUrls count] == 0) {
        return;
    }
    
    CGRect rectEnd = CGRectZero;
    
    if ([_imgViewArray count] == 0) {
        rectEnd = _btnAddPng.frame;
    }
    else
    {
        UIImageView *imageView = [_imgViewArray lastObject];
        rectEnd = imageView.frame;
    }
    
    for (int i = 0; i < MIN([arrayUrls count], MAX_PUBLISH_PNG_COUNT); i++) {
        if (([_imgViewArray count] - 1) % 4 == 3 && [_imgViewArray count] > 0) {
            rectEnd.origin = CGPointMake(10, CGRectGetMaxY(rectEnd) + 10);
        }
        else
        {
            rectEnd.origin = CGPointMake([_imgViewArray count] == 0 ? 10 + 77 * i : (CGRectGetMaxX(rectEnd) + 17), CGRectGetMinY(rectEnd));
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rectEnd];
        [imageView sd_setImageWithURL:[NSURL URLWithString:arrayUrls[i]]
                     placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIView * backframe = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame) - 1, CGRectGetMinY(imageView.frame) - 1, CGRectGetWidth(imageView.frame) + 2, CGRectGetHeight(imageView.frame) + 2)];
        backframe.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
        backframe.layer.borderWidth = 1.0;
        backframe.layer.borderColor = [[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor];
        
        CSButton *btnImage = [CSButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = imageView.frame;
        btnImage.backgroundColor = [UIColor clearColor];
        [_viewAddPhoto addSubview:btnImage];
        
        __weak __typeof(self) weakSelf = self;
        
        btnImage.actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            NSUInteger nIndex = [strongSelf->_imgViewArray indexOfObject:imageView];
            [strongSelf onClickImageViewByIndex:nIndex];
        };
        
        [_viewAddPhoto addSubview:imageView];
        [_viewAddPhoto addSubview:btnImage];
        [_viewAddPhoto addSubview:backframe];
        [_viewAddPhoto bringSubviewToFront:imageView];
        [_viewAddPhoto bringSubviewToFront:btnImage];
        
        [_imgBackFrameArray addObject:backframe];
        [_imgBtnArray addObject:btnImage];
        [_imgViewArray addObject:imageView];
        [_imgUrlArray addObject:arrayUrls[i]];
    }
    
    if (([_imgViewArray count] - 1) % 4 == 3) {
        _btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(rectEnd) + 10, CGRectGetWidth(rectEnd), CGRectGetHeight(rectEnd));
    }
    else
    {
        _btnAddPng.frame = CGRectMake(CGRectGetMaxX(rectEnd) + 17, CGRectGetMinY(rectEnd), CGRectGetWidth(rectEnd), CGRectGetHeight(rectEnd));
    }
    
    _lbLastSeparate.frame = CGRectMake(0, CGRectGetMaxY(_btnAddPng.frame) + 10, _lbLastSeparate.frame.size.width, 1);
    _btnAddPng.hidden = ([_imgViewArray count] >= MAX_PUBLISH_PNG_COUNT);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageEditViewController = [[ImageEditViewController alloc]initWithNibName:@"ImageEditViewController" bundle:nil];
    _imageEditViewController.checkBounds = YES;
    
    __weak __typeof(self) thisPointer = self;
    
    _imageEditViewController.doneCallback = [_imageEditViewController commonDoneCallbackWithUserDoneCallBack:^(UIImage *doneImage,
                                                                                                               NSString *doneImageID,
                                                                                                               BOOL isOK) {
        __typeof(self) strongThis = thisPointer;
        
        if (isOK)
        {
            if (doneImageID != nil && [doneImageID isEqualToString:@""] == NO)
            {
                if(strongThis->_nSelectType == 0)
                {
                    [strongThis->_imgHead sd_setImageWithURL:[NSURL URLWithString:doneImageID] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
                    _strProfileImageID = doneImageID;
                }
                else
                {
                    [strongThis generateImageViewByUrls:[NSMutableArray arrayWithObject:doneImageID]];
                }
            }
        }
    }];
    
    _imageEditViewController.sourceImage = image;
    [_imageEditViewController reset:NO];
    
    [self.navigationController pushViewController:_imageEditViewController animated:YES];
    _imageEditViewController.cropSize = CGSizeMake(320, 320);
}

-(IBAction)actionTakePhoto:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    [imagePicker setDelegate:self];
}

-(IBAction)actionSelectPhoto:(id)sender
{
    if(_nSelectType == 0)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"支持相机");
        }
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            NSLog(@"支持图库");
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            NSLog(@"支持相片库");
        }
        
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        [imagePicker setDelegate:self];
    }
    else
    {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = MAX_PUBLISH_PNG_COUNT - [_imgViewArray count];
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSMutableArray *arrImages = [[NSMutableArray alloc]init];
    
    for (ALAsset *asset in assets) {
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [arrImages addObject:image];
    }
    
    if ([arrImages count] > 0) {
        __block id processWindow = [AlertManager showCommonProgress];
        
        [[ApplicationContext sharedInstance]upLoadByImageArray:arrImages FinishedBlock:^(NSMutableArray *arrayResult){
            NSMutableArray * arrUrls = [[NSMutableArray alloc]init];
            
            for (UIImage *image in arrImages) {
                for (UploadImageInfo *uploadImageInfo in arrayResult) {
                    if (uploadImageInfo.bIsOk && (uploadImageInfo.preImage == image)) {
                        [arrUrls addObject:uploadImageInfo.upLoadUrl];
                        break;
                    }
                }
            }
            
            [self generateImageViewByUrls:arrUrls];
            [AlertManager dissmiss:processWindow];
        }];
    }
}

#pragma mark Statistics PickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString * strSelect = ((row == 0) ? @"男" : @"女");
    if(row == 1)
    {
        _imgWeight.image = [UIImage imageNamed:@"girl"];
        _imgHeight.image = [UIImage imageNamed:@"girl"];
        _imgAge.image = [UIImage imageNamed:@"girl"];
    }
    else
    {
        _imgWeight.image = [UIImage imageNamed:@"boy"];
        _imgHeight.image = [UIImage imageNamed:@"boy"];
        _imgAge.image = [UIImage imageNamed:@"boy"];
    }
    
    [_lbSexValue setText:strSelect];
    [self closePicker];
    [AlertManager showAlertText:@"选择性别，提交完成后将无法修改！" InView:self.view hiddenAfter:2];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *retval = (id)view;
    
    if(!retval)
    {
        retval = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    }
    
    retval.font = [UIFont boldSystemFontOfSize:18.0f];
    retval.backgroundColor = [UIColor clearColor];
    retval.textColor = [UIColor blackColor];
    retval.textAlignment = NSTextAlignmentCenter;
    retval.text = ((row == 0) ? @"男" : @"女");
    return retval;
}

- (void)closePicker
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    m_pickerFrame.frame = CGRectMake(0, self.view.frame.size.height, 320, 230);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

-(void)animationFinished
{
    m_pickerFrame.hidden = YES;
}

@end
