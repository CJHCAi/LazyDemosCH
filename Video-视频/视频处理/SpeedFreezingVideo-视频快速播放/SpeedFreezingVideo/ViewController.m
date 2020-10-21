//
//  ViewController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/14.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "ViewController.h"
#import "CaptureVideoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VideoEditingController.h"
#import "UIColor+hexColor.h"
#import "SDCycleScrollView.h"
#import "AboutController.h"
#import "UIView+ExtendTouchArea.h"

#define SCROLLING_IMAGEVIEW_COUNT 11
#define SCROLLING_IMAGEVIEW_DISPLAY_NUM 3

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet UILabel *libraryLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *imageScrollViewPageControl;
@property (strong, nonatomic) SDCycleScrollView *sdCycleScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *libraryButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraButtonTralingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *libraryTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *libraryButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *libraryCenterYConstraint;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self setupNavigationBarItem];
    [self configureLayout];
    [self observeMainFunctionButton];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self modifyStatusBar];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)configureLayout {
    [self screenAdaptive];
    [self updateButtonPosition];
    [self configureImageScrollView];
    [self extendTouchArea];
}

- (void)configureImageScrollView {
    NSArray *imageNameList = [self randomImageNameListWithCount:SCROLLING_IMAGEVIEW_DISPLAY_NUM];
    [_imageScrollViewPageControl setNumberOfPages:imageNameList.count];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenWidth, screenWidth) delegate:self placeholderImage:nil];
    _sdCycleScrollView.autoScroll = YES;
    _sdCycleScrollView.showPageControl = NO;
    _sdCycleScrollView.localizationImageNamesGroup = imageNameList;
    [_sdCycleScrollView setBackgroundColor:[UIColor whiteColor]];
    [_imageScrollView addSubview:_sdCycleScrollView];
}

- (void)screenAdaptive {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat marginRatio = 1;
    CGFloat widthRatio = 1;
    CGFloat fontSize = 20.f;
    if (screenHeight == 480) {//i4
        marginRatio = 0.4f;
        widthRatio = 0.6f;
        fontSize = 14.f;
        _libraryCenterYConstraint.constant = -10;
    } else if (screenHeight == 568) {//i5
        marginRatio = 0.5f;
        widthRatio = 0.7f;
        fontSize = 16.f;
        _libraryCenterYConstraint.constant = -10;
    }
    _libraryTopConstraint.constant *= marginRatio;
    _libraryButtonWidthConstraint.constant *= widthRatio;
    [_libraryLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [_cameraLabel setFont:[UIFont systemFontOfSize:fontSize]];
}

- (void)extendTouchArea {
    int extendMargin = 0.4 * _libraryButtonWidthConstraint.constant;
    int bottomMarigin = 0.7 * _libraryButtonWidthConstraint.constant;
    [_libraryButton setTouchExtendInset:UIEdgeInsetsMake(-extendMargin, -extendMargin, -bottomMarigin, -extendMargin)];
    [_cameraButton setTouchExtendInset:UIEdgeInsetsMake(-extendMargin, -extendMargin, -bottomMarigin, -extendMargin)];
}

- (NSArray *)randomImageNameListWithCount:(int)count {
    NSMutableArray *imageNameList = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        int imagePostfix = arc4random() % SCROLLING_IMAGEVIEW_COUNT;
        [imageNameList addObject:[NSString stringWithFormat:@"mianPageBackground%.2d@2x", imagePostfix]];
    }
    return imageNameList;
}

- (void)updateButtonPosition {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat buttonMargin = (screenWidth - 2*_libraryButtonWidthConstraint.constant) / 4;
    _libraryButtonLeadingConstraint.constant = buttonMargin;
    _cameraButtonTralingConstraint.constant = buttonMargin;
}

- (void)modifyStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setupNavigationBarItem {
    self.navigationController.navigationBar.translucent = NO;
    UIButton *rightTopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [rightTopButton setTitle:@"Help" forState:UIControlStateNormal];
    [rightTopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightTopButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [rightTopButton addTarget:self action:@selector(clickRightTopButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightTopButton];
}

- (void)observeMainFunctionButton {
    [_libraryButton addTarget:self action:@selector(functionButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_libraryButton addTarget:self action:@selector(functionButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [_cameraButton addTarget:self action:@selector(functionButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_cameraButton addTarget:self action:@selector(functionButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
}

- (void)functionButtonTouchDown:(UIButton *)sender {
    if ([sender isEqual:_libraryButton]) {
        [self changeLabelPressStatus:_libraryLabel isPress:YES];
    } else if ([sender isEqual:_cameraButton]) {
        [self changeLabelPressStatus:_cameraLabel isPress:YES];
    }
}

- (void)functionButtonTouchDragExit:(UIButton *)sender {
    if ([sender isEqual:_libraryButton]) {
        [self changeLabelPressStatus:_libraryLabel isPress:NO];
    } else if ([sender isEqual:_cameraButton]) {
        [self changeLabelPressStatus:_cameraLabel isPress:NO];
    }
}

- (void)changeLabelPressStatus:(UILabel *)targetLabel isPress:(BOOL)isPress {
    if (isPress) {
        [targetLabel setTextColor:[UIColor hexColor:@"7f7f7f"]];
    } else {
        [targetLabel setTextColor:[UIColor whiteColor]];
    }
}
/**help点击*/
- (void)clickRightTopButton:(id)sender {
    AboutController *aboutController = [[AboutController alloc] init];
    [self.navigationController pushViewController:aboutController animated:YES];
}
/**library按钮的点击*/
- (IBAction)clickLibraryButton:(id)sender {
    [self changeLabelPressStatus:_libraryLabel isPress:NO];
    UIImagePickerController *myImagePickerController = [[UIImagePickerController alloc] init];
    myImagePickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    myImagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie, nil];
    myImagePickerController.delegate = self;
    myImagePickerController.editing = NO;
    [self presentViewController:myImagePickerController animated:YES completion:nil];
}
/**camara按钮的点击*/
- (IBAction)clickCameraButton:(id)sender {
    [self changeLabelPressStatus:_cameraLabel isPress:NO];
    CaptureVideoViewController *controller = [[CaptureVideoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *infoKey = UIImagePickerControllerMediaURL;
    NSURL *assetUrl = [info objectForKey:infoKey];
    [picker dismissViewControllerAnimated:YES completion:^{
        VideoEditingController *editingController = [[VideoEditingController alloc] initWithAssetUrl:assetUrl];
        [self.navigationController pushViewController:editingController animated:YES];
    }];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat scrollContentOffsetX = scrollView.contentOffset.x;
//    self.imageScrollViewPageControl.currentPage = [[NSString stringWithFormat:@"%.0f", (scrollContentOffsetX / [[UIScreen mainScreen] bounds].size.width)] intValue];
//}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
//    if ((cycleScrollView.localizationImageNamesGroup.count - 1) == index) {//last
//        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:[self randomImageNameListWithCount:SCROLLING_IMAGEVIEW_DISPLAY_NUM-1]];
//        [mutArray addObject:[cycleScrollView.localizationImageNamesGroup objectAtIndex:index]];
//        cycleScrollView.localizationImageNamesGroup = mutArray;
//    } else if (0 == index) {//first
//        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:cycleScrollView.localizationImageNamesGroup];
//        [mutArray removeLastObject];
//        [mutArray addObject:[[self randomImageNameListWithCount:1] firstObject]];
//        cycleScrollView.localizationImageNamesGroup = mutArray;
//    }
    _imageScrollViewPageControl.currentPage = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
