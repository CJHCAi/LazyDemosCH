//
//  SDCutFunctionViewController.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/24.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDCutFunctionViewController.h"
#import "SDRevealView.h"
#import "SDCutEditPhotoControllerItemsView.h"

#import "SDCutEditImageViewModel.h"

#import "TOCropViewControllerTransitioning.h"
#import "TOActivityCroppedImageProvider.h"
#import "UIImage+CropRotate.h"
#import "TOCroppedImageAttributes.h"


@interface SDCutFunctionViewController ()<TOCropViewDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) SDCutEditPhotoControllerItemsView * cutFunctionView;

@property (nonatomic, strong) SDCutEditImageViewModel * cutViewModel;


/* The target image */
@property (nonatomic, readwrite) UIImage *image;

/* The cropping style of the crop view */
@property (nonatomic, assign, readwrite) TOCropViewCroppingStyle croppingStyle;


@property (nonatomic, strong, readwrite) TOCropView *cropView;
@property (nonatomic, strong) UIView *toolbarSnapshotView;

/* Transition animation controller */
@property (nonatomic, copy) void (^prepareForTransitionHandler)(void);
@property (nonatomic, strong) TOCropViewControllerTransitioning *transitionController;
@property (nonatomic, assign) BOOL inTransition;
@property (nonatomic, assign) BOOL initialLayout;

/* If pushed from a navigation controller, the visibility of that controller's bars. */
@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, assign) BOOL toolbarHidden;



/* On iOS 7, the popover view controller that appears when tapping 'Done' */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, strong) UIPopoverController *activityPopoverController;


@end

@implementation SDCutFunctionViewController


- (instancetype)initWithFinishBlock:(SDDiyImageFinishBlock)finishBlock
{
    self = [super initWithFinishBlock:finishBlock];
    if (self) {
        _transitionController = [[TOCropViewControllerTransitioning alloc] init];
        
        _aspectRatioPreset = SDCutFunctionFree;
        _rotateClockwiseButtonHidden = YES;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.image = self.showImageView;
    
    [self sd_configView];
    
    [self sd_configData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self resetCropViewLayout];
}


#pragma mark - config view
- (void)sd_configView
{
    [self cutFunctionView];
    
    
    [self.view addSubview:self.cropView];
    
    self.transitioningDelegate = self;

}



- (CGRect)frameForCropViewWithVerticalLayout:(BOOL)verticalLayout
{
    //On an iPad, if being presented in a modal view controller by a UINavigationController,
    //at the time we need it, the size of our view will be incorrect.
    //If this is the case, derive our view size from our parent view controller instead
    
    CGRect bounds = CGRectZero;
    if (self.parentViewController == nil) {
        bounds = self.view.bounds;
    }
    else {
        bounds = self.parentViewController.view.bounds;
    }
    
    CGRect frame = CGRectZero;
    if (!verticalLayout) {
        frame.origin.x = 44.0f;
        frame.origin.y = 0.0f;
        frame.size.width = CGRectGetWidth(bounds) - 44.0f;
        frame.size.height = CGRectGetHeight(bounds);
    }
    else {
        frame.origin.x = 0.0f;
        
        frame.size.width = CGRectGetWidth(bounds);
        frame.size.height = CGRectGetHeight(bounds) - 44.0f;
    }
    
    return frame;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.cropView moveCroppedContentToCenterAnimated:NO];
    
}

#pragma mark - config data
- (void)sd_configData
{
    self.cutViewModel = (SDCutEditImageViewModel *)[SDCutEditImageViewModel modelViewController:self];
    
    self.cutFunctionView.cancelModel = self.cutViewModel.cancelModel;
    self.cutFunctionView.sureModel = self.cutViewModel.sureModel;
    self.cutFunctionView.cutModel = self.cutViewModel.cutModel;
    
    self.cutFunctionView.cutList = self.cutViewModel.cutList;
    
    SDCutFunctionModel * resetModel = [self.cutViewModel.cutList firstObject];
    @weakify_self;
    [resetModel.done_subject subscribeNext:^(id x) {
        @strongify_self;
        [self resetCropViewLayout];
    }];
    
}


#pragma mark - Reset -
- (void)resetCropViewLayout
{
    BOOL animated = (self.cropView.angle == 0);
    
    if (self.resetAspectRatioEnabled) {
        self.aspectRatioLockEnabled = NO;
    }
    
    [self.cropView resetLayoutToDefaultAnimated:animated];
    
    
    [[self cutFunctionView] sd_resetAction];
    
}




#pragma mark - TOCropViewDelegate

