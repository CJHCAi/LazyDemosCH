//
//  HHAPPGuideViewController.m
//  RuiYiEducation
//
//  Created by 火虎MacBook on 2020/8/6.
//  Copyright © 2020 ruizhixue. All rights reserved.
//

#import "HHAPPGuideViewController.h"
#import "AppDelegate.h"

@interface HHAPPGuideViewController ()<UIScrollViewDelegate>
@property(nonatomic,weak) UIScrollView *scroll;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *guideImages;
@property (nonatomic,assign) BOOL isShowPageDot;
@property (nonatomic,strong) UIViewController *rootVC;



@end

@implementation HHAPPGuideViewController

-(instancetype)initwithGuideImages:(NSArray<NSString *> *)guideImages showPageControl:(BOOL)isShowisShowPageDot rootViewControler:(UIViewController *)rootVC{
    _guideImages = guideImages;
    _isShowPageDot = isShowisShowPageDot;
    _rootVC = rootVC;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    
}
-(void)createScrollView{
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.pagingEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    self.scroll = scrollView;  
    
    int imgW=ScreenW;
    int imgH=ScreenH;
    for (int i = 0; i<_guideImages.count; i++) {
        UIImage *img=[UIImage imageNamed:_guideImages[i]];
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(i*imgW, 0, imgW, imgH)];
        imgView.image=img;
        [scrollView addSubview:imgView];
        
        if (i==_guideImages.count-1) {
            UIButton *btn=[UIButton buttonWithType:(UIButtonTypeCustom)];
            [btn setTitle:@"立即体验" forState:(UIControlStateNormal)];
            btn.titleLabel.font =[UIFont systemFontOfSize:18];
            imgView.userInteractionEnabled=YES;
            [imgView addSubview:btn];
            CGFloat btnW=130;
            CGFloat btnH=46;
            CGFloat btnX=(imgW-btnW) *0.5;
            CGFloat btnY=imgH *0.9;
            btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            btn.layer.cornerRadius = 23;
            btn.layer.masksToBounds = YES;
            [btn.layer setBorderWidth:2.0]; //边框宽度
            [btn.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色
            btn.backgroundColor = ThemeColor;
            [btn addTarget:self action:@selector(goMainController) forControlEvents:(UIControlEventTouchUpInside)];
        }
    }
    
    scrollView.contentSize=CGSizeMake(_guideImages.count *imgW, 0);
    
    if (_isShowPageDot == YES) {
        //创建pageControl
        _pageControl = [[UIPageControl alloc] init];
        //设置页数
        [_pageControl setNumberOfPages:_guideImages.count];
        //获取大小
        CGSize pageSize = [_pageControl sizeForNumberOfPages:3];
        //设置frame
        [_pageControl setFrame:CGRectMake((self.view.frame.size.width-pageSize.width)/2.0, self.view.frame.size.height-pageSize.height, pageSize.width, pageSize.height)];
        //设置选中小点颜色
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
        //设置未选中小点颜色
        [_pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [self.view addSubview:_pageControl];
    }
}

-(void)goMainController{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = _rootVC;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:APPGuideFirstShowKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_isShowPageDot) {
            //获取当前页数
        NSInteger currentP = scrollView.contentOffset.x/scrollView.frame.size.width;
        _pageControl.currentPage = currentP;
    }
}

@end
