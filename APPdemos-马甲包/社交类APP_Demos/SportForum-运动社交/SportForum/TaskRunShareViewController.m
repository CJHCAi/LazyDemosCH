//
//  TaskRunShareViewController.m
//  SportForum
//
//  Created by liyuan on 7/10/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "TaskRunShareViewController.h"
#import "UIViewController+SportFormu.h"
#import "GCPlaceholderTextView.h"
#import "AlertManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface KCAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic,strong) UIImage *image;

#pragma mark 大头针详情左侧图标
@property (nonatomic,strong) UIImage *icon;
#pragma mark 大头针详情描述
@property (nonatomic,copy) NSString *detail;
#pragma mark 大头针右下方星级评价
@property (nonatomic,strong) UIImage *rate;

@end

@implementation KCAnnotation

@end

@interface TaskRunShareViewController ()<MKMapViewDelegate, UIAlertViewDelegate>

@end

@implementation TaskRunShareViewController
{
    UIView *_viewBody;
    UIScrollView *m_scrollView;
    
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    KCAnnotation *_annotation;
    
    UITextField *_tfDate;
    GCPlaceholderTextView *_tvAddress;
    
    UIView *m_viewBeginDate;
    UIView *m_pickerView0;
    UIDatePicker *m_pickerDate;
    
    UIAlertView* _alertView;
    float _fLatitude;
    float _fLongitude;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateTaskStatus) name:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
    // Do any additional setup after loading the view.
    [self generateCommonViewInParent:self.view Title:@"约跑" IsNeedBackBtn:YES];
    
    _viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = _viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    _viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    _viewBody.layer.mask = maskLayer;
    
    m_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewBody.frame), CGRectGetHeight(_viewBody.frame))];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.scrollEnabled = YES;
    [_viewBody addSubview:m_scrollView];

    [self initGUI];
    
    UILabel *lbAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_mapView.frame) + 15, 70, 20)];
    lbAddress.backgroundColor = [UIColor clearColor];
    lbAddress.textColor = [UIColor darkGrayColor];
    lbAddress.text = @"跑步地点：";
    lbAddress.textAlignment = NSTextAlignmentLeft;
    lbAddress.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbAddress];
    
    _tvAddress = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(80, CGRectGetMinY(lbAddress.frame) - 7, 220, 50)];
    _tvAddress.backgroundColor = [UIColor clearColor];
    _tvAddress.font = [UIFont systemFontOfSize:14];
    _tvAddress.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tvAddress.userInteractionEnabled = NO;
    _tvAddress.placeholder = @"长按地图选择跑步地点";
    [m_scrollView addSubview:_tvAddress];
    
    UILabel *labelDate = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_tvAddress.frame), 70, 20)];
    labelDate.backgroundColor = [UIColor clearColor];
    labelDate.textColor = [UIColor darkGrayColor];
    labelDate.text = @"跑步时间：";
    labelDate.textAlignment = NSTextAlignmentLeft;
    labelDate.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:labelDate];
    
    _tfDate = [[UITextField alloc]initWithFrame:CGRectMake(80, CGRectGetMinY(labelDate.frame) - 4, 220, 30)];
    _tfDate.backgroundColor = [UIColor clearColor];
    _tfDate.placeholder = @"点击设置跑步时间";
    _tfDate.borderStyle = UITextBorderStyleNone;
    _tfDate.font = [UIFont systemFontOfSize:14];
    _tfDate.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tfDate.text = @"";
    _tfDate.multipleTouchEnabled = YES;
    _tfDate.enabled = NO;
    _tfDate.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];;
    _tfDate.leftViewMode = UITextFieldViewModeAlways;
    [m_scrollView addSubview:_tfDate];
    
    CSButton *btnDate = [CSButton buttonWithType:UIButtonTypeCustom];
    btnDate.frame = _tfDate.frame;
    btnDate.backgroundColor = [UIColor clearColor];
    [m_scrollView addSubview:btnDate];
    
    __weak __typeof(self) weakSelf = self;
    
    btnDate.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf popPickView:strongSelf->m_viewBeginDate PickView:strongSelf->m_pickerView0];
    };
    
    CSButton *btnRun = [CSButton buttonWithType:UIButtonTypeCustom];
    btnRun.backgroundColor = [UIColor clearColor];
    [btnRun setImage:[UIImage imageNamed:@"home-run-together"] forState:UIControlStateNormal];
    [btnRun setTitle:@"约跑" forState:UIControlStateNormal];
    [btnRun setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btnRun.frame = CGRectMake(CGRectGetWidth(m_scrollView.frame) / 2 - 25, CGRectGetHeight(m_scrollView.frame) - 90, 50, 80);
    btnRun.tag = 42013;
    btnRun.titleLabel.font = [UIFont boldSystemFontOfSize:14];//title字体大小
    btnRun.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnRun setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 30, 0)];
    [btnRun setTitleEdgeInsets:UIEdgeInsetsMake(60, -btnRun.titleLabel.bounds.size.width - 65, 0, 0)];
    [m_scrollView addSubview:btnRun];
    
    btnRun.actionBlock = ^()
    {
        __typeof(self) strongSelf = weakSelf;
        
        if (strongSelf->_tfDate.text.length == 0 || strongSelf->_fLatitude == 0.0 || strongSelf->_fLongitude == 0.0 || strongSelf->_tvAddress.text.length == 0) {
            [JDStatusBarNotification showWithStatus:@"跑步时间和地点不能为空" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        
        if ([strongSelf checkFirstActionFree]) {
            [strongSelf taskShared:YES];
        }
        else
        {
            if ([strongSelf checkFirstActionPopWin]) {
                strongSelf->_alertView = [[UIAlertView alloc] initWithTitle:@"邀请" message:@"今天免费次数已用完，本次邀请会花费1个金币，确认邀请吗？" delegate:strongSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                strongSelf->_alertView.tag = 10;
                [strongSelf->_alertView show];
            }
            else
            {
                [strongSelf taskShared:NO];
            }
        }
    };
    
    [self createBeginDateView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"TaskRunShareViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"TaskRunShareViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TaskRunShareViewController"];
}

-(void)dealloc
{
    NSLog(@"TaskRunShareViewController dealloc called!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleUpdateTaskStatus
{
    //Update Refer Members, so popCurrentView
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage*) renderMapViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(_mapView.frame.size,NO,0.0f);
    {
        [_mapView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    
    /*UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存图片到照片库
    
    NSData *imageViewData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= [NSString stringWithFormat:@"screenShow_%d.png", i++];
    [imageViewData writeToFile:[documentsDirectory stringByAppendingPathComponent:pictureName] atomically:YES];//保存照片到沙盒目录*/
    
    return image;
}

-(void)taskShared:(BOOL)bFree
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    NSInteger nCoinValue = userInfo.proper_info.coin_value / 100000000;
    
    if(!bFree && nCoinValue == 0)
    {
        [JDStatusBarNotification showWithStatus:@"金币余额为0，不能发送邀请，赶快去赚取金币吧!" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }
    
    [[CommonUtility sharedInstance]playAudioFromName:@"makearun.wav"];
    [JDStatusBarNotification showWithStatus:@"约跑邀请已发送!" dismissAfter:1 styleName:JDStatusBarStyleSuccess];
    
    NSString *strDate = _tfDate.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy年MM月dd日 HH:mm"];
    NSDate *myDate = [formatter dateFromString:strDate];

    id processWin = [AlertManager showCommonProgress];
    
    UIImage *imgAddr = [self renderMapViewToImage];
    
    [[SportForumAPI sharedInstance] imageUploadByUIImage:imgAddr Width:0 Height:0 IsCompress:NO                                                       UploadProgressBlock:nil FinishedBlock:^(int errorCode, NSString *imageID, NSString *imageURL) {
        [[SportForumAPI sharedInstance]tasksShareByUserId:_strUserId TaskId:_nTaskId ShareType:e_accept_physique CostCoin:bFree ? 0 : 100000000 Latitude:_fLatitude Longitude:_fLongitude AddDesc:_tvAddress.text MapImgUrl:imageURL.length > 0 ? imageURL : @"" RunBeginTime:[myDate timeIntervalSince1970] FinishedBlock:^(int errorCode)
         {
             [AlertManager dissmiss:processWin];
             
             [self.navigationController popViewControllerAnimated:YES];
             
             if (_finishBlock != nil) {
                 _finishBlock();
             }
         }];
    }];
}

-(BOOL)checkFirstActionFree
{
    BOOL bFirstAction= NO;
    NSDate * nowDate = [NSDate date];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:nowDate];
    NSString *strDate = [NSString stringWithFormat:@"%02ld/%02ld/%04ld", [comps month], [comps day], [comps year]];
    
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"FirstActionInfo"];
    BOOL bFirst = [[dict objectForKey:strDate]boolValue];
    
    if (!bFirst) {
        bFirstAction = YES;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstActionInfo"];
        NSMutableDictionary *actionDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @(YES), strDate, nil];
        [[ApplicationContext sharedInstance] saveObject:actionDict byKey:@"FirstActionInfo"];
    }
    
    return bFirstAction;
}

-(BOOL)checkFirstActionPopWin
{
    BOOL bFirstAction= NO;
    NSDate * nowDate = [NSDate date];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:nowDate];
    NSString *strDate = [NSString stringWithFormat:@"%02ld/%02ld/%04ld", [comps month], [comps day], [comps year]];
    
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"FirstActionPop"];
    BOOL bFirst = [[dict objectForKey:strDate]boolValue];
    
    if (!bFirst) {
        bFirstAction = YES;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstActionPop"];
        NSMutableDictionary *actionDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @(YES), strDate, nil];
        [[ApplicationContext sharedInstance] saveObject:actionDict byKey:@"FirstActionPop"];
    }
    
    return bFirstAction;
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
    titleButton.frame = CGRectMake((CGRectGetWidth(viewPick.frame) - 160.0) / 2, 10.0f, 160.0f, 30.0f);
    [titleButton setTitle:strTitle forState:UIControlStateNormal];
    titleButton.actionBlock = titleBlock;
    
    [viewPick addSubview:doneButton];
    [viewPick addSubview:cancelButton];
    [viewPick addSubview:titleButton];
    
    datePicker.frame = CGRectMake(0, 44, [UIScreen screenWidth], 216);
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * 7;
    datePicker.maximumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay];
    
    datePicker.minimumDate = [NSDate date];
    datePicker.backgroundColor = [UIColor clearColor];
    [viewPick addSubview:datePicker];
}

