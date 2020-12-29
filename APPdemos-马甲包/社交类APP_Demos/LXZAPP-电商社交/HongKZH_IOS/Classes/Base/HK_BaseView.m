//
//  HK_BaseView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "UtilHKEnmu.h"
#import "UIView+FrameGeometry.h"
#import "SVProgressHUD.h"
#import <AdSupport/ASIdentifierManager.h>

#import "TZImagePickerController.h"
#import "HKNewPsonShowView.h"
@interface HK_BaseView () {
    CGFloat _totalYOffset;
}
@end

@implementation HK_BaseView


-(CGSize)calcSelfSize
{
    return CGSizeZero;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _totalYOffset = 0;
    }
    
    return self;
}

-(void)addNotification {
#pragma mark 监听注册成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelNewUser) name:RegeistNewPerson object:nil];
}

-(void)cancelNewUser {
    if ([LoginUserData sharedInstance].isFirst.intValue) {
        HKNewPsonShowView *show =[[HKNewPsonShowView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:show];
        [LoginUserData sharedInstance].isFirst =@"0";
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    }
    else
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}
- (void)setShowCustomerLeftItem:(BOOL)showCustomerLeftItem
{
    if (showCustomerLeftItem) {
        _showCustomerLeftItem = showCustomerLeftItem;
        
        //back
        CGFloat left = -10;
        if (kScreenWidth<375) {
            left = -50;
        }
        UIButton *bbt = [HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectMake(left, 0, 30, 30) taget:self action:@selector(backItemClick) supperView:nil];
        [bbt setImage:[UIImage imageNamed:@"selfMediaClass_back"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bbt];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - action

- (void)backItemClick
{
    if ([self isKindOfClass:[TZAlbumPickerController class]]||self.isPre) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showSVProgressHUD;
{
    [SVProgressHUD show];
}

- (BOOL)shouldAutorotate{//1 允许自动翻转
    return YES;
    
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{//2 翻转只支持竖屏
    return UIInterfaceOrientationPortrait;
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{//3 翻转只支持竖屏
    return UIInterfaceOrientationMaskPortrait;
    
}
@end
