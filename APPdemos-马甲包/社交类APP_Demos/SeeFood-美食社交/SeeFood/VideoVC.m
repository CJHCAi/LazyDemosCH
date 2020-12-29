
//
//  VideoVC.m
//  SeeFood
//
//  Created by 纪洪波 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "VideoVC.h"
#import "VideoView.h"
#import "PrefixHeader.pch"
#import "AVPlayerViewController.h"
#import "AppDelegate.h"
#import "UIView+UIView_Frame.h"
#import "CoreDataManager.h"
#import "VideoCVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "netErrorPage.h"
#import <Reachability.h>
#import <BmobSDK/Bmob.h>
#import "PrefixHeader.pch"

@interface VideoVC () <UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView             *scroll;
@property (nonatomic, retain) UIPageControl            *page;

@property (nonatomic, retain) VideoView *leftView;
@property (nonatomic, retain) VideoView *middleView;
@property (nonatomic, retain) VideoView *rightView;
@property (nonatomic ,copy  ) NSString       *nextPageUrl;
@property (nonatomic ,copy  ) NSURL       *url;
@property (nonatomic, strong) VideoCVC *videoCVC;
@property (nonatomic, assign) BOOL isscrolling;
@property (nonatomic, retain) netErrorPage *errorPage;
@property (nonatomic , copy) NSString       *logUsername;
@property (nonatomic , assign) BOOL       *isUsingWifi;
@property (nonatomic , assign) UIView *launchView;
@end

@implementation VideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loggedBefore];
    if (!_middleImageIndex) {
        _middleImageIndex = 0;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *launch = [storyboard instantiateInitialViewController];
    _launchView = launch.view;
    UIWindow *windows = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [windows makeKeyWindow];
    [windows addSubview:_launchView];
    
    [self createUI];
    //  监测网络
    [self testNetwork];;
}

//  判断用户是否登陆过
- (void)loggedBefore {
    //  初始化数据库
    [[CoreDataManager shareInstance]initCoreData];
    _logUsername = [[CoreDataManager shareInstance]selectLogedUsername];
    if (_logUsername == nil || [_logUsername isEqualToString:@""]) {
        //  没有登陆过
    }else {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.logUsername = _logUsername;
        appDelegate.islogged = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_middleImageIndex != 0) {
        [self mainThreadAction];
    }
}

//  请求网络数据
- (void)getResourse {
    NSString *transString = [@"开胃" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *stringUrl = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/videos?num=10&categoryName=%@", transString];
    self.url = [NSURL URLWithString:stringUrl];
    [[[NSURLSession sharedSession] dataTaskWithURL:self.url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.nextPageUrl = [NSString stringWithFormat:@"%@&vc=125&u=368b8de74a9593712417679fd40adc8d79436584&v=1.8.1&f=iphone",[dic valueForKey:@"nextPageUrl"]];
            self.modelArray =[VideoModel jsonToModel:dic];
            [self performSelectorOnMainThread:@selector(mainThreadAction) withObject:nil waitUntilDone:YES];
        }
    }]resume];
}

- (void)testNetwork {
    [self removeErrorpage];
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            [self addErrorPage];
            break;
        case ReachableViaWWAN:
            [self removeErrorpage];
            [self getResourse];
            // 使用3G网络
            break;
        case ReachableViaWiFi:
            [self removeErrorpage];
            [self getResourse];
            _isUsingWifi = YES;
            // 使用WiFi网络
            break;
    }
}

