//
//  SXTMainViewController.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/1.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTMainViewController.h"
#import "SXTMainTopView.h"

@interface SXTMainViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, strong) NSArray * datalist;

@property (nonatomic, strong) SXTMainTopView * topView;

@end

@implementation SXTMainViewController

- (SXTMainTopView *)topView {
    
    if (!_topView) {
        _topView = [[SXTMainTopView alloc] initWithFrame:CGRectMake(0, 0, 200, 50) titleNames:self.datalist];
        _topView.backgroundColor=[UIColor purpleColor];
        @weakify(self);
        _topView.block = ^(NSInteger tag) {
            @strongify(self);
            CGPoint point = CGPointMake(tag * SCREEN_WIDTH, self.contentScrollView.contentOffset.y);
            [self.contentScrollView setContentOffset:point animated:YES];
            
        };
    }
    return _topView;
}

- (NSArray *)datalist {
    
    if (!_datalist) {
        _datalist = @[@"关注",@"热门",@"附近"];
    }
    return _datalist;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    
    //添加左右按钮
    [self setupNav];

    [self.view addSubview:self.contentScrollView];
    //添加子视图控制器
    [self setupChildViewControllers];
    
    
}
- (void)setupNav {
    
    self.navigationItem.titleView = self.topView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"global_search"] style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_button_more"] style:UIBarButtonItemStyleDone target:nil action:nil];
}

/**添加子视图控制器*/
- (void)setupChildViewControllers {
    
    NSArray * vcNames = @[@"SXTFocuseViewController",@"SXTHotViewController",@"SXTNearViewController"];
    
    for (NSInteger i = 0; i < vcNames.count; i ++) {
        NSString * vcName = vcNames[i];
        
        UIViewController * vc = [[NSClassFromString(vcName) alloc] init];
        vc.title = self.datalist[i];
        //当执行这句话addChildViewController时，不会执行该vc的viewdidload
        [self addChildViewController:vc];
    }
    
    //将子控制器的view，加到MainVC的scrollview上
    
    //设置scrollview的contentsize
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.datalist.count, 0);
    
    //默认先展示第二个页面
    self.contentScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    
    //进入主控制器加载第一个页面
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}


//动画结束调用代理
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGFloat width = SCREEN_WIDTH;//scrollView.frame.size.width;
    
    CGFloat height = SCREEN_HEIGHT - 64 - 49;
    
    CGFloat offset = scrollView.contentOffset.x;
    //获取索引值
    NSInteger idx = offset / width;
    
    //索引值联动topView
    [self.topView scrolling:idx];
    
    //根据索引值返回vc引用
    UIViewController * vc = self.childViewControllers[idx];
    
    //判断当前vc是否执行过viewdidLoad
    if ([vc isViewLoaded]) return;
    
    //设置子控制器view的大小
    vc.view.frame = CGRectMake(offset, 0, scrollView.frame.size.width, height);
    //将子控制器的view加入scrollview上
    [scrollView addSubview:vc.view];
    
}

//减速结束时调用加载子控制器view的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}







@end
