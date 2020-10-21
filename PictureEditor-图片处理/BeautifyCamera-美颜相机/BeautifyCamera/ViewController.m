

#import "ViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#import <GPUImage/GPUImage.h>

#import <Masonry/Masonry.h>
#import "LMCameraManager.h"
#import "LMCameraFilters.h"
#import "LMFilterChooserView.h"
#import "UBImageManager.h"
#import "MBProgressHUD.h"

#import "HZPhotoBrowser.h"
#import "UIButton+WebCache.h"
#import "HZPhotoItemModel.h"
#import "UBPictureEditController.h"

#define IS_IPHONE4 ([UIScreen mainScreen].bounds.size.height == 480)


#define iphone4_image_scale 480 / 320

#define iphone6_image_scale 500 / 375

#define headerView_height 50
#define bottomView_height 80

static SystemSoundID shake_sound_male_id = 0;

@interface ViewController ()<HZPhotoBrowserDelegate>

@property (nonatomic, strong) UISlider * bfSlider;
@property (nonatomic, strong) UIButton * takeButton;
@property (nonatomic, strong) UIImageView * lastPhoto;
@property (nonatomic, strong) UIControl * lastPhotoControl;
@property (nonatomic, strong) UIButton * beautyButton;

@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIView * topView;

//    top buttons
@property (nonatomic , strong) UIButton *flashButton;
@property (nonatomic , strong) UIButton *cameraPostionButton;
@property (nonatomic , strong) UIButton *delayButton;

@property (nonatomic, readonly) LMCameraManager * cameraManager;
@property (nonatomic, strong) LMFilterChooserView * filterChooserView;

@property (nonatomic, assign) BOOL showFilterView;
@property (nonatomic) NSMutableArray * imageList;

@property (nonatomic, assign) NSUInteger delaySec;
@property (nonatomic, assign) CGPoint lastPanPoint;
@property (nonatomic, assign) CGFloat panDt;
@property (nonatomic, strong) MBProgressHUD * panHud;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showFilterView = NO;
    self.imageList = [NSMutableArray new];
    self.panDt = self.view.bounds.size.height / 50;
    self.delaySec = 0;
    
    // 先用filter 处理icon
    [self.filterChooserView addFilters:self.cameraManager.filters];
    
    CGRect frame = CGRectMake(0, headerView_height, self.view.bounds.size.width, self.view.bounds.size.height - headerView_height - bottomView_height);
    [self.cameraManager setVieweFrame:frame superview:self.view];
    [self.cameraManager setfocusImage:[UIImage imageNamed:@"touch_focus_x"]];
    [self.cameraManager startCamera];
    [self.cameraManager setFilterAtIndex:0];
    
   
    UIPanGestureRecognizer *pan  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.cameraManager addGesture:pan];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.cameraManager addGesture:swipeLeft];
    [pan requireGestureRecognizerToFail: swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.cameraManager addGesture:swipeRight];
    [pan requireGestureRecognizerToFail: swipeRight];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.cameraManager addGesture:pinch];
    
    [self.view addSubview:self.filterChooserView];
    [self.filterChooserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-bottomView_height);
        make.height.equalTo(@20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
   
    
    [self layoutTopView];
    
    [self layoutBottomView];
    
    
    // slider
    //    CGFloat width = 150;
    //    CGFloat height = 30;
    //    CGFloat x = self.view.bounds.size.width - 20 - width;
    //    CGFloat y = 0 + 50 + 20;
    //
    //    self.bfSlider = [[UISlider alloc] initWithFrame:CGRectMake(x, y, width, height)];
    //    self.bfSlider.minimumValue = 0.0f;
    //    self.bfSlider.maximumValue = 1.0f;
    //    [self.view addSubview:self.bfSlider];
    
    
    
    //    [self.bfSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    //    self.bfSlider.value = 0.2;
    //
    //    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI_2);
    //
    //    CGRect rect = self.bfSlider.frame;
    //    self.bfSlider.layer.anchorPoint = CGPointMake(1, 0.5);
    //    self.bfSlider.transform = trans;
    //     x = rect.origin.x +rect.size.width - rect.size.height/2;
    //     y = rect.origin.y +rect.size.height/2;
    //    self.bfSlider.layer.position =  CGPointMake(x, y);
    //    self.bfSlider.translatesAutoresizingMaskIntoConstraints = YES;
    
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf loaddata];
    });
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void) layoutTopView{
    UIView * topView = [[UIView alloc] init];
    [topView setBackgroundColor:[UIColor colorWithRed:55/255.0 green:57/255.0 blue:64/255.0 alpha:1]];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@headerView_height);
    }];
    self.topView = topView;
    
    self.cameraPostionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraPostionButton.tag = 3;
    [self.cameraPostionButton setImage:[UIImage imageNamed:@"btn_flip_b"] forState:UIControlStateNormal];
    
    [topView addSubview:self.cameraPostionButton];
    [self.cameraPostionButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraPostionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).offset(5);
        make.right.equalTo(topView).offset(-20);
        make.height.equalTo(@40);
        make.width.equalTo(@60);
    }];
    
    
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.tag = 2;
    [self.flashButton setImage:[UIImage imageNamed:@"flashing_auto"] forState:UIControlStateNormal];
    [self.flashButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:self.flashButton];
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).offset(5);
        make.left.equalTo(topView).offset(15);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    self.delayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delayButton.tag = 1;
    [self.delayButton setTitleColor:[UIColor colorWithRed:210/255.0 green:41/255.0 blue:122/255.0 alpha:1] forState:UIControlStateNormal];
    [self.delayButton setBackgroundImage:[UIImage imageNamed:@"delay_off"] forState:UIControlStateNormal];
    [self.delayButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.delayButton];
    [self.delayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.centerX.equalTo(topView);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
}

