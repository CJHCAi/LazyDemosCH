//
//  ArticlePublicViewController.m
//  SportForum
//
//  Created by liyuan on 14-9-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "ArticlePublicViewController.h"
#import "UIViewController+SportFormu.h"
#import "ImageEditViewController.h"
#import "CustomMenuViewController.h"
#import "UIImageView+WebCache.h"
#import "GCPlaceholderTextView.h"
#import "ZYQAssetPickerController.h"
#import "AlertManager.h"
#import "MWPhotoBrowser.h"
#import "IQKeyboardManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VideoPreViewController.h"
#import "QiniuSDK.h"
#import "SDProgressView.h"
#import "RegexKitLite.h"

#define PUBLISH_IMAGE_ADD_BTN_TAG 200
#define PUBLISH_VIEW_CHOOSE_TAG 201
#define MAX_PUBLISH_PNG_COUNT 6

@interface ArticlePublicViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate, MWPhotoBrowserDelegate, VideoPreViewDelegate>

@end

@implementation ArticlePublicViewController
{
    UIView *_viewBody;
    GCPlaceholderTextView *_tvLiterator;
    
    ImageEditViewController* _imageEditViewController;
    CustomMenuViewController* _customMenuViewController;
    
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _imgViewArray;
    NSMutableArray * _imgBtnArray;
    NSMutableArray * _imgBackFrameArray;
    NSMutableArray *_photos;
    
    NSString *_strVideoPath;
    BOOL _bOnlyVideos;
    BOOL _bUpdatePhotos;
    id m_processWindow;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoadGui
{
    [self generateCommonViewInParent:self.view Title:_strTitle.length > 0 ? _strTitle : @"发表博文" IsNeedBackBtn:YES];
    
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
    
    _tvLiterator = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(_viewBody.frame) - 10, 140)];
    _tvLiterator.backgroundColor = [UIColor clearColor];
    _tvLiterator.font = [UIFont systemFontOfSize: 12.0];
    _tvLiterator.textAlignment = NSTextAlignmentLeft; //水平左对齐
    [_viewBody addSubview:_tvLiterator];
    
    if(_taskInfo != nil)
    {
        _tvLiterator.placeholder = @"请发表你最近的运动心得，分享给大家，一起交流提高运动水平，需要15个字以上，并附上至少一张图或一段视频。\n请注意，如果随便输入无意义的文字和图，视频来完成任务，系统核查到后会进行封号操作！";
    }
    else
    {
        _tvLiterator.placeholder = @"亲, 写点什么吧...\n请注意，为了避免给他人造成信息噪音，请不要发布广告和灌水贴！";
    }
    
    CSButton *btnAddPng = [CSButton buttonWithType:UIButtonTypeCustom];
    btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(_tvLiterator.frame) + 10, 60, 60);
    [btnAddPng setImage:[UIImage imageNamed:@"add-images"] forState:UIControlStateNormal];
    btnAddPng.tag = PUBLISH_IMAGE_ADD_BTN_TAG;
    [_viewBody addSubview:btnAddPng];
    
    __weak __typeof(self) weakSelf = self;
    
    btnAddPng.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [[IQKeyboardManager sharedManager]resignFirstResponder];
        [strongSelf showPicSelect];
    };
    
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UIImageView *imgViewFinish = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [imgViewFinish setImage:[UIImage imageNamed:@"nav-finish-btn"]];
    [self.view addSubview:imgViewFinish];
    
    CSButton *btnFinish = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFinish.frame = CGRectMake(CGRectGetMinX(imgViewFinish.frame) - 5, CGRectGetMinY(imgViewFinish.frame) - 5, 45, 45);
    btnFinish.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnFinish];
    [self.view bringSubviewToFront:btnFinish];
    
    btnFinish.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (userInfo != nil) {
            if (userInfo.ban_time > 0) {
                [JDStatusBarNotification showWithStatus:@"用户已被禁言，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                return;
            }
            else if(userInfo.ban_time < 0)
            {
                [JDStatusBarNotification showWithStatus:@"用户已进入黑名单，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                return;
            }
        }
        
        [strongSelf publishSportLog];
    };
    
    _bOnlyVideos = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _imgUrlArray = [[NSMutableArray alloc]init];
    _imgViewArray = [[NSMutableArray alloc]init];
    _imgBtnArray = [[NSMutableArray alloc]init];
    _imgBackFrameArray = [[NSMutableArray alloc]init];
    _photos = [[NSMutableArray alloc]init];
    
    _bUpdatePhotos = NO;
    
    [self viewDidLoadGui];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshImageViews];
    [MobClick beginLogPageView:@"发表文章 - ArticlePublicViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"发表文章 - ArticlePublicViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hidenCommonProgress];
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发表文章 - ArticlePublicViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"ArticlePublicViewController dealloc called!");
}

