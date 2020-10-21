//
//  UBPictureEditController.m
//  BeautifyCamera
//
//  Created by sky on 2017/1/22.
//  Copyright © 2017年 guikz. All rights reserved.
//

#import "UBPictureEditController.h"
#import <Masonry/Masonry.h>
#import "LMCameraFilters.h"
#import "LMFilterChooserView.h"
#import "LMPictureFilterManager.h"
#import "MBProgressHUD.h"
#import "TOCropViewController.h"
#import "LMCameraManager.h"




@interface UBPictureEditController ()<UIScrollViewDelegate, TOCropViewControllerDelegate>

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIScrollView * pictureScrollView;
@property (nonatomic, strong) UIImageView * pictureView;
@property (nonatomic, strong) UIImage * outputImage;

@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIButton * saveBtn;
@property (nonatomic, strong) UIButton * filterBtn;
@property (nonatomic, strong) UIButton * cropBtn;

@property (nonatomic, strong) LMFilterChooserView * filterChooserView;
@property (nonatomic, assign) BOOL showFilterView;

@property (nonatomic, assign) NSUInteger delaySec;
@property (nonatomic, assign) CGPoint lastPanPoint;
@property (nonatomic, assign) CGFloat panDt;
@property (nonatomic, strong) MBProgressHUD * panHud;

@property (nonatomic, strong) LMFilterGroup * currentFilter;

@property (nonatomic, assign) CGRect croppedFrame;
@property (nonatomic, assign) NSInteger angle;


@end

@implementation UBPictureEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    
    self.pictureScrollView = [[UIScrollView alloc] init];
    
    [self.view addSubview:self.pictureScrollView];
    [self.pictureScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.bottom.equalTo(self.view).offset(-80);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    self.pictureScrollView.maximumZoomScale = 5.0;
    self.pictureScrollView.minimumZoomScale = 1.0;
    
    CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - 144);
    self.pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];

    [self.pictureScrollView addSubview:self.pictureView];
    
    self.pictureView.contentMode = UIViewContentModeScaleAspectFit;
    [self.pictureView setImage:self.presentImage];
    
    self.pictureScrollView.delegate = self;
    
    [self setupHeaderView];
    [self setupBottomView];
    
    [self.view addSubview:self.filterChooserView];
    [self.filterChooserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-80);
        make.height.equalTo(@100);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [self.filterChooserView addFilters:[LMPictureFilterManager pictureManager].filters];
    self.showFilterView = YES;
    
    self.pictureView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.pictureView addGestureRecognizer:pan];
}

-(void) setupHeaderView{
    self.headerView = [[UIView alloc] init];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]];
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.height.equalTo(@64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
   
}

