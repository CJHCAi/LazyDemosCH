//
//  AccountEditViewController.m
//  SportForum
//
//  Created by liyuan on 3/30/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "AccountEditViewController.h"
#import "UIViewController+SportFormu.h"
#import "GCPlaceholderTextView.h"
#import "UIImageView+WebCache.h"
#import "InfoEditViewController.h"
#import "TRSDialScrollView.h"
#import "ImageEditViewController.h"
#import "CustomMenuViewController.h"
#import "LifePhotoViewController.h"
#import "AccountPreViewController.h"
#import "AlertManager.h"

@interface UserEditItem : NSObject

@property(nonatomic, copy) NSString* itemTitle;
@property(nonatomic, copy) NSString* itemPlaceHold;
@property(nonatomic, copy) NSString* itemContent;

@property(strong, nonatomic) NSString *sex_type;
@property(strong, nonatomic) NSMutableArray *user_images;

@end

@implementation UserEditItem

@end

@interface AccountEditViewController ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation AccountEditViewController
{
    NSMutableArray* m_accountItems;
    UITableView *m_tableAccountEdit;
    
    //Emotion PickView
    UIView *m_viewEmotion;
    UIView * m_pickerView0;
    UIPickerView * m_pickerSelect0;
    NSArray *_arrayStore0;
    
    //HomeTown PickView
    UIView *m_viewHomeTown;
    UIView * m_pickerView1;
    UIPickerView * m_pickerSelect1;
    NSArray *_arrayStore1;
    
    //Height PickView
    UIView *m_viewHeight;
    UIView * m_pickerView2;
    
    //Birthday PickView
    UIView *m_viewBirthday;
    UIView *m_pickerView3;
    UIDatePicker *m_pickerDate;
    
    //Weidget PickView
    UIView *m_viewWeidget;
    UIView * m_pickerView4;
    
    //Head Image
    ImageEditViewController* _imageEditViewController;
    CustomMenuViewController* _customMenuViewController;
}

-(void)loadAccountItems
{
    [m_accountItems removeAllObjects];
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    UserEditItem *userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"昵称";
    userEditItem.itemPlaceHold = @"输入昵称，方便好友找到你";
    userEditItem.itemContent = userInfo.nikename;
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"头像";
    userEditItem.itemContent = userInfo.profile_image;
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"生活照";
    userEditItem.user_images = [NSMutableArray arrayWithArray:userInfo.user_images.data];
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"签名";
    userEditItem.itemPlaceHold = @"个人签名";
    userEditItem.itemContent = userInfo.sign;
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"情感状态";
    userEditItem.itemPlaceHold = @"情感状态";
    userEditItem.itemContent = [self convertEmotionToHanzi:userInfo.emotion];
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"职业";
    userEditItem.itemPlaceHold = @"你从事什么职业";
    userEditItem.itemContent = userInfo.profession;
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"兴趣爱好";
    userEditItem.itemPlaceHold = @"你的兴趣爱好是什么";
    userEditItem.itemContent = userInfo.fond;
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"家乡";
    userEditItem.itemPlaceHold = @"你来自哪里";
    userEditItem.itemContent = userInfo.hometown;
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"常出没地";
    userEditItem.itemPlaceHold = @"你经常去的地方";
    userEditItem.itemContent = userInfo.oftenAppear;
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"身高";
    userEditItem.itemPlaceHold = @"你的身高";
    userEditItem.itemContent = userInfo.height > 0 ? [NSString stringWithFormat:@"%lu cm", userInfo.height] : @"";//[NSString stringWithFormat:@"%lu cm", [[CommonUtility sharedInstance]generateHeightBySex:userInfo.sex_type Height:userInfo.height]];
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"性别";
    userEditItem.itemPlaceHold = @"你的性别";
    userEditItem.sex_type = userInfo.sex_type;
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"出生日期";
    userEditItem.itemPlaceHold = @"你的出生日期";
    userEditItem.itemContent = [[CommonUtility sharedInstance]convertBirthdayToString:userInfo.birthday];
    [m_accountItems addObject:userEditItem];
    
    userEditItem = [[UserEditItem alloc]init];
    userEditItem.itemTitle = @"体重";
    userEditItem.itemPlaceHold = @"你的体重";
    userEditItem.itemContent = userInfo.weight > 0 ? [NSString stringWithFormat:@"%lu kg", userInfo.weight] : @"";//[NSString stringWithFormat:@"%lu kg", [[CommonUtility sharedInstance]generateWeightBySex:userInfo.sex_type Weight:userInfo.weight]];
    [m_accountItems addObject:userEditItem];
}

