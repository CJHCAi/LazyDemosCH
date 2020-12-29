//
//  CoachAuthDetailViewController.m
//  SportForum
//
//  Created by liyuan on 4/27/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "CoachAuthDetailViewController.h"
#import "UIViewController+SportFormu.h"
#import "ImageEditViewController.h"
#import "CustomMenuViewController.h"
#import "UIImageView+WebCache.h"
#import "ZYQAssetPickerController.h"
#import "AlertManager.h"
#import "MWPhotoBrowser.h"
#import "PrivateContentViewController.h"

#define MAX_PUBLISH_PNG_COUNT 2

@interface CoachAuthDetailViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate, MWPhotoBrowserDelegate, UIAlertViewDelegate>

@end

@implementation CoachAuthDetailViewController
{
    UIView *_viewBody;
    CSButton *_btnAddPng;
    CSButton *_btnDelete;
    UITextView * _tvContent;
    UILabel *_lbAuthState;
    UILabel *_lbAuthReason;
    
    ImageEditViewController* _imageEditViewController;
    CustomMenuViewController* _customMenuViewController;
    
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _imgViewArray;
    NSMutableArray * _imgBtnArray;
    NSMutableArray * _imgBackFrameArray;
    NSMutableArray *_photos;
    
    BOOL _bUpdatePhotos;
    
    NSString *_strLatestDes;
    NSMutableArray *_arrLatestImg;
    
    UIAlertView* _alertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imgUrlArray = [[NSMutableArray alloc]init];
    _imgViewArray = [[NSMutableArray alloc]init];
    _imgBtnArray = [[NSMutableArray alloc]init];
    _imgBackFrameArray = [[NSMutableArray alloc]init];
    _photos = [[NSMutableArray alloc]init];
    
    _bUpdatePhotos = NO;

    [self generateCommonViewInParent:self.view Title:_strTitle IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    _viewBody = viewBody;
    
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
        [strongSelf publishAuthInfo];
    };

    UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 290, 20)];
    lbTitle.font = [UIFont boldSystemFontOfSize:14.0];
    lbTitle.textAlignment = NSTextAlignmentLeft;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textColor = [UIColor darkGrayColor];
    [viewBody addSubview:lbTitle];
    
    if ([_strTitle isEqualToString:@"资格证书认证"]) {
        lbTitle.text = @"资格证书描述：";
    }
    else if ([_strTitle isEqualToString:@"运动成绩认证"]) {
        lbTitle.text = @"运动成绩描述：";
    }
    else if ([_strTitle isEqualToString:@"身份证认证"]) {
        lbTitle.text = @"个人简介：";
    }
    
    _tvContent = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lbTitle.frame) + 5, CGRectGetWidth(viewBody.frame) - 20, 200)];
    _tvContent.backgroundColor = [UIColor whiteColor];
    _tvContent.textColor = [UIColor darkGrayColor];
    _tvContent.font = [UIFont boldSystemFontOfSize:14];
    _tvContent.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tvContent.returnKeyType = UIReturnKeyDefault;
    _tvContent.multipleTouchEnabled = YES;
    _tvContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tvContent.layer.borderWidth = 1.0;
    _tvContent.layer.cornerRadius = 5.0;
    [viewBody addSubview:_tvContent];

    UILabel *lbPng = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_tvContent.frame) + 10, 290, 20)];
    lbPng.font = [UIFont boldSystemFontOfSize:14.0];
    lbPng.textAlignment = NSTextAlignmentLeft;
    lbPng.backgroundColor = [UIColor clearColor];
    lbPng.textColor = [UIColor darkGrayColor];
    lbPng.text = @"添加图片认证：";
    [viewBody addSubview:lbPng];
    
    _btnAddPng = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(lbPng.frame) + 10, 60, 60);
    [_btnAddPng setImage:[UIImage imageNamed:@"add-images"] forState:UIControlStateNormal];
    [viewBody addSubview:_btnAddPng];
    
    __weak __typeof(self) weakSelf = self;
    
    _btnAddPng.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_tvContent endEditing:YES];
        [strongSelf showPicSelect];
    };
    
    _btnDelete = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnDelete.backgroundColor = [UIColor clearColor];
    [_btnDelete setImage:[UIImage imageNamed:@"blog-delete"] forState:UIControlStateNormal];
    [viewBody addSubview:_btnDelete];
    _btnDelete.hidden = YES;
    _btnDelete.frame = CGRectMake(CGRectGetMaxX(_tvContent.frame) - 35, CGRectGetMaxY(_btnAddPng.frame) - 30, 40, 40);
    
    _btnDelete.actionBlock = ^(void)
    {
        __typeof(self) strongSelf = weakSelf;
        strongSelf->_alertView = [[UIAlertView alloc] initWithTitle:@"删除图片" message:@"要删除该图片吗？" delegate:strongSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        strongSelf->_alertView.tag = 10;
        [strongSelf->_alertView show];
    };

    UILabel *lbSep0 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnAddPng.frame) + 10, CGRectGetWidth(viewBody.frame), 1)];
    lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    [viewBody addSubview:lbSep0];
    
    UILabel *lbLink = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lbSep0.frame) + 15, CGRectGetWidth(viewBody.frame) - 50, 20)];
    lbLink.backgroundColor = [UIColor clearColor];
    lbLink.font = [UIFont boldSystemFontOfSize:14.0];
    lbLink.textAlignment = NSTextAlignmentLeft;
    lbLink.textColor = [UIColor darkGrayColor];
    lbLink.text = @"认证规范: 请严格按照此规范上传图片";
    [viewBody addSubview:lbLink];

    UIImageView *arrImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(viewBody.frame) - 18, CGRectGetMidY(lbLink.frame) - 8, 8, 16)];
    [arrImgView setImage:[UIImage imageNamed:@"arrow-1"]];
    [viewBody addSubview:arrImgView];
    
    CSButton *btnAction = [CSButton buttonWithType:UIButtonTypeCustom];
    btnAction.backgroundColor = [UIColor clearColor];
    btnAction.frame = CGRectMake(0, CGRectGetMaxY(lbSep0.frame), CGRectGetWidth(viewBody.frame), 50);
    [viewBody addSubview:btnAction];
    [viewBody bringSubviewToFront:btnAction];
    
    btnAction.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        PrivateContentViewController *privateContentViewController = [[PrivateContentViewController alloc]init];
        privateContentViewController.bAuthDetail = YES;
        [strongSelf.navigationController pushViewController:privateContentViewController animated:YES];
    };
    
    UILabel *lbSep1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbLink.frame) + 15, CGRectGetWidth(viewBody.frame), 1)];
    lbSep1.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    [viewBody addSubview:lbSep1];
    
    _lbAuthState = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lbSep1.frame) + 10, CGRectGetWidth(viewBody.frame) - 20, 20)];
    _lbAuthState.backgroundColor = [UIColor clearColor];
    _lbAuthState.font = [UIFont boldSystemFontOfSize:14.0];
    _lbAuthState.textAlignment = NSTextAlignmentLeft;
    _lbAuthState.textColor = [UIColor darkGrayColor];
    _lbAuthState.hidden = YES;
    [viewBody addSubview:_lbAuthState];
    
    _lbAuthReason = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_lbAuthState.frame), CGRectGetWidth(viewBody.frame) - 20, 45)];
    _lbAuthReason.backgroundColor = [UIColor clearColor];
    _lbAuthReason.font = [UIFont boldSystemFontOfSize:14.0];
    _lbAuthReason.textAlignment = NSTextAlignmentLeft;
    _lbAuthReason.backgroundColor = [UIColor clearColor];
    _lbAuthReason.textColor = [UIColor darkGrayColor];
    _lbAuthReason.hidden = YES;
    _lbAuthReason.numberOfLines = 0;
    [viewBody addSubview:_lbAuthReason];
    
    [self loadAuthInfo];
}