-(void)createBeginDateView
{
    m_viewBeginDate = [[UIView alloc]init];
    m_pickerView0 = [[UIView alloc] init];
    m_pickerDate = [[UIDatePicker alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createDatePick:m_viewBeginDate PickView:m_pickerView0 DatePick:m_pickerDate Title:@"设置开始时间"
              DoneAction:^void(){
                  __typeof(self) strongSelf = weakSelf;
                  NSInteger unitflag =   kCFCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
                  NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar];
                  NSDateComponents* dateComponent = [chineseClendar components:unitflag fromDate:strongSelf->m_pickerDate.date];
                  strongSelf->_tfDate.text = [NSString stringWithFormat:@"%04ld年%02ld月%02ld日 %02ld:%02ld", dateComponent.year, dateComponent.month, dateComponent.day, dateComponent.hour, dateComponent.minute];
                  [strongSelf hidePickView:strongSelf->m_viewBeginDate PickView:strongSelf->m_pickerView0];
              } CancelAction:^void(){
                  __typeof(self) strongSelf = weakSelf;
                  [strongSelf hidePickView:strongSelf->m_viewBeginDate PickView:strongSelf->m_pickerView0];
              } TitleAction:nil];
}

#pragma mark - AlertView Logic

-(void)dismissAlertView {
    if (_alertView) {
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView.delegate = nil;
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 1)
        {
            [self dismissAlertView];
            [self taskShared:NO];
        }
    }
}