-(void)initPickViewItems
{
    [self createEmotionPick];
    [self createHomeTownPick];
    [self createHeightView];
    [self createBirthdayView];
    [self createWeidgetView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo:) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
    
    [self generateCommonViewInParent:self.view Title:@"个人信息" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;

    //Create Preview View Btn
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UIImageView *imgViewNew = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [imgViewNew setImage:[UIImage imageNamed:@"preview"]];
    [self.view addSubview:imgViewNew];
    
    CSButton *btnPreView = [CSButton buttonWithType:UIButtonTypeCustom];
    btnPreView.frame = CGRectMake(CGRectGetMinX(imgViewNew.frame) - 5, CGRectGetMinY(imgViewNew.frame) - 5, 45, 45);
    btnPreView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnPreView];
    [self.view bringSubviewToFront:btnPreView];
    
    __weak __typeof(self) weakSelf = self;
    
    btnPreView.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
        accountPreViewController.strUserId = userInfo.userid;
        [strongSelf.navigationController pushViewController:accountPreViewController animated:YES];
    };

    m_accountItems = [[NSMutableArray alloc]init];
    [self loadAccountItems];
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    m_tableAccountEdit = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    m_tableAccountEdit.delegate = self;
    m_tableAccountEdit.dataSource = self;
    [viewBody addSubview:m_tableAccountEdit];
    
    [m_tableAccountEdit reloadData];
    m_tableAccountEdit.backgroundColor = [UIColor clearColor];
    m_tableAccountEdit.separatorColor = [UIColor clearColor];
    
    if ([m_tableAccountEdit respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableAccountEdit setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self initPickViewItems];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人编辑 - AccountEditViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"个人编辑 - AccountEditViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人编辑 - AccountEditViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"AccountEditViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleUpdateProfileInfo:(NSNotification*) notification
{
    [self loadAccountItems];
    [m_tableAccountEdit reloadData];
}

-(NSString*)convertEmotionToHanzi:(NSString*)strEmotion
{
    NSString *strHanzi = @"";
    
    //SECRECY/SINGLE/LOVE/MARRIED/HOMOSEXUAL
    if ([strEmotion isEqualToString:@"SECRECY"]) {
        strHanzi = @"保密";
    }
    else if([strEmotion isEqualToString:@"SINGLE"]) {
        strHanzi = @"单身";
    }
    else if([strEmotion isEqualToString:@"LOVE"]) {
        strHanzi = @"恋爱中";
    }
    else if([strEmotion isEqualToString:@"MARRIED"]) {
        strHanzi = @"已婚";
    }
    else if([strEmotion isEqualToString:@"HOMOSEXUAL"]) {
        strHanzi = @"同性";
    }
    
    return strHanzi;
}

-(NSString*)convertHanziToEmotion:(NSString*)strHanzi
{
    NSString *strEmotion = @"";
    
    //SECRECY/SINGLE/LOVE/MARRIED/HOMOSEXUAL
    if ([strHanzi isEqualToString:@"保密"]) {
        strEmotion = @"SECRECY";
    }
    else if([strHanzi isEqualToString:@"单身"]) {
        strEmotion = @"SINGLE";
    }
    else if([strHanzi isEqualToString:@"恋爱中"]) {
        strEmotion = @"LOVE";
    }
    else if([strHanzi isEqualToString:@"已婚"]) {
        strEmotion = @"MARRIED";
    }
    else if([strHanzi isEqualToString:@"同性"]) {
        strEmotion = @"HOMOSEXUAL";
    }
    
    return strEmotion;
}

-(void)setUserInfo:(NSString*)strItem ItemValue:(NSString*)strValue
{
    UserUpdateInfo *userUpdateInfo = [[UserUpdateInfo alloc]init];
    
    if ([strItem isEqualToString:@"情感状态"]) {
        userUpdateInfo.emotion = [self convertHanziToEmotion:strValue];
    }
    else if([strItem isEqualToString:@"家乡"]) {
        userUpdateInfo.hometown = strValue;
    }
    else if([strItem isEqualToString:@"身高"]) {
        userUpdateInfo.height = [strValue integerValue];
    }
    else if([strItem isEqualToString:@"出生日期"]) {
        //1990年01月01日
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy年MM月dd日"];
        NSDate *dateTime = [formatter dateFromString:strValue];
        userUpdateInfo.birthday = [dateTime timeIntervalSince1970];
    }
    else if([strItem isEqualToString:@"体重"]) {
        userUpdateInfo.weight = [strValue integerValue];
    }
    
    id process = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance] userSetInfoByUpdateInfo:userUpdateInfo FinishedBlock:^void(int errorCode, NSString* strDescErr, ExpEffect* expEffect)
     {
         [AlertManager dissmiss:process];
         
         if (errorCode != 0) {
            [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
         }
         
         UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
         
         [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
          {
              if (errorCode == 0)
              {
                  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect",nil]];
              }
          }];
     }];
}

#pragma mark - PickView Create

-(void)createSelectPick:(UIView*)viewMain PickView:(UIView*)viewPick SelectView:(UIPickerView*)pickerView Title:(NSString*)strTitle DoneAction:(void(^)(void))doneBlock CancelAction:(void(^)(void))cancelBlock TitleAction:(void(^)(void))titleBlock
{
    viewMain.frame = [UIScreen mainScreen].bounds;
    viewMain.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    UIView *viewTapPickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewMain.frame.size.width, CGRectGetHeight(viewMain.frame) - 260)];
    viewTapPickView.backgroundColor = [UIColor clearColor];
    [viewMain addSubview:viewTapPickView];
    [viewMain bringSubviewToFront:viewTapPickView];
    
    UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
    [viewTapPickView addGestureRecognizer:tapRecogniser];
    
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height - 260, viewMain.frame.size.width, 260);
    viewPick.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:viewPick];
    [viewMain bringSubviewToFront:viewPick];
    
    CSButton *doneButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.frame = CGRectMake(250.0f, 10.0f, 60.0f, 30.0f);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    doneButton.actionBlock = doneBlock;
    
    CSButton *cancelButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.frame = CGRectMake(10.0f, 10.0f, 60.0f, 30.0f);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.actionBlock = cancelBlock;
    
    CSButton *titleButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [titleButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.frame = CGRectMake((CGRectGetWidth(viewPick.frame) - 80) / 2, 10.0f, 80.0f, 30.0f);
    [titleButton setTitle:strTitle forState:UIControlStateNormal];
    titleButton.actionBlock = titleBlock;
    
    [viewPick addSubview:doneButton];
    [viewPick addSubview:cancelButton];
    [viewPick addSubview:titleButton];
    
    pickerView.frame = CGRectMake(0, 44, [UIScreen screenWidth], 216);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.backgroundColor = [UIColor clearColor];
    [viewPick addSubview:pickerView];
}