-(void) layoutBottomView{
    self.bottomView = [[UIView alloc] init];
    [self.bottomView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.equalTo(@bottomView_height);
    }];
    
    UIView * bottomView = self.bottomView;
    
    // last photo view
    self.lastPhoto = [[UIImageView alloc] init];
    UIControl * lastPhotoControl = [[UIControl alloc] init];
    
    [lastPhotoControl addTarget:self action:@selector(showPhotos) forControlEvents:UIControlEventTouchUpInside];
    self.lastPhoto.contentMode = UIViewContentModeCenter;
    self.lastPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [lastPhotoControl addSubview:self.lastPhoto];
    self.lastPhotoControl = lastPhotoControl;
    [bottomView addSubview:lastPhotoControl];
    [lastPhotoControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(20);
        make.bottom.equalTo(bottomView).offset(-12);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [self.lastPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(lastPhotoControl);
    }];
    
    // takebutton
    self.takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.takeButton.backgroundColor = [UIColor clearColor];
    [self.takeButton setBackgroundImage:[UIImage imageNamed:@"Camera_take"] forState:UIControlStateNormal];
    
    [self.takeButton addTarget:self action:@selector(takeSnap) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.takeButton];
    [self.takeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView).offset(-10);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.centerX.equalTo(bottomView);
    }];
    
    // beauty button
    self.beautyButton = [[UIButton alloc] init];
    [self.beautyButton addTarget:self action:@selector(showHideFilters) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.beautyButton];
    [self.beautyButton setImage:[UIImage imageNamed:@"btn_beauty"] forState:UIControlStateNormal];
    [self.beautyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView).offset(-20);
        make.bottom.equalTo(bottomView).offset(-12);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void) loaddata{
    NSArray * photos = [[UBImageManager manager] listImageFilePath];
    if (photos && photos.count > 0) {
        [self.imageList addObjectsFromArray:photos];
        NSString * imgPath = [photos objectAtIndex:0];
        UIImage * image = [[UBImageManager manager] loadImage:imgPath];
        
        __weak __typeof(self) weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.lastPhoto setImage:image];
        });
    }
}