-(void)showCommonProgress{
    m_processWindow = [AlertManager showCommonProgress];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
}

-(void)showFailAnimationWhenExecuteTask
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_ANIMATION_STATE object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TaskFail", @"AnimationState", nil]];
}

-(void)showSuccessAnimationWhenExecuteTask
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_ANIMATION_STATE object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TaskSuccess", @"AnimationState", nil]];
}

-(void)handlePublichArticle:(NSArray*) articleSegments
{
    if (articleSegments.count == 0) {
        return;
    }
    
    NSMutableArray *arrAtList = [[NSMutableArray alloc]init];
    //NSArray *matchArray = [_tvLiterator.text componentsMatchedByRegex:@"(?<=@)[^\\s]+\\s?"];
    NSArray *matchArray = [_tvLiterator.text componentsMatchedByRegex:@"((?<=@)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)_]+))|(?<=@)([\u4e00-\u9fa5]+)"];
    
    for (NSString *str in matchArray) {
        NSString *trimmedString = [str stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([arrAtList indexOfObject:trimmedString] == NSNotFound) {
            [arrAtList addObject:trimmedString];
        }
    }

    [self showCommonProgress];
    
    [[SportForumAPI sharedInstance]articleNewByParArticleId:_articleParent
                                             ArticleSegment:articleSegments
                                                 ArticleTag:[NSArray arrayWithObject:[CommonFunction ConvertArticleTagTypeToString:e_article_log]] Type:@"" AtNameList:arrAtList
                                              FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect) {
                                                  if (errorCode == RSA_ERROR_NONE) {
                                                      UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                                                      
                                                      [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                       {
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", @(YES), @"UpdateArticle",nil]];
                                                       }];
                                                      
                                                      if (_taskInfo != nil) {
                                                          if (_tvLiterator.text.length > 15 && _imgUrlArray.count > 0) {
                                                              SportRecordInfo* sportRecordInfo =[[SportRecordInfo alloc]init];
                                                              sportRecordInfo.type = @"post";
                                                              
                                                              [[SportForumAPI sharedInstance]recordNewByRecordItem:sportRecordInfo RecordId:_taskInfo.task_id Public:YES FinishedBlock:^(int errorCode, NSString* strDescErr, NSString* strRecordId, ExpEffect* expEffect) {
                                                                  [self hidenCommonProgress];
                                                                  
                                                                  if (errorCode == 0) {
                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
                                                                      [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showSuccessAnimationWhenExecuteTask) userInfo:nil repeats:NO];
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }
                                                                  else
                                                                  {
                                                                      [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                                  }
                                                              }];
                                                          }
                                                          else
                                                          {
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                              [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showFailAnimationWhenExecuteTask) userInfo:nil repeats:NO];
                                                          }
                                                      }
                                                      else
                                                      {
                                                          if ([_strTitle isEqualToString:@"评论"]) {
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_ARTICLE_AFTER_EVENT object:nil];
                                                          }
                                                          
                                                          [self hidenCommonProgress];
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }
                                                  } else {
                                                      [self hidenCommonProgress];
                                                      [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                  }
                                              }];
}