-(void)createCustomSelectPick:(UIView*)viewMain PickView:(UIView*)viewPick Title:(NSString*)strTitle DoneAction:(void(^)(void))doneBlock CancelAction:(void(^)(void))cancelBlock TitleAction:(void(^)(void))titleBlock
{
    viewMain.frame = [UIScreen mainScreen].bounds;
    viewMain.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    UIView *viewTapPickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewMain.frame.size.width, CGRectGetHeight(viewMain.frame) - 260)];
    viewTapPickView.backgroundColor = [UIColor clearColor];
    [viewMain addSubview:viewTapPickView];
    [viewMain bringSubviewToFront:viewTapPickView];
    
    UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
    [viewTapPickView addGestureRecognizer:tapRecogniser];
    
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height - 260, viewMain.frame.size.width, 260);
    viewPick.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:viewPick];
    [viewMain bringSubviewToFront:viewPick];
    
    CSButton *doneButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.frame = CGRectMake(250.0f, 10.0f, 60.0f, 30.0f);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    doneButton.actionBlock = doneBlock;
    
    CSButton *cancelButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.frame = CGRectMake(10.0f, 10.0f, 60.0f, 30.0f);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.actionBlock = cancelBlock;
    
    CSButton *titleButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [titleButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.frame = CGRectMake((CGRectGetWidth(viewPick.frame) - 80) / 2, 10.0f, 80.0f, 30.0f);
    [titleButton setTitle:strTitle forState:UIControlStateNormal];
    titleButton.actionBlock = titleBlock;
    
    TRSDialScrollView *dialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen screenWidth], 100)];
    dialView.tag = 100;
    
    UILabel *lbValue = [[UILabel alloc]init];
    lbValue.backgroundColor = [UIColor clearColor];
    lbValue.textAlignment = NSTextAlignmentCenter;
    lbValue.frame = CGRectMake(0, CGRectGetMaxY(dialView.frame), [UIScreen screenWidth], 40);
    lbValue.tag = 101;
    
    [viewPick addSubview:doneButton];
    [viewPick addSubview:cancelButton];
    [viewPick addSubview:titleButton];
    [viewPick addSubview:lbValue];
    [viewPick addSubview:dialView];
    
    [dialView setDirection:YES];
    dialView.dataFormat = DATA_FORMAT_NUM;
    [dialView setMinorTicksPerMajorTick:10];
    [dialView setMinorTickDistance:8];
    [dialView setBackgroundColor:[UIColor whiteColor]];
    [dialView setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [dialView setLabelStrokeWidth:0.1f];
    [dialView setLabelFillColor:[UIColor darkGrayColor]];
    [dialView setLabelFont:[UIFont systemFontOfSize:14]];
    [dialView setMinorTickColor:[UIColor lightGrayColor]];
    [dialView setMinorTickLength:15.0];
    [dialView setMinorTickWidth:1.0];
    [dialView setMajorTickColor:[UIColor darkGrayColor]];
    [dialView setMajorTickLength:30.0];
    [dialView setMajorTickWidth:1];
    [dialView setCurValueViewLength:70];
    dialView.delegate = self;
    
    if (viewMain == m_viewHeight) {
        [dialView setDialRangeFrom:60 to:230];
        dialView.currentValue = 170;
        [self setDialViewValue:170 ViewPick:viewPick UnitFormat:@" cm"];
    }
    else if(viewMain == m_viewWeidget) {
        [dialView setDialRangeFrom:30 to:150];
        dialView.currentValue = 65;
        [self setDialViewValue:65 ViewPick:viewPick UnitFormat:@" kg"];
    }
}

-(void)createDatePick:(UIView*)viewMain PickView:(UIView*)viewPick DatePick:(UIDatePicker*)datePicker Title:(NSString*)strTitle DoneAction:(void(^)(void))doneBlock CancelAction:(void(^)(void))cancelBlock TitleAction:(void(^)(void))titleBlock
{
    viewMain.frame = [UIScreen mainScreen].bounds;
    viewMain.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    UIView *viewTapPickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewMain.frame.size.width, CGRectGetHeight(viewMain.frame) - 260)];
    viewTapPickView.backgroundColor = [UIColor clearColor];
    [viewMain addSubview:viewTapPickView];
    [viewMain bringSubviewToFront:viewTapPickView];
    
    UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
    [viewTapPickView addGestureRecognizer:tapRecogniser];
    
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height - 260, viewMain.frame.size.width, 260);
    viewPick.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:viewPick];
    [viewMain bringSubviewToFront:viewPick];
    
    CSButton *doneButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.frame = CGRectMake(250.0f, 10.0f, 60.0f, 30.0f);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    doneButton.actionBlock = doneBlock;
    
    CSButton *cancelButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.frame = CGRectMake(10.0f, 10.0f, 60.0f, 30.0f);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.actionBlock = cancelBlock;
    
    CSButton *titleButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [titleButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.frame = CGRectMake((CGRectGetWidth(viewPick.frame) - 120) / 2, 10.0f, 120.0f, 30.0f);
    [titleButton setTitle:strTitle forState:UIControlStateNormal];
    titleButton.actionBlock = titleBlock;
    
    [viewPick addSubview:doneButton];
    [viewPick addSubview:cancelButton];
    [viewPick addSubview:titleButton];
    
    datePicker.frame = CGRectMake(0, 44, [UIScreen screenWidth], 216);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *_comps = [calendar components:units fromDate:[NSDate date]];
    NSInteger month = [_comps month];
    NSInteger year = [_comps year];
    NSInteger day = [_comps day];
    
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setYear:year - 100];
    
    NSDate *dateMin = [calendar dateFromComponents:comps];
    datePicker.minimumDate = dateMin;
    datePicker.backgroundColor = [UIColor clearColor];
    [viewPick addSubview:datePicker];
}