- (void)cropViewDidBecomeResettable:(nonnull TOCropView *)cropView
{
    SDCutFunctionModel * model = self.cutViewModel.cutList[0];
    model.isSelected = true;
    
    
    
}
- (void)cropViewDidBecomeNonResettable:(nonnull TOCropView *)cropView
{
    SDCutFunctionModel * model = self.cutViewModel.cutList[0];
    model.isSelected = false;
}
#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if (self.navigationController || self.modalTransitionStyle == UIModalTransitionStyleCoverVertical) {
        return nil;
    }
    
    self.cropView.simpleRenderMode = YES;
    
    __weak typeof (self) weakSelf = self;
    self.transitionController.prepareForTransitionHandler = ^{
        typeof (self) strongSelf = weakSelf;
        TOCropViewControllerTransitioning *transitioning = strongSelf.transitionController;
        
        transitioning.toFrame = [strongSelf.cropView convertRect:strongSelf.cropView.cropBoxFrame toView:strongSelf.view];
        if (!CGRectIsEmpty(transitioning.fromFrame) || transitioning.fromView) {
            strongSelf.cropView.croppingViewsHidden = YES;
        }
        
        if (strongSelf.prepareForTransitionHandler)
            strongSelf.prepareForTransitionHandler();
        
        strongSelf.prepareForTransitionHandler = nil;
    };
    
    self.transitionController.isDismissing = NO;
    return self.transitionController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (self.navigationController || self.modalTransitionStyle == UIModalTransitionStyleCoverVertical) {
        return nil;
    }
    
    __weak typeof (self) weakSelf = self;
    self.transitionController.prepareForTransitionHandler = ^{
        typeof (self) strongSelf = weakSelf;
        TOCropViewControllerTransitioning *transitioning = strongSelf.transitionController;
        
        if (!CGRectIsEmpty(transitioning.toFrame) || transitioning.toView)
            strongSelf.cropView.croppingViewsHidden = YES;
        else
            strongSelf.cropView.simpleRenderMode = YES;
        
        if (strongSelf.prepareForTransitionHandler)
            strongSelf.prepareForTransitionHandler();
    };
    
    self.transitionController.isDismissing = YES;
    return self.transitionController;
}


#pragma mark - action

- (void)onSureAction
{
    CGRect cropFrame = self.cropView.imageCropFrame;
    NSInteger angle = self.cropView.angle;
    UIImage *image = [self.image croppedImageWithFrame:cropFrame angle:angle circularClip:false];
    
    self.showImageView = image;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
    if (self.diyFinishBlock) {
        self.diyFinishBlock(self.showImageView);
    }
}

#pragma mark - setter
- (void)setAspectRatioPreset:(SDCutFunctionType)aspectRatioPreset
{
    CGSize aspectRatio = CGSizeZero;
    
    _aspectRatioPreset = aspectRatioPreset;
    
    if (self.aspectRatioPreset == SDCutFunctionFree) {
        aspectRatio = CGSizeZero;
    }else if (self.aspectRatioPreset == SDCutFunction1_1){
        aspectRatio = CGSizeMake(1.f, 1.f);
    }else if (self.aspectRatioPreset == SDCutFunction3_2){
        aspectRatio = CGSizeMake(3.0f, 2.0f);
    }else if (self.aspectRatioPreset == SDCutFunction4_3){
        aspectRatio = CGSizeMake(4.0f, 3.f);
    }else if (self.aspectRatioPreset == SDCutFunction5_4){
        aspectRatio = CGSizeMake(5.f, 4.f);
    }else if (self.aspectRatioPreset == SDCutFunction16_9){
        aspectRatio = CGSizeMake(16.f, 9.f);
    }
    
    [self.cropView setAspectRatio:aspectRatio animated:YES];
    
}

#pragma mark - getter

- (SDCutEditPhotoControllerItemsView *)cutFunctionView
{
    if (!_cutFunctionView) {
        SDCutEditPhotoControllerItemsView * theView = [[SDCutEditPhotoControllerItemsView alloc] init];
        
        theView.frame = (CGRect){{0,SCREENH_HEIGHT - theView.frame.size.height},theView.frame.size};
        
        [self.view addSubview:theView];
        _cutFunctionView = theView;
    }
    return _cutFunctionView;
}
- (TOCropView *)cropView {
    if (!_cropView) {
        _cropView = [[TOCropView alloc] initWithCroppingStyle:self.croppingStyle image:self.image];
        _cropView.delegate = self;
        _cropView.frame = (CGRect){CGPointZero,{SCREEN_WIDTH,SCREENH_HEIGHT - MAXSize(310)}};
        _cropView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _cropView;
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