-(void)publishSportLog
{
    if (_taskInfo != nil) {
        if (_tvLiterator.text.length < 15 || _imgUrlArray.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showFailAnimationWhenExecuteTask) userInfo:nil repeats:NO];
            return;
        }
    }
    
    NSMutableArray* articleSegments = [[NSMutableArray alloc]init];
    
    if (_tvLiterator.text.length > 0) {
        ArticleSegmentObject* segobj = [ArticleSegmentObject new];
        segobj.seg_type = @"TEXT";
        segobj.seg_content = _tvLiterator.text;
        [articleSegments addObject:segobj];
    }
    else
    {
        [JDStatusBarNotification showWithStatus:@"文章内容不能为空" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }

    if (_bOnlyVideos) {
        [[SportForumAPI sharedInstance]fileUptoken:^(int errorCode, NSString* strToken){
            if (strToken.length > 0) {
                __block UIView* viewScreen = [[UIView alloc]init];
                viewScreen.frame = [UIScreen mainScreen].bounds;
                viewScreen.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
                [self.view addSubview:viewScreen];
                [self.view bringSubviewToFront:viewScreen];
                
                SDLoopProgressView *loop = [SDLoopProgressView progressView];
                loop.frame = CGRectMake(([UIScreen screenWidth] - 100) / 2, CGRectGetHeight(_viewBody.frame) / 2 - 50, 100, 100);
                loop.backgroundColor = [UIColor clearColor];
                [viewScreen addSubview:loop];
                
                UILabel *lbVideo = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(loop.frame) + 30, [UIScreen screenWidth], 30)];
                lbVideo.backgroundColor = [UIColor clearColor];
                lbVideo.textColor = [UIColor whiteColor];
                lbVideo.font = [UIFont boldSystemFontOfSize:14];
                lbVideo.textAlignment = NSTextAlignmentCenter;
                lbVideo.text = @"正在上传视频...";
                [viewScreen addSubview:lbVideo];
                
                __weak __typeof(self) weakSelf = self;
                
                QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler: ^(NSString *key, float percent) {
                    NSLog(@"progress %f", percent);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        loop.progress = percent;
                    });
                    
                } params:nil checkCrc:NO cancellationSignal: ^BOOL () {
                    return NO;
                }];

                QNUploadManager *upManager = [[QNUploadManager alloc] init];
                NSData *data = [NSData dataWithContentsOfFile:_strVideoPath];
                [upManager putData:data key:nil token:strToken
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                              NSLog(@"%@", info);
                              NSLog(@"%@", resp);
                              
                              __typeof(self) strongSelf = weakSelf;
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  loop.progress = 1.0;
                                  [viewScreen removeFromSuperview];
                                  viewScreen = nil;
                                  
                                  if (info.statusCode == 200) {
                                      ArticleSegmentObject* segobj = [ArticleSegmentObject new];
                                      segobj.seg_type = @"VIDEO";
                                      segobj.seg_content = [NSString stringWithFormat:@"%@###http://7xjasg.com1.z0.glb.clouddn.com/%@", strongSelf->_imgUrlArray.firstObject, [resp objectForKey:@"key"]];
                                      [articleSegments addObject:segobj];
                                      
                                      [strongSelf handlePublichArticle:articleSegments];
                                  }
                                  else
                                  {
                                      [JDStatusBarNotification showWithStatus:@"视频上传失败，请重试！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                                  }
                              });
                              
                          } option:opt];
            }
            else
            {
                [JDStatusBarNotification showWithStatus:@"获取上传Token失败，请重试！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            }
        }];
        
    }
    else
    {
        for (NSString *strUrl in _imgUrlArray) {
            ArticleSegmentObject* segobj = [ArticleSegmentObject new];
            segobj.seg_type = @"IMAGE";
            segobj.seg_content = strUrl;
            [articleSegments addObject:segobj];
        }
        
        [self handlePublichArticle:articleSegments];
    }
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
    
    if ([_imgUrlArray count] == 0)
    {
        [_customMenuViewController addButtonFromBackTitle:@"微视频" Hightlight:NO ActionBlock:^(id sender) {
            [thisPointer actionTakePhoto:sender IsVideo:YES];
        }];
    }
    
    [_customMenuViewController addButtonFromBackTitle:@"立即拍照" Hightlight:YES ActionBlock:^(id sender) {
        [thisPointer actionTakePhoto:sender IsVideo:NO];
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


- (void)videoPreDelete:(VideoPreViewController *)videoPreViewController
{
    [[SportForumAPI sharedInstance]fileDeleteByIds:_imgUrlArray FinishedBlock:^(int errorCode){
        if (errorCode == 0) {
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
            
            CSButton *btnAddPng = (CSButton*)[_viewBody viewWithTag:PUBLISH_IMAGE_ADD_BTN_TAG];
            btnAddPng.hidden = NO;
            btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(_tvLiterator.frame) + 10, 60, 60);
        }
    }];
}

-(void)onClickPreViewVideo
{
    VideoPreViewController *videoPreViewController = [[VideoPreViewController alloc] init];
    videoPreViewController.delegate = self;
    videoPreViewController.strVideoPath = _strVideoPath;
    [self.navigationController pushViewController:videoPreViewController animated:YES];
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

        CSButton *btnAddPng = (CSButton*)[_viewBody viewWithTag:PUBLISH_IMAGE_ADD_BTN_TAG];
        UIView *viewChoose = [_viewBody viewWithTag:PUBLISH_VIEW_CHOOSE_TAG];
        btnAddPng.hidden = NO;
        btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(_tvLiterator.frame) + 10, 60, 60);
        viewChoose.frame = CGRectMake(0, CGRectGetMaxY(btnAddPng.frame) + 10, CGRectGetWidth(_viewBody.frame), 40);
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
    CSButton *btnAddPng = (CSButton*)[_viewBody viewWithTag:PUBLISH_IMAGE_ADD_BTN_TAG];
    UIView *viewChoose = [_viewBody viewWithTag:PUBLISH_VIEW_CHOOSE_TAG];
    
    if ([_imgViewArray count] == 0) {
        rectEnd = btnAddPng.frame;
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
        [_viewBody addSubview:btnImage];
        
        if (_bOnlyVideos) {
            [btnImage setImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
        }
        
        __weak __typeof(self) weakSelf = self;
        
        btnImage.actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            
            if (strongSelf->_bOnlyVideos) {
                [strongSelf onClickPreViewVideo];
            }
            else
            {
                NSUInteger nIndex = [strongSelf->_imgViewArray indexOfObject:imageView];
                [strongSelf onClickImageViewByIndex:nIndex];
            }
        };
        
        [_viewBody addSubview:imageView];
        [_viewBody addSubview:btnImage];
        //[_viewBody addSubview:backframe];
        [_viewBody bringSubviewToFront:imageView];
        [_viewBody bringSubviewToFront:btnImage];
        
        //[_imgBackFrameArray addObject:backframe];
        [_imgBtnArray addObject:btnImage];
        [_imgViewArray addObject:imageView];
        [_imgUrlArray addObject:arrayUrls[i]];
    }
    
    if (([_imgViewArray count] - 1) % 4 == 3) {
        btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(rectEnd) + 10, CGRectGetWidth(rectEnd), CGRectGetHeight(rectEnd));
    }
    else
    {
        btnAddPng.frame = CGRectMake(CGRectGetMaxX(rectEnd) + 17, CGRectGetMinY(rectEnd), CGRectGetWidth(rectEnd), CGRectGetHeight(rectEnd));
    }
    
    rectEnd = viewChoose.frame;
    rectEnd.origin = CGPointMake(0, CGRectGetMaxY(btnAddPng.frame) + 10);
    viewChoose.frame = rectEnd;
    
    btnAddPng.hidden = ([_imgUrlArray count] >= (_bOnlyVideos ? 1 : MAX_PUBLISH_PNG_COUNT));
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        _bOnlyVideos = NO;
        
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
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        // 判断获取类型：视频
        //获取视频文件的url
        _bOnlyVideos = YES;
        
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        _strVideoPath = [mediaURL path];
        //创建ALAssetsLibrary对象并将视频保存到媒体库
        // Assets Library 框架包是提供了在应用程序中操作图片和视频的相关功能。相当于一个桥梁，链接了应用程序和多媒体文件。
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        // 将视频保存到相册中
        __block id processWindow = [AlertManager showCommonProgress];
        
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL
                                          completionBlock:^(NSURL *assetURL,NSError *error) {
                                              if (!error) {
                                                  NSLog(@"captured video saved with no error.");
                                                  
                                                  NSMutableArray *arrImages = [[NSMutableArray alloc]init];
                                                  UIImage *image = [CommonUtility videoConverPhotoWithVideoPath:[mediaURL path]];
                                                  [arrImages addObject:image];

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
                                              }else{
                                                  [AlertManager dissmiss:processWindow];
                                                  NSLog(@"error occured while saving the video:%@", error);
                                              }
                                          }];
    }
}

// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
        
    }];
    return result;
}

// 检查摄像头是否支持录像
- (BOOL) doesCameraSupportShootingVideos{
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}

// 检查摄像头是否支持拍照
- (BOOL) doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 相册文件选取相关
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

// 是否可以在相册中选择视频
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

// 是否可以在相册中选择视频
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(IBAction)actionTakePhoto:(id)sender IsVideo:(BOOL)bIsVideo
{
    /*UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    [imagePicker setDelegate:self];*/
    
    
    // 判断有摄像头，并且支持拍照功能
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]){
        // 初始化图片选择控制器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];// 设置类型
        
        // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        NSString *requiredMediaType1 = ( NSString *)kUTTypeMovie;
        
        if (bIsVideo) {
            NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType1,nil];
            [controller setMediaTypes:arrMediaTypes];
            
            // 设置录制视频的质量
            [controller setVideoQuality:UIImagePickerControllerQualityType640x480];
            //设置最长摄像时间
            [controller setVideoMaximumDuration:10.f];
        }
        else
        {
            NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
            [controller setMediaTypes:arrMediaTypes];
        }
        
        [controller setAllowsEditing:YES];// 设置是否可以管理已经存在的图片或者视频
        [controller setDelegate:self];// 设置代理
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        NSLog(@"Camera is not available.");
    }
}

-(IBAction)actionSelectPhoto:(id)sender
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = MAX_PUBLISH_PNG_COUNT - [_imgViewArray count];
    picker.assetsFilter = [ALAssetsFilter allAssets];
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

@end