#pragma mark - PivkView Logic
- (void)popPickView:(UIView*)viewMain PickView:(UIView*)viewPick
{
    if (viewMain == m_viewBeginDate) {
        NSString *strDate = _tfDate.text;
        
        if (strDate.length > 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat : @"yyyy年MM月dd日 HH:mm"];
            NSDate *dateTime = [formatter dateFromString:strDate];
            [m_pickerDate setDate:dateTime];
        }
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
    [self hidePickView:m_viewBeginDate PickView:m_pickerView0];
}

-(void)animationFinished{
    [m_viewBeginDate removeFromSuperview];
}

#pragma mark 添加地图控件
-(void)initGUI{
    _mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(m_scrollView.frame), CGRectGetHeight(m_scrollView.frame) / 2 + 50)];
    [m_scrollView addSubview:_mapView];
    //设置代理
    _mapView.delegate = self;
    
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    lpress.allowableMovement = 10.0;
    [_mapView addGestureRecognizer:lpress];//m_mapView是MKMapView的实例
    
    _annotation = [[KCAnnotation alloc]init];
    _annotation.image=[UIImage imageNamed:@"icon_pin_floating.png"];
}

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];//这里touchPoint是点击的某点在地图控件中的位置
        CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];//这里touchMapCoordinate就是该点的经纬度了
        
        CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
        
        CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
        {
            CLPlacemark *placemark=[placemarks firstObject];
            
            if (_mapView.annotations.count > 0) {
                [_mapView removeAnnotations:_mapView.annotations];
            }
            
            _annotation.title = placemark.subLocality;
            _annotation.subtitle = placemark.name;
            _annotation.coordinate=touchMapCoordinate;
            [_mapView addAnnotation:_annotation];
            [_mapView selectAnnotation:_annotation animated:YES];
            
            _tvAddress.text = placemark.name;
            _fLatitude = touchMapCoordinate.latitude;
            _fLongitude = touchMapCoordinate.longitude;
        };
        
        CLLocation *location=[[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        [clGeoCoder reverseGeocodeLocation:location completionHandler:handle];
    }
}

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[KCAnnotation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me-level-runner"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((KCAnnotation *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }
    else {
        return nil;
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