- (void)addErrorPage {
    _errorPage = [[netErrorPage alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [_errorPage.refreash addTarget:self action:@selector(testNetwork) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_errorPage];
}

- (void)removeErrorpage {
    if ([self.view.subviews containsObject:_errorPage]) {
        [_errorPage removeFromSuperview];
    }
}

- (void)mainThreadAction {
    [self.leftView setValueWithVideoModel:self.modelArray[self.middleImageIndex == 0 ? self.modelArray.count - 1 : self.middleImageIndex - 1]];
    [self.middleView setValueWithVideoModel:self.modelArray[self.middleImageIndex]];
    [self.rightView setValueWithVideoModel:self.modelArray[self.middleImageIndex == self.modelArray.count - 1 ? 0 : self.middleImageIndex + 1]];
    [self checkCollected];
//    [_launchView removeFromSuperview];
}

- (void)createUI {
    self.scroll = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.scroll.contentSize = CGSizeMake(KScreenWidth * 3, KScreenHeight);
    self.scroll.contentOffset = CGPointMake(KScreenWidth, 0);
    self.scroll.backgroundColor = [UIColor blackColor];
    self.scroll.pagingEnabled = YES;
    self.scroll.delegate = self;
    [self.view addSubview:self.scroll];
    self.scroll.showsHorizontalScrollIndicator = NO;
    
    self.leftView = [[VideoView alloc]init];
    self.leftView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.scroll addSubview:self.leftView];
    
    self.middleView = [[VideoView alloc]init];
    self.middleView.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight);
    [self.scroll addSubview:self.middleView];
    [self.middleView.playButton addTarget:self action:@selector(checkNetBeforPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.middleView.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [self.middleView.changeViewButton addTarget:self action:@selector(changeView) forControlEvents:UIControlEventTouchUpInside];
    [self.middleView.shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightView = [[VideoView alloc]init];
    self.rightView.frame = CGRectMake(KScreenWidth * 2, 0, KScreenWidth, KScreenHeight);
    [self.scroll addSubview:self.rightView];
    
    self.page = [[UIPageControl alloc]init];
    CGSize size = [self.page sizeForNumberOfPages:self.modelArray.count];
    self.page.frame = CGRectMake((KScreenWidth - size.width)/2, KScreenHeight - 60, size.width, size.height);
    self.page.numberOfPages = self.modelArray.count;
    self.page.currentPage = self.middleImageIndex;
    [self.page addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.page];
    
}

- (void)shareAction {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    VideoModel *model = _modelArray[_middleImageIndex];
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"我在SeeFood中发现了一个超棒的视频《%@》,%@", model.title,model.playUrl]
                                     images:@[model.coverForDetail]
                                        url:self.url
                                      title:model.title
                                       type:SSDKContentTypeImage];
    
    //进行分享
    [ShareSDK showShareEditor:SSDKPlatformTypeSinaWeibo
           otherPlatformTypes:@[@(SSDKPlatformTypeTencentWeibo), @(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)]
                  shareParams:shareParams
          onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
     {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}

- (void)changeView {
    [self.delegate changeView];
}

- (void)like:(UIButton *)button {
    VideoModel *model = self.modelArray[_middleImageIndex];
    if (!button.selected) {
        //  添加收藏
        BmobObject *video = [BmobObject objectWithClassName:@"Collection"];
        [video setObject:_logUsername forKey:@"username"];
        [video setObject:model.title forKey:@"title"];
        [video setObject:[NSNumber numberWithDouble:model.date] forKey:@"date"];
        [video setObject:[NSNumber numberWithInteger:model.id] forKey:@"id"];
        [video setObject:[NSNumber numberWithInteger:model.shareCount] forKey:@"shareCount"];
        [video setObject:model.coverForDetail forKey:@"coverForDetail"];
        [video setObject:model.coverBlurred forKey:@"coverBlurred"];
        [video setObject:model.playUrl forKey:@"playUrl"];
        typeof(self) __weak weak = self;
        [video saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
                [weak presentViewController:alert animated:YES completion:^{
                    [weak performSelector:@selector(alertDismiss:) withObject:alert afterDelay:1];
                }];
                NSInteger count = [weak.middleView.like.text integerValue];
                weak.middleView.like.text = [NSString stringWithFormat:@"%ld", count + 1];
                weak.middleView.like.textColor = [UIColor redColor];
            }else {
                NSLog(@"%@", error);
            }
        }];
    }else {
        //  删除收藏
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collection"];
        [bquery whereKey:@"username" equalTo:_logUsername];
        [bquery whereKey:@"id" equalTo:[NSNumber numberWithInteger:model.id]];
        typeof(self) __weak weak = self;
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                //  不存在数据
            }else {
                //  开始删除数据
                BmobObject *video = [array lastObject];
                [video deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //  删除成功
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"收藏删除成功" preferredStyle:UIAlertControllerStyleAlert];
                        [weak presentViewController:alert animated:YES completion:^{
                            [weak performSelector:@selector(alertDismiss:) withObject:alert afterDelay:1];
                        }];
                        NSInteger count = [weak.middleView.like.text integerValue];
                        weak.middleView.like.text = [NSString stringWithFormat:@"%ld", count - 1];
                        weak.middleView.like.textColor = [UIColor blackColor];
                    }else {
                        NSLog(@"%@", error);
                    }
                }];
            }
            
        }];
    }
    button.selected = !button.selected;
}

- (void)alertDismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (void)pageAction:(UIPageControl *)page{
    self.middleImageIndex = page.currentPage;
    [self.scroll setContentOffset:CGPointMake((page.currentPage + 1) * KScreenWidth, 0) animated:YES];
}

- (void)checkNetBeforPlay {
    //  网络判断
    if (!_isUsingWifi) {
        //  使用流量
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You will watch the video under WWAN. This may cause extra cost!Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self playVedio];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            return;
        }];
        [alert addAction:OK];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [self playVedio];
    }
}