-(void) sliderChanged:(id)sender{
    self.cameraManager.combiIntensity = self.bfSlider.value;
}


#pragma mark Handle Gesture
- (void)pan:(UIPanGestureRecognizer *)gesture{
    if (![self.cameraManager.currentFilterGroup.title isEqualToString:@"美肤"]) {
        return;
    }
    
    CGPoint translation = [gesture translationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan){
        self.lastPanPoint = translation;
        self.panHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.panHud.mode = MBProgressHUDModeText;
        self.panHud.labelText = [NSString stringWithFormat:@"%0.0lf%%", self.cameraManager.combiIntensity * 100];
        self.panHud.labelFont = [UIFont systemFontOfSize: 20];
        self.panHud.yOffset = -self.view.bounds.size.height/3;
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateFailed ||
        gesture.state == UIGestureRecognizerStateCancelled ||
        gesture.state == UIGestureRecognizerStateEnded) {
        if (self.panHud) {
            [self.panHud hide:YES];
            self.panHud = nil;
        }
    }
    
    BOOL gestureHorizontal = NO;
    if (translation.y ==0.0)
        gestureHorizontal = YES;
    else
        gestureHorizontal = (fabs(translation.x / translation.y) >5.0);
    
    if (gestureHorizontal) {
        return;
    }
    
    // avoid intensive update
    if (fabs(translation.y - self.lastPanPoint.y) < self.panDt) {
        return;
    }
    
    self.lastPanPoint = translation;
    
    CGFloat step = translation.y > 0 ?  -0.02 : 0.02;
    CGFloat value = self.cameraManager.combiIntensity + step;
    
    value  = value > 1 ? 1 : value;
    
    value  = value < 0 ? 0 : value;
    
    self.cameraManager.combiIntensity = value;
    
    self.panHud.labelText = [NSString stringWithFormat:@"%0.0lf%%", self.cameraManager.combiIntensity * 100];
    
    NSLog(@"update step: %lf, value: %lf, intensity: %lf, text:%@ ", step, value,self.cameraManager.combiIntensity, self.panHud.labelText);
    
    //    NSLog(@"update value : %@", self.panHud.labelText);
}

