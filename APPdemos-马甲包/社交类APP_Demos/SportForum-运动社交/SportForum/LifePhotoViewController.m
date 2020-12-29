//
//  LifePhotoViewController.m
//  SportForum
//
//  Created by liyuan on 3/31/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "LifePhotoViewController.h"
#import "UIViewController+SportFormu.h"
#import "ImageEditViewController.h"
#import "CustomMenuViewController.h"
#import "UIImageView+WebCache.h"
#import "ZYQAssetPickerController.h"
#import "AlertManager.h"
#import "MWPhotoBrowser.h"

#define MAX_PUBLISH_PNG_COUNT 16

@interface LifePhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate, MWPhotoBrowserDelegate>

@end

@implementation LifePhotoViewController
{
    UIView *_viewBody;
    CSButton *_btnAddPng;
    
    ImageEditViewController* _imageEditViewController;
    CustomMenuViewController* _customMenuViewController;
    
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _imgViewArray;
    NSMutableArray * _imgBtnArray;
    NSMutableArray *_photos;
    
    BOOL _bUpdatePhotos;
    id m_processWindow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateCommonViewInParent:self.view Title:@"生活照" IsNeedBackBtn:YES];
    
    _viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = _viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    _viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    _viewBody.layer.mask = maskLayer;
    
    //Create But Right Nav Btn
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UIImageView *imgViewFinish = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [imgViewFinish setImage:[UIImage imageNamed:@"nav-finish-btn"]];
    [self.view addSubview:imgViewFinish];
    
    CSButton *btnFinish = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFinish.frame = CGRectMake(CGRectGetMinX(imgViewFinish.frame) - 5, CGRectGetMinY(imgViewFinish.frame) - 5, 45, 45);
    btnFinish.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnFinish];
    [self.view bringSubviewToFront:btnFinish];
    
    __weak typeof (self) thisPoint = self;
    
    btnFinish.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        [strongSelf setLifePhoto];
    };

    _btnAddPng = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnAddPng.frame = CGRectMake(10, 20, 60, 60);
    [_btnAddPng setImage:[UIImage imageNamed:@"add-images"] forState:UIControlStateNormal];
    [_viewBody addSubview:_btnAddPng];
    
    _btnAddPng.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        [strongSelf showPicSelect];
    };
    
    _imgUrlArray = [[NSMutableArray alloc]init];
    _imgViewArray = [[NSMutableArray alloc]init];
    _imgBtnArray = [[NSMutableArray alloc]init];
    _photos = [[NSMutableArray alloc]init];
    
    _bUpdatePhotos = NO;
    
    [self generateImageViewByUrls:_arrLifePhotos];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshImageViews];
    [MobClick beginLogPageView:@"生活照编辑 - LifePhotoViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"生活照编辑 - LifePhotoViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"生活照编辑 - LifePhotoViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"LifePhotoViewController dealloc");
}

-(void)setLifePhoto
{
    if ([_imgUrlArray count] > 0) {
        BOOL bChanged = NO;
        
        if ([_imgUrlArray count] != _arrLifePhotos.count) {
            bChanged = YES;
        }
        else
        {
            for (NSUInteger i = 0; i < [_imgUrlArray count]; i++) {
                if (![_imgUrlArray[i] isEqualToString:_arrLifePhotos[i]]) {
                    bChanged = YES;
                    break;
                }
            }
        }
        
        if (!bChanged) {
            [JDStatusBarNotification showWithStatus:@"更新数据后，才能提交哦！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleDefault];
            return;
        }
        
        id _process = [AlertManager showCommonProgress];
        
        [[SportForumAPI sharedInstance] userSetLifePhotos:_imgUrlArray FinishedBlock:^void(int errorCode, ExpEffect* expEffect)
         {
             [AlertManager dissmiss:_process];
             UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
             [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
              {
                  if (errorCode == 0)
                  {
                      BOOL bFirstSet = [[[ApplicationContext sharedInstance] getObjectByKey:@"SetLifePhotos"]boolValue];
                      
                      if (!bFirstSet) {
                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SetLifePhotos"];
                          [[ApplicationContext sharedInstance] saveObject:@(YES) byKey:@"SetLifePhotos"];
                          
                          if (expEffect != nil && expEffect.exp_coin > 0) {
                              NSString *strReward = [NSString stringWithFormat:@"恭喜上传生活照成功，奖励%lld个金币~", expEffect.exp_coin / 100000000];
                              [JDStatusBarNotification showWithStatus:strReward dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleSuccess];
                          }
                      }
                      
                      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect",nil]];
                      [self.navigationController popViewControllerAnimated:YES];
                  }
              }];
         }];
    }
    else
    {
        [JDStatusBarNotification showWithStatus:@"提交数据不能为空~" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
    }
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
        
        [_imgUrlArray removeAllObjects];
        [_imgViewArray removeAllObjects];
        [_imgBtnArray removeAllObjects];
        
        _btnAddPng.hidden = NO;
        _btnAddPng.frame = CGRectMake(10, 20, 60, 60);
        _bUpdatePhotos = NO;
        
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
        
        CSButton *btnImage = [CSButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = imageView.frame;
        btnImage.backgroundColor = [UIColor clearColor];
        [_viewBody addSubview:btnImage];
        
        __weak __typeof(self) weakSelf = self;
        
        btnImage.actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            NSUInteger nIndex = [strongSelf->_imgViewArray indexOfObject:imageView];
            [strongSelf onClickImageViewByIndex:nIndex];
        };
        
        [_viewBody addSubview:imageView];
        [_viewBody addSubview:btnImage];
        [_viewBody bringSubviewToFront:imageView];
        [_viewBody bringSubviewToFront:btnImage];
        
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
    
    _btnAddPng.hidden = ([_imgUrlArray count] >= MAX_PUBLISH_PNG_COUNT);
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
        
        if (strongThis != nil) {
            if (isOK) {
                if (doneImageID != nil &&
                    [doneImageID isEqualToString:@""] == NO) {
                    [strongThis generateImageViewByUrls:[NSMutableArray arrayWithObject:doneImageID]];
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

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSMutableArray *arrImages = [[NSMutableArray alloc]init];
    
    for (ALAsset *asset in assets) {
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        if (image != nil) {
            [arrImages addObject:image];
        }
    }
    
    if([arrImages count] > 0)
    {
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
    else
    {
        [JDStatusBarNotification showWithStatus:@"图片格式错误" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
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