-(void)playVedio {
    AVPlayerViewController *avPlayerVC = [[AVPlayerViewController alloc]init];
    VideoModel *model = self.modelArray[_middleImageIndex];
    if (model == nil) {
        return;
    }
    avPlayerVC.url = [[NSURL alloc]initWithString:model.playUrl];
    
    //  旋转
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.isRotation = YES;
    [self presentViewController:avPlayerVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isscrolling = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat al = fabs((self.scroll.contentOffset.x - KScreenWidth) / KScreenWidth);
    //    NSLog(@"%f", al);
    if (self.scroll.contentOffset.x < KScreenWidth){
        self.leftView.backImage.x = self.scroll.contentOffset.x;
        self.middleView.backImage.alpha = 1 - al;
        
        self.middleView.backImage.x = -(KScreenWidth - self.scroll.contentOffset.x);
        self.leftView.backImage.alpha = al;
        
        if (_isscrolling) {
//            [self checkLeftCollected];
            _isscrolling = NO;
        }
    }else {
        self.middleView.backImage.x = self.scroll.contentOffset.x - KScreenWidth;
        self.middleView.backImage.alpha = 1 - al;
        
        self.rightView.backImage.x = -(KScreenWidth * 2 - self.scroll.contentOffset.x);
        self.rightView.backImage.alpha = al;
        if (_isscrolling) {
//            [self checkRightCollected];
            _isscrolling = NO;
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger leftImageIndex, rightImageIndex;
    if (self.scroll.contentOffset.x == KScreenWidth) {
        return;
    }else if (self.scroll.contentOffset.x < KScreenWidth){
        self.middleImageIndex = (self.middleImageIndex + self.modelArray.count - 1)%self.modelArray.count;
    }else {
        self.middleImageIndex = (self.middleImageIndex + self.modelArray.count + 1)%self.modelArray.count;
    }
    
    leftImageIndex = (self.middleImageIndex + self.modelArray.count - 1)%self.modelArray.count;
    rightImageIndex = (self.middleImageIndex + 1)%self.modelArray.count;
    
    [self.middleView setValueWithVideoModel:self.modelArray[self.middleImageIndex]];
    [self.leftView setValueWithVideoModel:self.modelArray[leftImageIndex]];
    [self.rightView setValueWithVideoModel:self.modelArray[rightImageIndex]];
    
    //  重新检查是否被收藏
    [self checkCollected];
    
    //    //  根据scroll偏移量来计算出currentpage
    if (self.scroll.contentOffset.x == KScreenWidth * 2) {
        self.scroll.contentOffset = CGPointMake(KScreenWidth, 0);
    }else if (self.scroll.contentOffset.x == 0) {
        self.scroll.contentOffset = CGPointMake(KScreenWidth, 0);
    }
    self.page.currentPage = self.middleImageIndex;
}

//  判断是否已经被收藏
- (void)checkCollected{
    VideoModel *model = self.modelArray[_middleImageIndex];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collection"];
    [bquery whereKey:@"username" equalTo:_logUsername];
    [bquery whereKey:@"id" equalTo:[NSNumber numberWithInteger:model.id]];
    typeof(self) __weak weak = self;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count == 0) {
            //  没有收藏
            weak.middleView.likeButton.selected = NO;
            weak.middleView.like.textColor = [UIColor blackColor];
        }else {
            //  被收藏
            NSInteger count = [weak.middleView.like.text integerValue];
            weak.middleView.like.text = [NSString stringWithFormat:@"%ld", count + 1];
            weak.middleView.likeButton.selected = YES;
            weak.middleView.like.textColor = [UIColor redColor];
        }
    }];
}

- (void)checkLeftCollected {
    VideoModel *model = self.modelArray[(self.middleImageIndex + self.modelArray.count - 1)%self.modelArray.count];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collection"];
    [bquery whereKey:@"username" equalTo:_logUsername];
    [bquery whereKey:@"id" equalTo:[NSNumber numberWithInteger:model.id]];
    typeof(self) __weak weak = self;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count == 0) {
            //  没有收藏
            weak.leftView.likeButton.selected = NO;
            weak.leftView.like.textColor = [UIColor blackColor];
        }else {
            //  被收藏
            NSInteger count = [weak.leftView.like.text integerValue];
            weak.leftView.like.text = [NSString stringWithFormat:@"%ld", count + 1];
            weak.leftView.likeButton.selected = YES;
            weak.leftView.like.textColor = [UIColor redColor];
        }
    }];
}


- (void)checkRightCollected {
    VideoModel *model = self.modelArray[(self.middleImageIndex + 1)%self.modelArray.count];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Collection"];
    [bquery whereKey:@"username" equalTo:_logUsername];
    [bquery whereKey:@"id" equalTo:[NSNumber numberWithInteger:model.id]];
    typeof(self) __weak weak = self;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count == 0) {
            //  没有收藏
            weak.rightView.likeButton.selected = NO;
            weak.rightView.like.textColor = [UIColor blackColor];
        }else {
            //  被收藏
            NSInteger count = [weak.rightView.like.text integerValue];
            weak.rightView.like.text = [NSString stringWithFormat:@"%ld", count + 1];
            weak.rightView.likeButton.selected = YES;
            weak.rightView.like.textColor = [UIColor redColor];
        }
    }];
}
@end