- (void)swipe:(UISwipeGestureRecognizer *)swipe{
    NSString * message = nil;
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionUp:
        {
            CGFloat value = self.cameraManager.combiIntensity + 0.1;
            self.cameraManager.combiIntensity = value > 1 ? 1 : value;
            message = value > 1 ? @"已经最强" : @"加强效果";
        }
            break;
        case UISwipeGestureRecognizerDirectionDown:
        {
            CGFloat value = self.cameraManager.combiIntensity - 0.1;
            self.cameraManager.combiIntensity = value < 0 ? 0 : value;
            message = value < 0 ? @"已经最弱" : @"减弱效果";
        }
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        {
            NSInteger findex = self.cameraManager.filterIndex + 1;
            self.cameraManager.filterIndex = findex >= self.cameraManager.filters.count ? 0 : findex;
            [self.filterChooserView updateSelectFilter:self.cameraManager.filterIndex];
            message = self.cameraManager.currentFilterGroup.title;
        }
            break;
        case UISwipeGestureRecognizerDirectionRight:
        {
            NSInteger findex = self.cameraManager.filterIndex - 1;
            self.cameraManager.filterIndex = findex < 0 ? self.cameraManager.filters.count -1 : findex;
            [self.filterChooserView updateSelectFilter:self.cameraManager.filterIndex];
            message = self.cameraManager.currentFilterGroup.title;
        }
            break;
        default:
            break;
    }
    
    if (message) {
        [self showMessage:message];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch{
    static CGFloat lastScale = 0;
    
    if (pinch.state == UIGestureRecognizerStateBegan) {
        lastScale = 1;
    }
    
    NSLog(@"adjust scale: %lf last: %lf ",pinch.scale, lastScale);
    CGFloat dt = 0;
    if (pinch.scale > 1) {
        if ( fabs(lastScale - pinch.scale) < 0.2 ){
            return;
        }
        dt = lastScale < pinch.scale? 0.3: -0.3;
        lastScale = pinch.scale;
    }
    if (pinch.scale < 1) {
        
        if ( fabs(lastScale - pinch.scale) < 0.03 ){
            return;
        }
        
        dt = lastScale > pinch.scale? -0.2: 0.2;
        lastScale = pinch.scale;
    }
    
    self.cameraManager.zoomFactor += dt;
    NSLog(@"adjust scale: %lf len: %ld",pinch.scale, (long)self.cameraManager.zoomFactor);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private methods
-(void) showHideFilters{
    NSNumber *height = self.showFilterView?@20:@100;
    [self.filterChooserView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.showFilterView = !weakSelf.showFilterView;
    }];
}

-(void) showMessage:(NSString *)message{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.minSize = CGSizeMake(120, 80);
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.labelText = message;
    
    [hud hide:YES afterDelay:0.5];
}
#pragma mark 延迟
-(void) updateDelaySetting{
    if (self.delaySec == 0) {
        self.delaySec = 3;
    }else if (self.delaySec ==3){
        self.delaySec = 5;
    }else{
        self.delaySec = 0;
    }
    
    if (self.delaySec == 0){
        [self.delayButton setBackgroundImage:[UIImage imageNamed:@"delay_off"] forState:UIControlStateNormal];
        [self.delayButton setTitle:nil forState:UIControlStateNormal];
        
    }else{
        [self.delayButton setBackgroundImage:[UIImage imageNamed:@"delay_on"] forState:UIControlStateNormal];
        NSString * delaytext = [NSString stringWithFormat:@"%ld", (unsigned long)self.delaySec];
        [self.delayButton setTitle:delaytext forState:UIControlStateNormal];
    }
}


#pragma mark 拍照
-(void) takeSnap{
    
    
    [self showDelayView:self.delaySec];
}

-(void)doSnap{

    __weak __typeof(self) weakSelf = self;
    [self.cameraManager snapshotSuccess:^(UIImage *image) {
        
        UBPictureEditController * vc = [[UBPictureEditController alloc] init];
        vc.presentImage = image;
        vc.saveImage = ^(UIImage * outImage){
            NSString * path = [[UBImageManager manager] storeImage:outImage];
            [weakSelf.lastPhoto setImage:outImage];
            [weakSelf.imageList insertObject:path atIndex:0];
        };
        
        vc.willDismiss = ^(){
            [[LMCameraManager cameraManager] startCamera];
            [[LMCameraManager cameraManager] setFilterAtIndex:0];
            [weakSelf.filterChooserView updateSelectFilter:0];
        } ;
        
        [weakSelf presentViewController:vc animated:YES completion:^{
            [[LMCameraManager cameraManager] stopCamera];
        }];
        
    } snapshotFailure:^{
        NSLog(@"拍照失败");
    }];
}

-(BOOL) showDelayView: (NSInteger) delay{
    if (delay < 1) {
        [self doSnap];
        return YES;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tickSound" ofType:@"wav"];
        if (path) {
            //注册声音到系统
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        }
    });
    AudioServicesPlaySystemSound(shake_sound_male_id);
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.square = YES;
    hud.minSize = CGSizeMake(100, 100);
    hud.color = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:0.8];
    hud.labelColor = [UIColor redColor];
    hud.labelText = [NSString stringWithFormat:@"%ld", (long)delay];
    hud.labelFont = [UIFont boldSystemFontOfSize:36];
    
    delay -=1;
    
    __weak __typeof(self) weakSelf = self;
    hud.completionBlock = ^{
        [weakSelf showDelayView:delay];
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
    });;
    
    return NO;
}


