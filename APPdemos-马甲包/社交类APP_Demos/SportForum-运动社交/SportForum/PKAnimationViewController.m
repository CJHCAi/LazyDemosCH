//
//  PKAnimationViewController.m
//  SportForum
//
//  Created by liyuan on 7/14/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "PKAnimationViewController.h"
#import "UIImageView+WebCache.h"
#import "ZipArchive.h"
#import "MyDownLoadTask.h"

@interface PKAnimationViewController ()

@end

@implementation PKAnimationViewController
{
    UIView *_viewBackground;
    UIImageView *_imgViewUser;
    UIImageView *_imgViewPKUser;
    UIImageView *_myAnimatedView;
    UIImageView *_pkResultView;
    UIImageView *_pkLoseView;
    UIImageView *_pkWinView;
    UILabel *_lbTitle;
    UILabel *_lbWinerNick;
    UILabel *_lbLoseNick;
    UILabel *_lbWinerScore;
    UILabel *_lbLoseScore;
    NSTimer *_myAnimatedTimer;
    NSTimer *m_timerReward;
    NSString *_strScreenImgPath;
    //CSButton *_btnQuit;
    
    int _nNextImage;
    NSMutableArray *_arrAnimationImgs;
    
    NSString *_strEffectUrl;
    MyDownLoadTask *_myDownLoadTask;
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
    UserInfo * userInfo = [[ApplicationContext sharedInstance] accountInfo];

    _lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.frame), 20)];
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.textColor = [UIColor blackColor];
    _lbTitle.font = [UIFont boldSystemFontOfSize:16];
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.text = [NSString stringWithFormat:@"我 PK %@", _senderInfo.nikename];
    _lbTitle.alpha = 0;
    //[self.view addSubview:_lbTitle];
    
    _viewBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _viewBackground.backgroundColor = [UIColor colorWithRed:31.0 / 255.0 green:64.0 / 255.0 blue:141.0 / 255.0 alpha:1.0];
    _viewBackground.alpha = 0;
    [self.view addSubview:_viewBackground];
    
    _imgViewUser = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.frame), 93, 93)];
    _imgViewUser.layer.cornerRadius = 10.0;
    _imgViewUser.layer.masksToBounds = YES;
    [self.view addSubview:_imgViewUser];
    
    _imgViewPKUser = [[UIImageView alloc]initWithFrame:CGRectMake(197, CGRectGetHeight(self.view.frame), 93, 93)];
    _imgViewPKUser.layer.cornerRadius = 10.0;
    _imgViewPKUser.layer.masksToBounds = YES;
    [self.view addSubview:_imgViewPKUser];
    
    _pkLoseView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 93, 93)];
    [_pkLoseView setImage:[UIImage imageNamed:@"glass-broken"]];
    _pkLoseView.layer.cornerRadius = 10.0;
    _pkLoseView.layer.masksToBounds = YES;
    _pkLoseView.hidden = YES;
    
    _myAnimatedView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 134, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame) / 2 - 134, 268, 268)];
    [self.view addSubview:_myAnimatedView];
    
    UIImage *imagePk = [UIImage imageNamedWithWebP:@"PK-result-bg"];
    
    if ([CommonFunction ConvertStringToSexType:userInfo.sex_type] == e_sex_male && [_senderInfo.sex_type isEqualToString:sex_male]) {
        imagePk = [UIImage imageNamedWithWebP:@"PK-result-bg-4"];
    }
    else if([CommonFunction ConvertStringToSexType:userInfo.sex_type] == e_sex_female && [_senderInfo.sex_type isEqualToString:sex_female])
    {
        imagePk = [UIImage imageNamedWithWebP:@"PK-result-bg"];
    }
    else if([CommonFunction ConvertStringToSexType:userInfo.sex_type] == e_sex_male && [_senderInfo.sex_type isEqualToString:sex_female])
    {
        imagePk = (userInfo.proper_info.rankscore > _senderInfo.proper_info.rankscore ? [UIImage imageNamedWithWebP:@"PK-result-bg-3"] : [UIImage imageNamedWithWebP:@"PK-result-bg-2"]);
    }
    else if([CommonFunction ConvertStringToSexType:userInfo.sex_type] == e_sex_female && [_senderInfo.sex_type isEqualToString:sex_male])
    {
        imagePk = (userInfo.proper_info.rankscore > _senderInfo.proper_info.rankscore ? [UIImage imageNamedWithWebP:@"PK-result-bg-2"] : [UIImage imageNamedWithWebP:@"PK-result-bg-3"]);
    }
    
    _pkResultView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 142, 40, 284, 279)];
    [_pkResultView setImage:imagePk];
    _pkResultView.alpha = 0;
    [self.view addSubview:_pkResultView];
    
    _pkWinView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 33, CGRectGetHeight(self.view.frame) - 130, 66, 41)];
    [_pkWinView setImage:[UIImage imageNamedWithWebP:@"PK-win"]];
    _pkWinView.alpha = 0;
    [self.view addSubview:_pkWinView];
    
    _lbWinerNick = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.frame) - 105, 93, 20)];
    _lbWinerNick.backgroundColor = [UIColor clearColor];
    _lbWinerNick.textColor = [UIColor blackColor];
    _lbWinerNick.textAlignment = NSTextAlignmentCenter;
    _lbWinerNick.font = [UIFont boldSystemFontOfSize:14];
    _lbWinerNick.alpha = 0;
    [self.view addSubview:_lbWinerNick];
    
    _lbLoseNick = [[UILabel alloc]initWithFrame:CGRectMake(200, CGRectGetHeight(self.view.frame) - 105, 93, 20)];
    _lbLoseNick.backgroundColor = [UIColor clearColor];
    _lbLoseNick.textColor = [UIColor blackColor];
    _lbLoseNick.textAlignment = NSTextAlignmentCenter;
    _lbLoseNick.font = [UIFont boldSystemFontOfSize:14];
    _lbLoseNick.alpha = 0;
    [self.view addSubview:_lbLoseNick];
    
    _lbWinerScore = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_lbWinerNick.frame) + 10, 98, 20)];
    _lbWinerScore.backgroundColor = [UIColor clearColor];
    _lbWinerScore.textColor = [UIColor blackColor];
    _lbWinerScore.textAlignment = NSTextAlignmentCenter;
    _lbWinerScore.font = [UIFont boldSystemFontOfSize:14];
    _lbWinerScore.alpha = 0;
    _lbWinerScore.text = [NSString stringWithFormat:@"总分：%ld", userInfo.proper_info.rankscore];
    [self.view addSubview:_lbWinerScore];
    
    _lbLoseScore = [[UILabel alloc]initWithFrame:CGRectMake(195, CGRectGetMaxY(_lbLoseNick.frame) + 10, 98, 20)];
    _lbLoseScore.backgroundColor = [UIColor clearColor];
    _lbLoseScore.textColor = [UIColor blackColor];
    _lbLoseScore.textAlignment = NSTextAlignmentCenter;
    _lbLoseScore.font = [UIFont boldSystemFontOfSize:14];
    _lbLoseScore.alpha = 0;
    _lbLoseScore.text = [NSString stringWithFormat:@"总分：%ld", _senderInfo.proper_info.rankscore];
    [self.view addSubview:_lbLoseScore];
    
    [_imgViewUser sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
                    placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    [_imgViewPKUser sd_setImageWithURL:[NSURL URLWithString:_senderInfo.profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _lbWinerNick.text = userInfo.nikename;
    _lbLoseNick.text = _senderInfo.nikename;
    
    if (userInfo.proper_info.rankscore > _senderInfo.proper_info.rankscore) {
        [_pkWinView setImage:[UIImage imageNamedWithWebP:@"PK-win"]];
        [_imgViewPKUser addSubview:_pkLoseView];
        [_imgViewPKUser bringSubviewToFront:_pkLoseView];
    }
    else
    {
        [_pkWinView setImage:[UIImage imageNamedWithWebP:@"PK-lose"]];
        [_imgViewUser addSubview:_pkLoseView];
        [_imgViewUser bringSubviewToFront:_pkLoseView];
    }
    
    /*_btnQuit = [CSButton buttonWithType:UIButtonTypeCustom];
    [_btnQuit setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
    [_btnQuit setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
    _btnQuit.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 50, 10, 40, 40);
    _btnQuit.hidden = YES;
    [self.view addSubview:_btnQuit];
    
    __weak __typeof(self) weakSelf = self;
    
    _btnQuit.actionBlock = ^()
    {
        __typeof(self) strongSelf = weakSelf;
        
        [strongSelf dismissView];
    };*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _arrAnimationImgs = [[NSMutableArray alloc]init];
    
    _strEffectUrl = [[ApplicationContext sharedInstance]pkEffectUrlString];
    
    if (_strEffectUrl.length > 0) {
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filePath = [path stringByAppendingPathComponent:@"animation"];
        
        NSArray *files = [fileManager subpathsAtPath:filePath];
        
        if (files != nil && files.count > 0) {
            for (NSInteger i = 0; i < files.count; i++) {
                NSString *imgPath = [NSString stringWithFormat:@"%@/%ld.webp", filePath, i + 1];
                UIImage *image = [UIImage imageNamedWithWebPPath:imgPath];
                
                if (image != nil) {
                    [_arrAnimationImgs addObject:image];
                }
            }
        }
        else
        {
            for(NSInteger i = 0; i < 17; i++)
            {
                UIImage *image = [UIImage imageNamedWithWebP:[NSString stringWithFormat:@"PK-ball-%ld", i + 1]];
                [_arrAnimationImgs addObject:image];
            }
        }
    }
    else
    {
        for(NSInteger i = 0; i < 17; i++)
        {
            UIImage *image = [UIImage imageNamedWithWebP:[NSString stringWithFormat:@"PK-ball-%ld", i + 1]];
            [_arrAnimationImgs addObject:image];
        }
    }
    
    [self viewDidLoadGui];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startAnimation) userInfo:nil repeats:NO];
}

-(void)loadServerAnimation
{
    if (_strEffectUrl.length > 0) {
        _myDownLoadTask = [[MyDownLoadTask alloc]initWithUrl:_strEffectUrl DownloadProcess:^void(CGFloat progress)
                           {
                               NSLog(@"Download Process is %.2f!", progress);
                           } CompleteProcess:^void(BOOL isCompleted, NSString* strByteTotal, NSString *error, NSData *responseData)
                           {
                               if (isCompleted) {
                                   NSLog(@"Download Successfully, totalByte is %@!", strByteTotal);
                                   
                                   NSError *error = nil;
                                   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                                   NSString *path = [paths objectAtIndex:0];
                                   NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
                                   
                                   [responseData writeToFile:zipPath options:0 error:&error];
                                   
                                   if(!error)
                                   {
                                       ZipArchive *za = [[ZipArchive alloc] init];
                                       if ([za UnzipOpenFile: zipPath]) {
                                           BOOL ret = [za UnzipFileTo: path overWrite: YES];
                                           if (NO == ret){} [za UnzipCloseFile];
                                           
                                           NSArray *list=[_strEffectUrl componentsSeparatedByString:@"/"];
                                           NSString *strFileName = [list.lastObject componentsSeparatedByString:@"."].firstObject;
                                           NSString *fileDest = [path stringByAppendingPathComponent:strFileName];
                                           NSString *filePath= [path stringByAppendingPathComponent:@"animation"];
                                           NSFileManager *fileManager = [NSFileManager defaultManager];
                                           
                                           if ([fileManager fileExistsAtPath:filePath])
                                           {
                                               [fileManager removeItemAtPath:filePath error:nil];
                                           }
                                           
                                           [fileManager moveItemAtPath:fileDest toPath:filePath error:&error];
                                       }
                                   }
                                   else
                                   {
                                       NSLog(@"Error saving file %@",error);
                                   }
                               }
                               else
                               {
                                   NSLog(@"Download Error, error desc is %@!", error);
                               }
                           }];
        
        [_myDownLoadTask start];
    }
    
    /*
     dispatch_queue_t queue = dispatch_get_global_queue(
     DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     dispatch_async(queue, ^{
     NSURL *url = [NSURL URLWithString:strUrl];
     NSError *error = nil;
     NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
     
     if(!error)
     {
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
     NSString *path = [paths objectAtIndex:0];
     NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
     
     [data writeToFile:zipPath options:0 error:&error];
     
     if(!error)
     {
     ZipArchive *za = [[ZipArchive alloc] init];
     if ([za UnzipOpenFile: zipPath]) {
     BOOL ret = [za UnzipFileTo: path overWrite: YES];
     if (NO == ret){} [za UnzipCloseFile];
     
     NSArray *list=[strUrl componentsSeparatedByString:@"/"];
     NSString *strFileName = [list.lastObject componentsSeparatedByString:@"."].firstObject;
     NSString *fileDest = [path stringByAppendingPathComponent:strFileName];
     NSString *filePath= [path stringByAppendingPathComponent:@"animation"];
     NSFileManager *fileManager = [NSFileManager defaultManager];
     
     if ([fileManager fileExistsAtPath:filePath])
     {
     [fileManager removeItemAtPath:filePath error:nil];
     }
     
     [fileManager moveItemAtPath:fileDest toPath:filePath error:&error];
     }
     }
     else
     {
     NSLog(@"Error saving file %@",error);
     }
     }
     else
     {
     NSLog(@"Error downloading zip file: %@", error);
     }
     });*/
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [super viewWillDisappear:animated];
    [_myDownLoadTask stop];
}

-(void)startAnimation
{
    [UIView animateWithDuration:1.0 animations:^{
        _viewBackground.alpha = 1.0f;
    }];
    
    [self moveImagePath:_imgViewUser];
    [self moveImagePath:_imgViewPKUser];
    
    /*[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startChangePngAnimated) userInfo:nil repeats:NO];
     [NSTimer scheduledTimerWithTimeInterval:4.25 target:self selector:@selector(stopChangeAnimated) userInfo:nil repeats:NO];
     [NSTimer scheduledTimerWithTimeInterval:4.75 target:self selector:@selector(showPKResult) userInfo:nil repeats:NO];*/
    
    [NSTimer scheduledTimerWithTimeInterval:4.5 target:self selector:@selector(startChangePngAnimated) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:7.25 target:self selector:@selector(stopChangeAnimated) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:7.75 target:self selector:@selector(showPKResult) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:10.75 target:self selector:@selector(dismissView) userInfo:nil repeats:NO];
}

- (UIImage*) renderScrollViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size,NO,0.0f);
    {
        [self.view.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, CGRectGetHeight(rect), image.size.width * 2, image.size.height * 2 - CGRectGetHeight(rect)));
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

-(void)startChangePngAnimated
{
    _imgViewUser.alpha = 0.f;
    _imgViewPKUser.alpha = 0.f;
    _nNextImage = 0;
    _myAnimatedView.hidden = NO;
    _myAnimatedView.image = _arrAnimationImgs[_nNextImage++];
    
    [[CommonUtility sharedInstance]playAudioFromName:@"pking.wav"];
    _myAnimatedTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setNextImage) userInfo:nil repeats:YES];
}