-(void)createEmotionPick
{
    _arrayStore0 = [NSArray arrayWithObjects:@"保密", @"单身", @"恋爱中", @"已婚", @"同性",nil];
    m_viewEmotion = [[UIView alloc]init];
    m_pickerView0 = [[UIView alloc] init];
    m_pickerSelect0 = [[UIPickerView alloc] init];

    __weak __typeof(self) weakSelf = self;
    
    [self createSelectPick:m_viewEmotion PickView:m_pickerView0 SelectView:m_pickerSelect0 Title:@"情感状态"
                DoneAction:^void(){
                    __typeof(self) strongSelf = weakSelf;
                    NSInteger nRow = [strongSelf->m_pickerSelect0 selectedRowInComponent:0];
                    UITableViewCell *cell = (UITableViewCell*)[strongSelf->m_tableAccountEdit cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                    GCPlaceholderTextView *lbContent = (GCPlaceholderTextView*)[cell.contentView viewWithTag:11];
                    lbContent.text = strongSelf->_arrayStore0[nRow];
                    [strongSelf hidePickView:strongSelf->m_viewEmotion PickView:strongSelf->m_pickerView0];
                    [strongSelf setUserInfo:@"情感状态" ItemValue:lbContent.text];
                } CancelAction:^void(){
                    __typeof(self) strongSelf = weakSelf;
                    [strongSelf hidePickView:strongSelf->m_viewEmotion PickView:strongSelf->m_pickerView0];
                } TitleAction:nil];
}

-(void)createHomeTownPick
{
    _arrayStore1 = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
    m_viewHomeTown = [[UIView alloc]init];
    m_pickerView1 = [[UIView alloc] init];
    m_pickerSelect1 = [[UIPickerView alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createSelectPick:m_viewHomeTown PickView:m_pickerView1 SelectView:m_pickerSelect1 Title:@"家乡"
                DoneAction:^void(){
                    __typeof(self) strongSelf = weakSelf;
                    NSInteger nRow = [strongSelf->m_pickerSelect1 selectedRowInComponent:0];
                    UITableViewCell *cell = (UITableViewCell*)[strongSelf->m_tableAccountEdit cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
                    GCPlaceholderTextView *lbContent = (GCPlaceholderTextView*)[cell.contentView viewWithTag:11];
                    lbContent.text = [[strongSelf->_arrayStore1 objectAtIndex:nRow] objectForKey:@"state"];
                    [strongSelf hidePickView:strongSelf->m_viewHomeTown PickView:strongSelf->m_pickerView1];
                    [strongSelf setUserInfo:@"家乡" ItemValue:lbContent.text];
                } CancelAction:^void(){
                    __typeof(self) strongSelf = weakSelf;
                    [strongSelf hidePickView:strongSelf->m_viewHomeTown PickView:strongSelf->m_pickerView1];
                } TitleAction:nil];
}

-(void)createHeightView
{
    m_viewHeight = [[UIView alloc]init];
    m_pickerView2 = [[UIView alloc]init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createCustomSelectPick:m_viewHeight PickView:m_pickerView2 Title:@"设置身高"
                DoneAction:^void(){
                    __typeof(self) strongSelf = weakSelf;
                    TRSDialScrollView *dialView = (TRSDialScrollView*)[strongSelf->m_viewHeight viewWithTag:100];
                    UITableViewCell *cell = (UITableViewCell*)[strongSelf->m_tableAccountEdit cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
                    GCPlaceholderTextView *lbContent = (GCPlaceholderTextView*)[cell.contentView viewWithTag:11];
                    lbContent.text = [NSString stringWithFormat:@"%ld cm", dialView.currentValue];
                    [strongSelf hidePickView:strongSelf->m_viewHeight PickView:strongSelf->m_pickerView2];
                    [strongSelf setUserInfo:@"身高" ItemValue:[NSString stringWithFormat:@"%ld", dialView.currentValue]];
                } CancelAction:^void(){
                    __typeof(self) strongSelf = weakSelf;
                    [strongSelf hidePickView:strongSelf->m_viewHeight PickView:strongSelf->m_pickerView2];
                } TitleAction:nil];
}

-(void)createBirthdayView
{
    m_viewBirthday = [[UIView alloc]init];
    m_pickerView3 = [[UIView alloc] init];
    m_pickerDate = [[UIDatePicker alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createDatePick:m_viewBirthday PickView:m_pickerView3 DatePick:m_pickerDate Title:@"设置出生日期"
                DoneAction:^void(){
                    __typeof(self) strongSelf = weakSelf;
                    NSInteger unitflag =   kCFCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay;
                    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents* dateComponent = [chineseClendar components:unitflag fromDate:strongSelf->m_pickerDate.date];
                    UITableViewCell *cell = (UITableViewCell*)[strongSelf->m_tableAccountEdit cellForRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
                    GCPlaceholderTextView *lbContent = (GCPlaceholderTextView*)[cell.contentView viewWithTag:11];
                    
                    lbContent.text = [NSString stringWithFormat:@"%04ld年%02ld月%02ld日", dateComponent.year, dateComponent.month, dateComponent.day];
                    [strongSelf hidePickView:strongSelf->m_viewBirthday PickView:strongSelf->m_pickerView3];
                    [strongSelf setUserInfo:@"出生日期" ItemValue:lbContent.text];
                } CancelAction:^void(){
                    __typeof(self) strongSelf = weakSelf;
                    [strongSelf hidePickView:strongSelf->m_viewBirthday PickView:strongSelf->m_pickerView3];
                } TitleAction:nil];
}

-(void)createWeidgetView
{
    m_viewWeidget = [[UIView alloc]init];
    m_pickerView4 = [[UIView alloc]init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createCustomSelectPick:m_viewWeidget PickView:m_pickerView4 Title:@"设置体重"
                      DoneAction:^void(){
                          __typeof(self) strongSelf = weakSelf;
                          TRSDialScrollView *dialView = (TRSDialScrollView*)[strongSelf->m_viewWeidget viewWithTag:100];
                          UITableViewCell *cell = (UITableViewCell*)[strongSelf->m_tableAccountEdit cellForRowAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];
                          GCPlaceholderTextView *lbContent = (GCPlaceholderTextView*)[cell.contentView viewWithTag:11];
                          lbContent.text = [NSString stringWithFormat:@"%ld kg", dialView.currentValue];
                          [strongSelf hidePickView:strongSelf->m_viewWeidget PickView:strongSelf->m_pickerView4];
                          [strongSelf setUserInfo:@"体重" ItemValue:[NSString stringWithFormat:@"%ld", dialView.currentValue]];
                      } CancelAction:^void(){
                          __typeof(self) strongSelf = weakSelf;
                          [strongSelf hidePickView:strongSelf->m_viewWeidget PickView:strongSelf->m_pickerView4];
                      } TitleAction:nil];
}

#pragma mark - PivkView Logic
- (void)popPickView:(UIView*)viewMain PickView:(UIView*)viewPick SelectView:(UIPickerView*)pickerView RowNum:(NSUInteger)nRowNum ArrStore:(NSArray*)arrStore
{
    UITableViewCell *cell = (UITableViewCell*)[m_tableAccountEdit cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nRowNum inSection:0]];
    GCPlaceholderTextView *lbContent = (GCPlaceholderTextView*)[cell.contentView viewWithTag:11];

    if (viewMain == m_viewEmotion) {
        NSUInteger nIndex = [arrStore indexOfObject:lbContent.text];
        [pickerView selectRow:(nIndex == NSNotFound ? 0 : nIndex) inComponent:0 animated:NO];
    }
    else if(viewMain == m_viewHomeTown)
    {
        NSUInteger nIndex = NSNotFound;
        
        for (NSDictionary *dict in arrStore) {
            if ([[dict objectForKey:@"state"] isEqualToString:lbContent.text]) {
                nIndex = [arrStore indexOfObject:dict];
            }
        }
    }
    else if(viewMain == m_viewHeight)
    {
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewHeight viewWithTag:100];
        NSInteger nCurValue = userInfo.height;
        [dialView setCurrentValue:nCurValue > 0 ? nCurValue : 170];
        [self setDialViewValue:nCurValue > 0 ? nCurValue : 170 ViewPick:m_viewHeight UnitFormat:@" cm"];
    }
    else if(viewMain == m_viewBirthday)
    {
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        NSDate * dateBirthday = [NSDate dateWithTimeIntervalSince1970:userInfo.birthday];
        [m_pickerDate setDate:dateBirthday];
    }
    else if(viewMain == m_viewWeidget)
    {
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewWeidget viewWithTag:100];
        NSInteger nCurValue = userInfo.weight;
        [dialView setCurrentValue:nCurValue > 0 ? nCurValue : 65];
        [self setDialViewValue:nCurValue > 0 ? nCurValue : 65 ViewPick:m_viewWeidget UnitFormat:@" kg"];
    }
    
    [self.navigationController.view addSubview:viewMain];
    [viewMain bringSubviewToFront:viewPick];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height - 260, [UIScreen screenWidth], 260);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)hidePickView:(UIView*)viewMain PickView:(UIView*)viewPick{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height, [UIScreen screenWidth], 260);
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

-(void)actionTap:(UITapGestureRecognizer*)gr {
    [self hidePickView:m_viewEmotion PickView:m_pickerView0];
    [self hidePickView:m_viewHomeTown PickView:m_pickerView1];
    [self hidePickView:m_viewHeight PickView:m_pickerView2];
    [self hidePickView:m_viewBirthday PickView:m_pickerView3];
    [self hidePickView:m_viewWeidget PickView:m_pickerView4];
}

-(void)animationFinished{
    [m_viewEmotion removeFromSuperview];
    [m_viewHomeTown removeFromSuperview];
    [m_viewHeight removeFromSuperview];
    [m_viewBirthday removeFromSuperview];
    [m_viewWeidget removeFromSuperview];
}

#pragma mark - Custom Pick View Logic

-(void)setDialViewValue:(NSInteger)nValue ViewPick:(UIView*)viewPick UnitFormat:(NSString*)strUnitFormat
{
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:30], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", nValue] attributes:attribs];
    attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:strUnitFormat attributes:attribs];
    
    NSMutableAttributedString * strValue = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strValue appendAttributedString:strPart2Value];
    
    UILabel *lbValue = (UILabel*)[viewPick viewWithTag:101];
    lbValue.attributedText = strValue;
}