-(BOOL)isEqualToUrlArray
{
    BOOL bEqual = YES;
    
    if(_imgUrlArray.count != _arrLatestImg.count)
    {
        bEqual = NO;
    }
    else
    {
        for (NSString *strObject in _arrLatestImg) {
            if ([_imgUrlArray indexOfObject:strObject] == NSNotFound) {
                bEqual = NO;
                break;
            }
        }
    }
    
    return bEqual;
}

-(void)publishAuthInfo
{
    [_tvContent endEditing:YES];
    
    if (_imgUrlArray.count == 0) {
        [JDStatusBarNotification showWithStatus:@"必须添加图片，才能资格认证" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }
    
    if (_tvContent.text.length == 0) {
        [JDStatusBarNotification showWithStatus:@"必须添加文字描述，才能资格认证" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }
    
    if ([_strLatestDes isEqualToString:_tvContent.text] && [self isEqualToUrlArray]) {
        [JDStatusBarNotification showWithStatus:@"不能提交跟上次一样的认证信息，请更新认证资料" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }
    
    id processWin = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance]userAuthRequestByType:_eAuthType AuthImgs:_imgUrlArray AuthDesc:_tvContent.text FinishedBlock:^(int errorCode){
        [AlertManager dissmiss:processWin];
        
        if (errorCode == 0) {
            [JDStatusBarNotification showWithStatus:@"提交成功" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [JDStatusBarNotification showWithStatus:@"提交失败" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshImageViews];
    [MobClick beginLogPageView:@"CoachAuthDetailViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"CoachAuthDetailViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CoachAuthDetailViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"CoachAuthDetailViewController dealloc called!");
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
            _bUpdatePhotos = YES;
            [_photos removeAllObjects];
            [self refreshImageViews];
        }
    }
}

-(void)updateAuthInfoControls:(e_auth_status_type)eAuthStatus ReviewResult:(NSString*)strAuthReview
{
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"认证状态： " attributes:attribs];
    
    NSString *strStatus = @"未认证";
    
    switch (eAuthStatus) {
        case e_auth_unverified:
            strStatus = @"未认证";
            attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            break;
        case e_auth_verifying:
            strStatus = @"认证中";
            attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
            break;
        case e_auth_verified:
            strStatus = @"已认证";
            attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
            break;
        case e_auth_refused:
            strStatus = @"认证被拒";
            attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor redColor]};
            break;
        default:
            break;
    }

    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:strStatus attributes:attribs];

    NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strPer appendAttributedString:strPart2Value];
    _lbAuthState.attributedText = strPer;
    _lbAuthState.hidden = NO;
    
    if (eAuthStatus == e_auth_refused) {
        NSDictionary *attribsReview = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart1ValueReview = [[NSAttributedString alloc] initWithString:@"拒绝理由： " attributes:attribsReview];
        
        NSAttributedString * strPart2ValueReview = [[NSAttributedString alloc] initWithString:strAuthReview attributes:attribs];
        
        NSMutableAttributedString * strPerReview = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1ValueReview];
        [strPerReview appendAttributedString:strPart2ValueReview];
        _lbAuthReason.attributedText = strPerReview;
        _lbAuthReason.hidden = NO;
    }
}