-(void)stopChangeAnimated
{
    _imgViewUser.alpha = 1.f;
    _imgViewPKUser.alpha = 1.f;
    
    CGRect frame = _imgViewUser.frame;
    frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(self.view.frame) / 2 - frame.size.height / 2);
    _imgViewUser.frame = frame;
    
    frame = _imgViewPKUser.frame;
    frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(self.view.frame) / 2 - frame.size.height / 2);
    _imgViewPKUser.frame = frame;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = _imgViewUser.frame;
        frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(self.view.frame) - 206);
        _imgViewUser.frame = frame;
        
        frame = _imgViewPKUser.frame;
        frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(self.view.frame) - 206);
        _imgViewPKUser.frame = frame;
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        _viewBackground.alpha = 0.f;
        _myAnimatedView.hidden = YES;
        [_myAnimatedTimer invalidate];
        _myAnimatedTimer = nil;
        
        _pkLoseView.hidden = NO;
        
        CGRect frame = _imgViewUser.frame;
        frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(self.view.frame) - 206);
        _imgViewUser.frame = frame;
        
        frame = _imgViewPKUser.frame;
        frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(self.view.frame) - 206);
        _imgViewPKUser.frame = frame;
    }];
    
    [self loadServerAnimation];
}

-(void)showPKResult
{
    [UIView animateWithDuration:0.25 animations:^{
        _pkResultView.alpha = 1.0;
        _pkWinView.alpha = 1.0;
        _lbWinerNick.alpha = 1.0;
        _lbLoseNick.alpha = 1.0;
        _lbWinerScore.alpha = 1.0;
        _lbLoseScore.alpha = 1.0;
        _lbTitle.alpha = 1.0;
        //_btnQuit.hidden = NO;
    }];
}