#pragma mark show photo browser
-(void)showPhotos{
    if (self.imageList.count == 0) {
        return;
    }
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = self.lastPhotoControl; // 原图的父控件
    browserVc.imageCount = self.imageList.count; // 图片总数
    browserVc.currentImageIndex = 0;
    browserVc.noGroupView =YES;
    browserVc.delegate = self;
    [browserVc show];
}

#pragma mark 摄像头位置按钮
- (LMCameraManager *)cameraManager {
    return [LMCameraManager cameraManager];
}

- (LMFilterChooserView *)filterChooserView {
    if (!_filterChooserView) {
        float screen_width = [UIScreen mainScreen].bounds.size.width;
        float screen_height = [UIScreen mainScreen].bounds.size.height;
        LMFilterChooserView *scrollView = [[LMFilterChooserView alloc] initWithFrame:CGRectMake(0, screen_height  - 130.0f, screen_width, 100.0f)];
        __weak __typeof(self) weakSelf = self;
        [scrollView addSelectedEvent:^(GPUImageFilterGroup *filter, NSInteger idx) {
            
            [weakSelf.cameraManager setFilterAtIndex:idx];
            [weakSelf showHideFilters];
        }];
        _filterChooserView = scrollView;
    }
    
    return _filterChooserView;
}


#pragma mark 按钮点击事件
- (void)selectedButton:(UIButton *)button {
    
    switch (button.tag) {
        case 1:
            [self updateDelaySetting];
            break;
        case 2:
            [self changeFlashMode:button];
            break;
        case 3:
            [self changeCameraPostion];
            break;
            
        default:
            break;
    }
}



#pragma mark 改变摄像头位置
- (void)changeCameraPostion {
    if (self.cameraManager.position == LMCameraManagerDevicePositionBack)
        self.cameraManager.position = LMCameraManagerDevicePositionFront;
    else
        self.cameraManager.position = LMCameraManagerDevicePositionBack;
    
}

#pragma mark 改变闪光灯状态
- (void)changeFlashMode:(UIButton *)button {
    switch (self.cameraManager.flashMode) {
        case LMCameraManagerFlashModeAuto:
            self.cameraManager.flashMode = LMCameraManagerFlashModeOn;
            [button setImage:[UIImage imageNamed:@"flashing_on"] forState:UIControlStateNormal];
            break;
        case LMCameraManagerFlashModeOff:
            self.cameraManager.flashMode = LMCameraManagerFlashModeAuto;
            [button setImage:[UIImage imageNamed:@"flashing_auto"] forState:UIControlStateNormal];
            break;
        case LMCameraManagerFlashModeOn:
            self.cameraManager.flashMode = LMCameraManagerFlashModeOff;
            [button setImage:[UIImage imageNamed:@"flashing_off"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return self.lastPhoto.image;
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    
    NSString * urlStr = [self.imageList objectAtIndex:index];
    urlStr = [[UBImageManager manager].storePath stringByAppendingPathComponent:urlStr];
    
    return [NSURL fileURLWithPath:urlStr];
}

-(void) deletePhoto:(HZPhotoBrowser *)browser at:(NSInteger)index{
    NSString * fileName = [self.imageList objectAtIndex:index];
    
    if(![[UBImageManager manager] deleteImage:fileName]){
        return;
    }
    
    [self.imageList removeObjectAtIndex:index];
    browser.imageCount = self.imageList.count;
    if (self.imageList.count  == 0) {
        [browser dismissViewControllerAnimated:YES completion:nil];
        [self.lastPhoto setImage:nil];
        return;
    }
    
    if (browser.currentImageIndex == self.imageList.count) {
        browser.currentImageIndex -=1;
    }
    
    [browser refresh];
}
@end