#pragma mark Statistics PickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger nCount = 0;
    
    if (pickerView == m_pickerSelect0) {
        nCount = [_arrayStore0 count];
    }
    else if(pickerView == m_pickerSelect1)
    {
        nCount = [_arrayStore1 count];
    }
    
    return nCount;
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
    
    if (pickerView == m_pickerSelect0) {
        retval.text = _arrayStore0[row];
    }
    else if(pickerView == m_pickerSelect1)
    {
        retval.text = [[_arrayStore1 objectAtIndex:row] objectForKey:@"state"];
    }
    
    return retval;
}

#pragma mark - Head Image Logic

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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageEditViewController = [[ImageEditViewController alloc]initWithNibName:@"ImageEditViewController" bundle:nil];
    _imageEditViewController.checkBounds = YES;
    
    [[ApplicationContext sharedInstance] saveObject:@(1) byKey:@"ProfileUpload"];
    __weak __typeof(self) thisPointer = self;
    
    _imageEditViewController.doneCallback = [_imageEditViewController commonDoneCallbackWithUserDoneCallBack:^(UIImage *doneImage,
                                                                                                               NSString *doneImageID,
                                                                                                               BOOL isOK) {
        __typeof(self) strongThis = thisPointer;
        
        if (isOK)
        {
            if (doneImageID != nil && [doneImageID isEqualToString:@""] == NO)
            {
                UITableViewCell *cell = (UITableViewCell*)[strongThis->m_tableAccountEdit cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                UIView *viewEspecial0 = [cell.contentView viewWithTag:13];
                
                for (UIView *view in [viewEspecial0 subviews]) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView = (UIImageView*)view;
                        [imageView sd_setImageWithURL:[NSURL URLWithString:doneImageID] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
                        
                        [[SportForumAPI sharedInstance] userSetProImageByImageId:doneImageID FinishedBlock:^void(int errorCode, ExpEffect* expEffect)
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
                        
                        break;
                    }
                }
            }
        }
    }];
    
    _imageEditViewController.sourceImage = image;
    [_imageEditViewController reset:NO];
    
    [self.navigationController pushViewController:_imageEditViewController animated:YES];
    _imageEditViewController.cropSize = CGSizeMake([UIScreen screenWidth], 320);
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

#pragma mark - Table Logic

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_accountItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"AccountEditIdentifier";
    UserEditItem *userEditItem = m_accountItems[[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lbTitle = [[UILabel alloc]init];
        lbTitle.font = [UIFont boldSystemFontOfSize:14.0];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [UIColor darkGrayColor];
        lbTitle.tag = 10;
        [cell.contentView addSubview:lbTitle];
        
        GCPlaceholderTextView *lbContent = [[GCPlaceholderTextView alloc]init];
        lbContent.backgroundColor = [UIColor clearColor];
        lbContent.font = [UIFont boldSystemFontOfSize: 14.0];
        lbContent.textAlignment = NSTextAlignmentLeft;
        lbContent.tag = 11;
        lbContent.userInteractionEnabled = NO;
        [cell.contentView addSubview:lbContent];

        UILabel *lbSep = [[UILabel alloc]init];
        lbSep.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
        lbSep.tag = 12;
        [cell.contentView addSubview:lbSep];
        
        UIView *viewEspecial0 = [[UIView alloc]init];
        viewEspecial0.backgroundColor = [UIColor clearColor];
        viewEspecial0.tag = 13;
        [cell.contentView addSubview:viewEspecial0];
        
        UIView *viewEspecial1 = [[UIView alloc]init];
        viewEspecial1.backgroundColor = [UIColor clearColor];
        viewEspecial1.tag = 14;
        [cell.contentView addSubview:viewEspecial1];
        
        UIView *viewEspecial2 = [[UIView alloc]init];
        viewEspecial2.backgroundColor = [UIColor clearColor];
        viewEspecial2.tag = 15;
        [cell.contentView addSubview:viewEspecial2];
        
        UIImageView *moreImgView = [[UIImageView alloc]init];
        [moreImgView setImage:[UIImage imageNamed:@"arrow-1"]];
        moreImgView.tag = 16;
        [cell.contentView addSubview:moreImgView];
    }
    
    UILabel *lbTitle = (UILabel*)[cell.contentView viewWithTag:10];
    GCPlaceholderTextView *lbContent = (GCPlaceholderTextView*)[cell.contentView viewWithTag:11];
    UILabel *lbSep = (UILabel*)[cell.contentView viewWithTag:12];
    UIView *viewEspecial0 = [cell.contentView viewWithTag:13];
    UIView *viewEspecial1 = [cell.contentView viewWithTag:14];
    UIView *viewEspecial2 = [cell.contentView viewWithTag:15];
    UIImageView *moreImgView = (UIImageView*)[cell.contentView viewWithTag:16];
    
    if ([userEditItem.itemTitle isEqualToString:@"头像"])
    {
        cell.frame = CGRectMake(0, 0, 310, 80);
        
        lbContent.hidden = YES;
        viewEspecial0.hidden = NO;
        viewEspecial1.hidden = YES;
        viewEspecial2.hidden = YES;
        moreImgView.hidden = YES;
        
        lbTitle.text = userEditItem.itemTitle;
        lbTitle.frame = CGRectMake(10, 25, 60, 30);
        
        for (UIView *view in [viewEspecial0 subviews]) {
            [view removeFromSuperview];
        }
        
        UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(85, 10, 60, 60)];
        [imgHead sd_setImageWithURL:[NSURL URLWithString:userEditItem.itemContent] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        imgHead.contentMode = UIViewContentModeScaleAspectFill;
        imgHead.layer.cornerRadius = 8.0;
        imgHead.clipsToBounds = YES;
        [viewEspecial0 addSubview:imgHead];
        viewEspecial0.frame = cell.frame;
        
        lbSep.frame = CGRectMake(80, CGRectGetMaxY(cell.frame) - 1, 230, 1);
    }
    else if([userEditItem.itemTitle isEqualToString:@"生活照"])
    {
        cell.frame = CGRectMake(0, 0, 310, 80);
        viewEspecial1.frame = cell.frame;
        
        lbContent.hidden = YES;
        viewEspecial0.hidden = YES;
        viewEspecial1.hidden = NO;
        viewEspecial2.hidden = YES;
        moreImgView.hidden = NO;
        
        lbTitle.text = userEditItem.itemTitle;
        lbTitle.frame = CGRectMake(10, 25, 60, 30);
        
        for (UIView *view in [viewEspecial1 subviews]) {
            [view removeFromSuperview];
        }

        if (userEditItem.user_images.count > 0) {
            NSUInteger nPosition = 85;
            
            for (NSUInteger i = 0; i < MIN(3, userEditItem.user_images.count) ; i++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(nPosition + i * 68, 10, 60, 60)];
                imageView.layer.cornerRadius = 5.0;
                imageView.layer.masksToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [imageView sd_setImageWithURL:[NSURL URLWithString:userEditItem.user_images[i]]
                                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
                [viewEspecial1 addSubview:imageView];
            }
        }
        else
        {
            UIImageView * imgLazyMan = [[UIImageView alloc] initWithFrame:CGRectMake(85, 15, 50, 50)];
            imgLazyMan.image = [UIImage imageNamed:@"lanhan"];
            [viewEspecial1 addSubview:imgLazyMan];
            
            BOOL bFirstSet = [[[ApplicationContext sharedInstance] getObjectByKey:@"SetLifePhotos"]boolValue];
            
            UILabel *lbLackImage1 = [[UILabel alloc] initWithFrame:CGRectMake(145, 15, 310 - 145 - 23, 50)];
            lbLackImage1.backgroundColor = [UIColor clearColor];
            lbLackImage1.textColor = [UIColor grayColor];
            lbLackImage1.font = [UIFont boldSystemFontOfSize:12];
            lbLackImage1.text = bFirstSet ? @"上传生活照，焕发亲和力" : @"上传生活照，焕发亲和力\n首次上传每张可获取额外10个金币";
            lbLackImage1.numberOfLines = 0;
            [viewEspecial1 addSubview:lbLackImage1];
        }

        moreImgView.frame = CGRectMake(310 - 18, CGRectGetMidY(cell.frame) - 8, 8, 16);
        lbSep.frame = CGRectMake(80, CGRectGetMaxY(cell.frame) - 1, 230, 1);
    }
    else if([userEditItem.itemTitle isEqualToString:@"签名"])
    {
        lbContent.hidden = NO;
        viewEspecial0.hidden = YES;
        viewEspecial1.hidden = YES;
        viewEspecial2.hidden = YES;
        moreImgView.hidden = NO;
        
        lbContent.placeholder = userEditItem.itemPlaceHold;
        lbContent.text = userEditItem.itemContent;
        
        //CGSize lbSize = [lbContent.text sizeWithFont:lbContent.font
        //                            constrainedToSize:CGSizeMake(310 - 85 - 23, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lbSize = [lbContent.text boundingRectWithSize:CGSizeMake(310 - 85 - 23, FLT_MAX)
                                                           options:options
                                                        attributes:@{NSFontAttributeName:lbContent.font} context:nil].size;
        
        lbContent.frame = CGRectMake(85, 10, 310 - 85 - 23, MAX(lbSize.height + 10, 32));
        
        cell.frame = CGRectMake(0, 0, 310, CGRectGetHeight(lbContent.frame) + 20);
        lbTitle.text = userEditItem.itemTitle;
        lbTitle.frame = CGRectMake(10, CGRectGetMidY(cell.frame) - 15, 60, 30);
        moreImgView.frame = CGRectMake(310 - 18, CGRectGetMidY(cell.frame) - 8, 8, 16);
        lbSep.frame = CGRectMake(80, CGRectGetMaxY(cell.frame) - 1, 230, 1);
    }
    else if([userEditItem.itemTitle isEqualToString:@"性别"])
    {
        cell.frame = CGRectMake(0, 0, 310, 52);
        viewEspecial2.frame = cell.frame;
        
        lbContent.hidden = YES;
        viewEspecial0.hidden = YES;
        viewEspecial1.hidden = YES;
        viewEspecial2.hidden = NO;
        moreImgView.hidden = YES;
        
        lbTitle.text = userEditItem.itemTitle;
        lbTitle.frame = CGRectMake(10, 11, 60, 30);
        
        for (UIView *view in [viewEspecial2 subviews]) {
            [view removeFromSuperview];
        }
        
        UIImageView *imgSex = [[UIImageView alloc]initWithFrame:CGRectMake(85, 16, 14, 20)];
        [imgSex setImage:[UIImage imageNamed:[userEditItem.sex_type isEqualToString:sex_male] ? @"me-info-male" : @"me-info-female"]];
        [viewEspecial2 addSubview:imgSex];
        
        UILabel *lbSex = [[UILabel alloc]init];
        lbSex.font = [UIFont boldSystemFontOfSize:14.0];
        lbSex.textAlignment = NSTextAlignmentLeft;
        lbSex.backgroundColor = [UIColor clearColor];
        lbSex.textColor = [UIColor darkGrayColor];
        lbSex.frame = CGRectMake(105, 10, 310 - 80 - 23, 32);
        lbSex.text = [userEditItem.sex_type isEqualToString:sex_male] ? @"男" : @"女";
        [viewEspecial2 addSubview:lbSex];
        
        lbSep.frame = CGRectMake(80, CGRectGetMaxY(cell.frame) - 1, 230, 1);
    }
    else
    {
        cell.frame = CGRectMake(0, 0, 310, 52);
        
        lbContent.hidden = NO;
        viewEspecial0.hidden = YES;
        viewEspecial1.hidden = YES;
        viewEspecial2.hidden = YES;
        moreImgView.hidden = NO;
        
        lbTitle.text = userEditItem.itemTitle;
        lbTitle.frame = CGRectMake(10, 11, 60, 30);
        
        lbContent.placeholder = userEditItem.itemPlaceHold;
        lbContent.text = userEditItem.itemContent;
        lbContent.frame = CGRectMake(85, 10, 310 - 85 - 23, 30);
        
        moreImgView.frame = CGRectMake(310 - 18, CGRectGetMidY(cell.frame) - 8, 8, 16);
        lbSep.frame = CGRectMake(80, CGRectGetMaxY(cell.frame) - 1, 230, 1);
        cell.frame = CGRectMake(0, 0, 310, 52);
    }

    lbSep.hidden = [userEditItem.itemTitle isEqualToString:@"体重"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserEditItem *userEditItem = m_accountItems[[indexPath row]];
    
    if ([userEditItem.itemTitle isEqualToString:@"头像"])
    {
        [self showPicSelect];
    }
    else if([userEditItem.itemTitle isEqualToString:@"生活照"])
    {
        LifePhotoViewController *lifePhotoViewController = [[LifePhotoViewController alloc]init];
        lifePhotoViewController.arrLifePhotos = userEditItem.user_images;
        [self.navigationController pushViewController:lifePhotoViewController animated:YES];
    }
    else
    {
        if ([userEditItem.itemTitle isEqualToString:@"昵称"] || [userEditItem.itemTitle isEqualToString:@"签名"]
            || [userEditItem.itemTitle isEqualToString:@"职业"] || [userEditItem.itemTitle isEqualToString:@"兴趣爱好"]
            || [userEditItem.itemTitle isEqualToString:@"常出没地"]) {
            InfoEditViewController *infoEditViewController = [[InfoEditViewController alloc]init];
            infoEditViewController.strTitle = userEditItem.itemTitle;
            infoEditViewController.strPlaceHold = userEditItem.itemPlaceHold;
            infoEditViewController.strContent = userEditItem.itemContent;
            [self.navigationController pushViewController:infoEditViewController animated:YES];
        }
        else if([userEditItem.itemTitle isEqualToString:@"情感状态"])
        {
            [self popPickView:m_viewEmotion PickView:m_pickerView0 SelectView:m_pickerSelect0 RowNum:4 ArrStore:_arrayStore0];
        }
        else if([userEditItem.itemTitle isEqualToString:@"家乡"])
        {
            [self popPickView:m_viewHomeTown PickView:m_pickerView1 SelectView:m_pickerSelect1 RowNum:7 ArrStore:_arrayStore1];
        }
        else if([userEditItem.itemTitle isEqualToString:@"身高"])
        {
            [self popPickView:m_viewHeight PickView:m_pickerView2 SelectView:nil RowNum:9 ArrStore:nil];
        }
        else if([userEditItem.itemTitle isEqualToString:@"出生日期"])
        {
            [self popPickView:m_viewBirthday PickView:m_pickerView3 SelectView:nil RowNum:11 ArrStore:nil];
        }
        else if([userEditItem.itemTitle isEqualToString:@"体重"])
        {
            [self popPickView:m_viewWeidget PickView:m_pickerView4 SelectView:nil RowNum:12 ArrStore:nil];
        }
    }
}

#pragma mark - ScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewHeight viewWithTag:100];
    TRSDialScrollView *dialView1 = (TRSDialScrollView*)[m_viewWeidget viewWithTag:100];
    
    if(scrollView == dialView.scrollView)
    {
        [self setDialViewValue:dialView.currentValue ViewPick:m_viewHeight UnitFormat:@" cm"];
    }
    else if(scrollView == dialView1.scrollView)
    {
        [self setDialViewValue:dialView1.currentValue ViewPick:m_viewWeidget UnitFormat:@" kg"];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewHeight viewWithTag:100];
    TRSDialScrollView *dialView1 = (TRSDialScrollView*)[m_viewWeidget viewWithTag:100];
    
    if(scrollView == dialView.scrollView)
    {
        [self setDialViewValue:dialView.currentValue ViewPick:m_viewHeight UnitFormat:@" cm"];
    }
    else if(scrollView == dialView1.scrollView)
    {
        [self setDialViewValue:dialView1.currentValue ViewPick:m_viewWeidget UnitFormat:@" kg"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