-(void)dismissView
{
    UIImage *imgRender = [self renderScrollViewToImage];
    
    [[SportForumAPI sharedInstance] imageUploadByUIImage:imgRender Width:0 Height:0 IsCompress:NO                                                       UploadProgressBlock:nil FinishedBlock:^(int errorCode, NSString *imageID, NSString *imageURL) {
        
        if (_pkCompletedBlock != nil) {
            _pkCompletedBlock(imageURL);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)setNextImage
{
    if (_nNextImage == _arrAnimationImgs.count) {
        _nNextImage = 0;
    }
    
    _myAnimatedView.image = _arrAnimationImgs[_nNextImage++];
}

- (void)moveImagePath:(UIView *)view
{
    CGRect frame = view.frame;
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame) / 2);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame) / 2);
    
    if(frame.origin.x < CGRectGetWidth(self.view.frame) / 2)
    {
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(self.view.frame) / 2 + frame.size.width/2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame) / 2);
    }
    else
    {
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(self.view.frame) / 2 - frame.size.width/2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame) / 2);
    }
    
    for (int nIndex = 0; nIndex < 12; nIndex++) {
        if(frame.origin.x < CGRectGetWidth(self.view.frame) / 2)
        {
            CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(self.view.frame) / 2 - frame.size.width/2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame) / 2);
            CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(self.view.frame) / 2 + frame.size.width/2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame) / 2);
        }
        else
        {
            CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(self.view.frame) / 2 + frame.size.width/2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame) / 2);
            CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(self.view.frame) / 2 - frame.size.width/2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame) / 2);
        }
    }
    
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame) / 2);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, CGRectGetHeight(self.view.frame) - 160);
    
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = 5.0f;
    shakeAnimation.removedOnCompletion = NO;
    shakeAnimation.fillMode = kCAFillModeForwards;
    
    [shakeAnimation setCalculationMode:kCAAnimationLinear];
    [shakeAnimation setKeyTimes:[NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.1],
                                 [NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.25],
                                 [NSNumber numberWithFloat:0.275], [NSNumber numberWithFloat:0.3],
                                 [NSNumber numberWithFloat:0.325], [NSNumber numberWithFloat:0.35],
                                 [NSNumber numberWithFloat:0.375], [NSNumber numberWithFloat:0.4],
                                 [NSNumber numberWithFloat:0.425], [NSNumber numberWithFloat:0.45],
                                 [NSNumber numberWithFloat:0.475], [NSNumber numberWithFloat:0.5],
                                 [NSNumber numberWithFloat:0.525], [NSNumber numberWithFloat:0.55],
                                 [NSNumber numberWithFloat:0.575], [NSNumber numberWithFloat:0.6],
                                 [NSNumber numberWithFloat:0.625], [NSNumber numberWithFloat:0.65],
                                 [NSNumber numberWithFloat:0.675], [NSNumber numberWithFloat:0.7],
                                 [NSNumber numberWithFloat:0.725], [NSNumber numberWithFloat:0.75],
                                 [NSNumber numberWithFloat:0.775],[NSNumber numberWithFloat:0.8],
                                 [NSNumber numberWithFloat:0.825], [NSNumber numberWithFloat:0.85],
                                 [NSNumber numberWithFloat:0.9], [NSNumber numberWithFloat:1.0], nil]];
    
    [view.layer addAnimation:shakeAnimation forKey:nil];
    CFRelease(shakePath);
    
    frame = view.frame;
    frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(self.view.frame) - 206);
    view.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"PKAnimationViewController dealloc called!");
}

@end