-(void)loadAuthInfo
{
    id processWin = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance]userAuthInfoByType:_eAuthType FinishedBlock:^(int errorCode, NSString* strAuthDesc, NSString* strAuthReview, NSArray* arrAuthImgs, e_auth_status_type eAuthStatus)
     {
         [AlertManager dissmiss:processWin];
         
         if (errorCode == 0) {
             _strLatestDes = strAuthDesc;
             _tvContent.text = strAuthDesc;
             
             [self updateAuthInfoControls:eAuthStatus ReviewResult:strAuthReview];
             
             if ([arrAuthImgs isKindOfClass:[NSArray class]] && arrAuthImgs.count > 0) {
                 _arrLatestImg = [NSMutableArray arrayWithArray:arrAuthImgs];
                 [self generateImageViewByUrls:[NSMutableArray arrayWithArray:arrAuthImgs]];
             }
         }
     }];
}

#pragma mark - Png Choose Logic

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
            [[SportForumAPI sharedInstance]fileDeleteByIds:@[[mwPhoto.photoURL description]] FinishedBlock:^(int errorCode){
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
        
        _btnAddPng.hidden = NO;
        _btnDelete.hidden = YES;
        _bUpdatePhotos = NO;
        _btnAddPng.frame = CGRectMake(10, CGRectGetMinY(_btnAddPng.frame), 60, 60);
        
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
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIView * backframe = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame) - 1, CGRectGetMinY(imageView.frame) - 1, CGRectGetWidth(imageView.frame) + 2, CGRectGetHeight(imageView.frame) + 2)];
        backframe.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
        backframe.layer.borderWidth = 1.0;
        backframe.layer.borderColor = [[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor];
        
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

    _btnAddPng.frame = CGRectMake(CGRectGetMaxX(rectEnd) + 17, CGRectGetMinY(rectEnd), CGRectGetWidth(rectEnd), CGRectGetHeight(rectEnd));
    _btnAddPng.hidden = ([_imgUrlArray count] >= MAX_PUBLISH_PNG_COUNT);
    _btnDelete.hidden = !_btnAddPng.hidden;
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