-(void) setupBottomView{
    self.bottomView = [[UIView alloc] init];
    [self.bottomView setBackgroundColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.height.equalTo(@80);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    self.backBtn = [[UIButton alloc] init];
    [self.backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [self.backBtn setContentMode:UIViewContentModeScaleAspectFit];
    
    [self.backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.backBtn];
    
    
    self.filterBtn = [[UIButton alloc] init];
    [self.filterBtn setImage:[UIImage imageNamed:@"btn_beauty"] forState:UIControlStateNormal];
    [self.filterBtn setContentMode:UIViewContentModeScaleAspectFit];
    self.filterBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.filterBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

    [self.filterBtn addTarget:self action:@selector(showFilterClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.filterBtn];
    
    self.saveBtn = [[UIButton alloc] init];
    [self.saveBtn setImage:[UIImage imageNamed:@"btn_save"] forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.saveBtn];
    
    self.cropBtn = [[UIButton alloc] init];
    [self.cropBtn setImage:[UIImage imageNamed:@"btn_crop"] forState:UIControlStateNormal];
    [self.cropBtn addTarget:self action:@selector(showCropView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.cropBtn];

    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView).offset(-15);
        make.left.equalTo(self.bottomView).offset (20);
        make.right.equalTo(self.filterBtn.mas_left).offset (-20);
        make.height.equalTo(@40);
        make.width.equalTo(self.filterBtn);
        make.width.equalTo(self.cropBtn);
        make.width.equalTo(self.saveBtn);
    }];
    
   
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView).offset(-15);
        make.left.equalTo(self.backBtn.mas_right).offset (20);
        make.right.equalTo(self.cropBtn.mas_left).offset (-20);
        make.height.equalTo(@40);
        make.width.equalTo(self.backBtn);
    }];
    
    [self.cropBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView).offset(-15);
        make.left.equalTo(self.filterBtn.mas_right).offset (20);
        make.right.equalTo(self.saveBtn.mas_left).offset (-20);
        make.height.equalTo(@40);
        make.width.equalTo(self.backBtn);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView).offset(-15);
        make.left.equalTo(self.cropBtn.mas_right).offset (20);
        make.right.equalTo(self.bottomView).offset (-20);
        make.height.equalTo(@40);
        make.width.equalTo(self.backBtn);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backClick:(id)sender{
    if (self.willDismiss){
        self.willDismiss();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)showFilterClick:(id)sender{
    NSNumber *height = self.showFilterView?@0:@100;
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

-(IBAction)saveClick:(id)sender{
    if (self.saveImage) {
        self.saveImage(self.outputImage);
    }
    
    if (self.willDismiss){
        self.willDismiss();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showCropView{
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:self.outputImage];
    cropController.delegate = self;
    CGRect viewFrame = [self.view convertRect:self.pictureView.frame toView:self.navigationController.view];
    [cropController presentAnimatedFromParentViewController:self
                                                  fromImage:self.outputImage
                                                   fromView:nil
                                                  fromFrame:viewFrame
                                                      angle:0
                                               toImageFrame:self.croppedFrame
                                                      setup:^{ self.pictureView.hidden = YES; }
                                                 completion:nil];

}

#pragma mark - Cropper Delegate -

-(void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled{
    [self updateImageViewWithImage:self.presentImage fromCropViewController:cropViewController];
}


- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.outputImage = image;
//    self.croppedFrame = cropRect;
    self.angle = angle;
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.croppedFrame = cropRect;
    self.angle = angle;
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    self.pictureView.image = image;
    self.presentImage = image;
    [self layoutImageView];
    
    if (cropViewController.croppingStyle != TOCropViewCroppingStyleCircular) {
        self.pictureView.hidden = YES;
        [cropViewController dismissAnimatedFromParentViewController:self
                                                   withCroppedImage:image
                                                             toView:self.pictureView
                                                            toFrame:CGRectZero
                                                              setup:^{ [self layoutImageView]; }
                                                         completion:
         ^{
             self.pictureView.hidden = NO;
         }];
    }
}

- (void)layoutImageView
{
    if (self.pictureView.image == nil)
        return;
    
    CGFloat padding = 0.0f;
    
    CGRect viewFrame = self.pictureScrollView.bounds;
    viewFrame.size.width -= (padding * 2.0f);
    viewFrame.size.height -= ((padding * 2.0f));
    
    CGRect imageFrame = CGRectZero;
    imageFrame.size = self.pictureView.image.size;
    
    if (self.pictureView.image.size.width > viewFrame.size.width ||
        self.pictureView.image.size.height > viewFrame.size.height)
    {
        CGFloat scale = MIN(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height);
        imageFrame.size.width *= scale;
        imageFrame.size.height *= scale;
        imageFrame.origin.x = (CGRectGetWidth(self.pictureScrollView.bounds) - imageFrame.size.width) * 0.5f;
        imageFrame.origin.y = (CGRectGetHeight(self.pictureScrollView.bounds) - imageFrame.size.height) * 0.5f;
        self.pictureView.frame = imageFrame;
    }
    else {
        self.pictureView.frame = imageFrame;
        self.pictureView.center = (CGPoint){CGRectGetMidX(self.pictureScrollView.bounds), CGRectGetMidY(self.pictureScrollView.bounds)};
    }
}

#pragma mark scrollview delegate
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.pictureView;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return NO;
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
    CGFloat value = self.currentFilter.combiIntensity + step;
    
    value  = value > 1 ? 1 : value;
    
    value  = value < 0 ? 0 : value;
    
    self.currentFilter.combiIntensity = value;
    if (self.currentFilter) {
         [self applyGpuFilter:self.currentFilter];
    }
    
    self.panHud.labelText = [NSString stringWithFormat:@"%0.0lf%%", self.currentFilter.combiIntensity * 100];
    
    NSLog(@"update step: %lf, value: %lf, intensity: %lf, text:%@ ", step, value,self.currentFilter.combiIntensity, self.panHud.labelText);
    
    //    NSLog(@"update value : %@", self.panHud.labelText);
}

#pragma mark filterChooserView
- (LMFilterChooserView *)filterChooserView {
    if (!_filterChooserView) {
        float screen_width = [UIScreen mainScreen].bounds.size.width;
        float screen_height = [UIScreen mainScreen].bounds.size.height;
        LMFilterChooserView *scrollView = [[LMFilterChooserView alloc] initWithFrame:CGRectMake(0, screen_height  - 130.0f, screen_width, 100.0f)];
        __weak __typeof(self) weakSelf = self;
        [scrollView addSelectedEvent:^(GPUImageFilterGroup *filter, NSInteger idx) {
            weakSelf.currentFilter = (LMFilterGroup *)filter;
            [weakSelf applyGpuFilter:filter];
        }];
        _filterChooserView = scrollView;
    }
    
    return _filterChooserView;
}

-(void) applyGpuFilter:(GPUImageFilterGroup *) filter{
    @synchronized (self) {
        GPUImagePicture *gpuPicture = [[GPUImagePicture alloc] initWithImage:self.presentImage];
        
        [gpuPicture addTarget:filter];
        
        // 开始处理图片
        [filter useNextFrameForImageCapture];
        [gpuPicture processImage];
        
        // 输出处理后的图片
        self.outputImage = [filter imageFromCurrentFramebuffer];
        [gpuPicture removeAllTargets];
        
        [self.pictureView setImage:self.outputImage];
    }
}

#pragma mark private methods
-(LMCameraManager *)cameraManager{
    return [LMCameraManager cameraManager];
}

-(UIImage *) outputImage{
    if (_outputImage) {
        return _outputImage;
    }
    return self.presentImage;
}


-(void) setPresentImage:(UIImage *)presentImage{
    _presentImage = presentImage;

    self.pictureView.image = presentImage;
}


@end
