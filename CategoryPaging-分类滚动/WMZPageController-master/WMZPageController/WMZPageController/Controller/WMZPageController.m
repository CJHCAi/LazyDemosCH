//
//  WMZPageController.m
//  WMZPageController
//
//  Created by wmz on 2019/9/22.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZPageController.h"
@interface WMZPageController()
{
    BOOL hadWillDisappeal;
    NSInteger footerViewIndex;
    CGFloat sonChildVCHeight;
    CGFloat sonChildVCY;
    CGRect pageDataFrame;
    CGRect pageUpScFrame;
}
//当前子控制器中的滚动视图
@property(nonatomic,strong)UIScrollView *currentScroll;
//子控制器中的滚动视图数组(底部有多层的情况)
@property(nonatomic,strong)NSArray *currentScrollArr;
//当前子控制器中需要固定的底部视图
@property(nonatomic,strong)UIView *currentFootView;
//头部视图
@property(nonatomic,strong)UIView *headView;
//头部视图菜单栏底部的占位视图(如有需要)
@property(nonatomic,strong)UIView *head_MenuView;
//视图消失时候的导航栏透明度 有透明度变化的时候
@property(nonatomic,strong)NSNumber *lastAlpah;
//视图出现时候的导航栏透明度
@property(nonatomic,strong)NSNumber *enterAlpah;
//底部tableView是否可以滚动
@property (nonatomic, assign) BOOL canScroll;
//onTableView是否可以滚动
@property (nonatomic, assign) BOOL sonCanScroll;
//到达顶部
@property (nonatomic, assign) BOOL scrolTotop;
//到达底部
@property (nonatomic, assign) BOOL scrolToBottom;

@property (nonatomic, strong) UIView *naviBarBackGround;
//headHeight
@property (nonatomic, assign) CGFloat headHeight;
@end
@implementation WMZPageController
//更新
- (void)updatePageController{
    [self.upSc removeFromSuperview];
    [self.downSc removeFromSuperview];
    self.downSc = [[WMZPageScroller alloc]initWithFrame:CGRectMake(0, 0, PageVCWidth, PageVCHeight) style:UITableViewStyleGrouped];
    [self.sonChildScrollerViewDic removeAllObjects];
    [self.sonChildFooterViewDic removeAllObjects];
    footerViewIndex = -1;
    for (UIViewController *VC in self.childViewControllers) {
        [VC willMoveToParentViewController:nil];
        [VC.view removeFromSuperview];
        [VC removeFromParentViewController];
    }
    [self setParam];
    [self UI];
}

//更新头部
- (void)updateHeadView{
    [self setUpHead];
}

/*
*底部手动滚动  传入CGPointZero则为吸顶临界点
*/
- (void)downScrollViewSetOffset:(CGPoint)point animated:(BOOL)animat;{
    if (CGPointEqualToPoint(point, CGPointZero)) {
        //顶点
        int topOffset = self.downSc.contentSize.height - self.downSc.frame.size.height;
        point = CGPointMake(self.downSc.contentOffset.x, topOffset);
    }
    [self.downSc setContentOffset:point animated:animat];
}


- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setParam];
        [self UI];
        if (self.naviBarBackGround&&self.param.wNaviColor) {
            self.naviBarBackGround.backgroundColor = self.param.wNaviColor;
        }
    });
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.naviBarBackGround&&self.param.wNaviAlpha) {
        self.lastAlpah = @(self.naviBarBackGround.alpha);
    }
     hadWillDisappeal = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.naviBarBackGround&&self.param.wNaviAlpha) {
        self.lastAlpah = @(self.naviBarBackGround.alpha);
        self.naviBarBackGround.alpha = self.enterAlpah?self.enterAlpah.floatValue:1;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    hadWillDisappeal = NO;
    if (self.navigationController&&self.param.wNaviAlpha) {
        self.naviBarBackGround.alpha = 0;
        if (self.naviBarBackGround&&self.lastAlpah){
            self.naviBarBackGround.alpha = self.lastAlpah.floatValue;
            return;
        }
        if (self.param.wNaviAlphaAll) {
            self.naviBarBackGround = self.navigationController.navigationBar;
            self.enterAlpah = @(self.naviBarBackGround.alpha);
            [self.naviBarBackGround setAlpha:0];
        }else{
           NSMutableArray *loop= [NSMutableArray new];
           [loop addObject:[self.navigationController.navigationBar subviews]];
           while (loop.count) {
               NSArray *arr = loop.lastObject;
               [loop removeLastObject];
               for (NSInteger i = arr.count - 1; i >= 0; i--) {
                   UIView *view = arr[i];
                   [loop addObject:view.subviews];
                   if ([[UIDevice currentDevice].systemVersion intValue]>=12&&[[UIDevice currentDevice].systemVersion intValue]<13){
                       if ([NSStringFromClass([view class]) isEqualToString:@"UIVisualEffectView"]) {
                           self.naviBarBackGround = view;
                           self.enterAlpah = @(self.naviBarBackGround.alpha);
                           [self.naviBarBackGround setAlpha:0];
                            break;
                       }
                   }else{
                       if ([NSStringFromClass([view class]) isEqualToString:@"_UIBarBackground"]||[NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarBackground"]) {
                           self.naviBarBackGround = view;
                           self.enterAlpah = @(self.naviBarBackGround.alpha);
                           [self.naviBarBackGround setAlpha:0];
                           break;
                       }
                   }
               }
           }
        }
        
    }
    
}

- (void)setParam{
    if (self.param.wInsertHeadAndMenuBg) {
        self.head_MenuView = [UIView new];
        self.param.wInsertHeadAndMenuBg(self.head_MenuView);
    }
    if (self.param.wMenuAnimal == PageTitleMenuAiQY) {
        if (!self.param.wMenuIndicatorWidth) {
            self.param.wMenuIndicatorWidth = 20;
        }
    }
    
    if (self.param.wMenuAnimal == PageTitleMenuNone||
        self.param.wMenuAnimal == PageTitleMenuCircle||
        self.param.wMenuAnimal == PageTitleMenuPDD) {
        self.param.wMenuAnimalTitleBig = NO;
        self.param.wMenuAnimalTitleGradient = NO;
    }
    
    if (self.param.wMenuAnimal == PageTitleMenuYouKu) {
        self.param.wMenuIndicatorWidth = 6;
        self.param.wMenuIndicatorHeight = 3;
    }
    if (self.param.wMenuAnimal == PageTitleMenuCircle) {
        if (CGColorEqualToColor(self.param.wMenuIndicatorColor.CGColor, PageColor(0xE5193E).CGColor)) {
            self.param.wMenuIndicatorColor = PageColor(0xe1f9fe);
        }
        if (CGColorEqualToColor(self.param.wMenuTitleSelectColor.CGColor, PageColor(0xE5193E).CGColor)) {
            self.param.wMenuTitleSelectColor = PageColor(0x00baf9);
        }
    }
    
    if (self.param.wMenuPosition == PageMenuPositionNavi) {
        if (CGColorEqualToColor(self.param.wMenuBgColor.CGColor, PageColor(0xffffff).CGColor)) {
            self.param.wMenuBgColor = [UIColor clearColor];
        }
    }
    
}


- (void)UI{

    self.cache = [NSCache new];
    self.cache.countLimit = 30;
    footerViewIndex = -1;
    CGFloat headY = 0;
    CGFloat tabbarHeight = 0;
    CGFloat statusBarHeight = 0;
    if (self.presentingViewController) {
        if (!self.navigationController) {
            statusBarHeight = PageVCStatusBarHeight;
        }
    } else if (self.tabBarController) {
        if (!self.tabBarController.tabBar.translucent) {
            tabbarHeight = 0;
        }else{
            tabbarHeight = PageVCTabBarHeight;
        }
    } else if (self.navigationController){
        headY = (!self.param.wFromNavi&&
                  self.param.wMenuPosition != PageMenuPositionNavi&&
                  self.param.wMenuPosition != PageMenuPositionBottom)?0:
       (!self.navigationController.navigationBar.translucent?0:PageVCNavBarHeight);
    }
    if (self.parentViewController) {
        
        if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *naPar = (UINavigationController*)self.parentViewController;
            headY = (!self.param.wFromNavi&&
            self.param.wMenuPosition != PageMenuPositionNavi&&
                     self.param.wMenuPosition != PageMenuPositionBottom)?0:
            (!naPar.navigationBar.translucent?0:PageVCNavBarHeight);
            if (self.parentViewController.tabBarController) {
                if (!self.parentViewController.tabBarController.tabBar.translucent) {
                    tabbarHeight = 0;
                }else{
                    tabbarHeight = PageVCTabBarHeight;
                }
            }
        }else if ([self.parentViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *ta = (UITabBarController*)self.parentViewController;
            if (!ta.tabBar.translucent) {
                tabbarHeight = 0;
            }else{
                tabbarHeight = PageVCTabBarHeight;
            }
            if (self.parentViewController.navigationController) {
                headY = (!self.param.wFromNavi&&
                self.param.wMenuPosition != PageMenuPositionNavi&&
                self.param.wMenuPosition != PageMenuPositionBottom)?0:(!self.parentViewController.navigationController.navigationBar.translucent?0:PageVCNavBarHeight);
            }else if(self.parentViewController.presentingViewController){
                statusBarHeight = PageVCStatusBarHeight;
            }
        }else if ([self.parentViewController isKindOfClass:[WMZPageController class]]) {
            headY = 0;
            tabbarHeight = 0;
            statusBarHeight = 0;
        }
    }
    
    
    if (self.hidesBottomBarWhenPushed&&tabbarHeight>=PageVCTabBarHeight) {
        tabbarHeight -= PageVCTabBarHeight;
    }
    
    //全屏
      if (self.navigationController) {
          for (UIGestureRecognizer *gestureRecognizer in self.downSc.gestureRecognizers) {
              [gestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
          }
      }
    
      if (@available(iOS 11.0, *)) {
          self.downSc.estimatedSectionFooterHeight = 0.01;
          self.downSc.estimatedSectionHeaderHeight = 0.01;
          self.downSc.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      }
      self.downSc.estimatedRowHeight = 100;
      self.downSc.sectionHeaderHeight = 0.01;
      self.downSc.sectionFooterHeight = 0.01;
      self.downSc.delegate = self;
      self.downSc.bounces = self.param.wBounces;
      self.downSc.frame = CGRectMake(0, headY, self.view.frame.size.width, self.view.frame.size.height-headY-tabbarHeight);
      self.downSc.canScroll = [self canTopSuspension];
      self.downSc.scrollEnabled = [self canTopSuspension];
      self.downSc.wFromNavi = self.param.wFromNavi;
      [self.view addSubview:self.downSc];
    

   //滚动和菜单视图
    self.upSc = [[WMZPageLoopView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) param:self.param];
    self.upSc.loopDelegate = self;
    self.downSc.tableFooterView = self.upSc;
    
    if (self.navigationController) {
        for (UIGestureRecognizer *gestureRecognizer in self.upSc.gestureRecognizers) {
            [gestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        }
    }
    //底部
    [self setUpMenuAndDataViewFrame];
    
    if (self.param.wCustomMenuTitle) {
        self.param.wCustomMenuTitle(self.upSc.btnArr);
    }
    
    [self setUpHead];
   
    [self.upSc.btnArr enumerateObjectsUsingBlock:^(WMZPageNaviBtn*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.param.wMenuDefaultIndex) {
            self.upSc.first = YES;
            [obj sendActionsForControlEvents:UIControlEventTouchUpInside];
            *stop = YES;
        }
    }];
    self.canScroll = YES;
    self.scrolToBottom = YES;
    
    if (@available(iOS 11.0, *)) {
        self.downSc.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setUpMenuAndDataViewFrame{
    sonChildVCY = 0;
    sonChildVCHeight = 0;
    CGFloat titleMenuhHeight = self.upSc.mainView.frame.size.height;
    if (self.param.wMenuPosition == PageMenuPositionNavi) {
        sonChildVCY = 0;
        sonChildVCHeight = self.downSc.frame.size.height;
    }else if (self.param.wMenuPosition == PageMenuPositionBottom) {
        sonChildVCY = 0;
        if (self.param.wMenuSpecifial == PageSpecialTypeOne) {
            sonChildVCHeight = self.downSc.frame.size.height;
        }else{
            sonChildVCHeight = self.downSc.frame.size.height - titleMenuhHeight;
        }
    }else{
        sonChildVCY = 0;
        sonChildVCHeight = self.downSc.frame.size.height - titleMenuhHeight;
    }
    if (self.param.wTopOffset) {
        sonChildVCHeight -= self.param.wTopOffset;
    }
    
    CGFloat height = [self canTopSuspension]?sonChildVCHeight :(sonChildVCHeight-self.headHeight);
    if ([self canTopSuspension]) {
        if (!self.parentViewController) {
            height -=PageVCStatusBarHeight;
        }else{
            if (![self.parentViewController isKindOfClass:[WMZPageController class]]) {
                if (self.navigationController) {
                    if (!self.param.wFromNavi) {
                        height -= (self.navigationController.navigationBar.translucent?PageVCNavBarHeight:0);
                        
                    }
                }else{
                    height -= PageVCStatusBarHeight;
                }
            }
        }
    }
    sonChildVCHeight = height;
    
    
    if (self.param.wMenuPosition == PageMenuPositionBottom){
        if (self.param.wMenuSpecifial == PageSpecialTypeOne) {
            [self.upSc.dataView page_y:0];
            [self.upSc.dataView page_height:sonChildVCHeight];
            [self.upSc.mainView page_y:sonChildVCHeight-titleMenuhHeight];
            [self.upSc page_height:CGRectGetMaxY(self.upSc.mainView.frame)];
            [self.upSc bringSubviewToFront:self.upSc.mainView];
        }else{
            [self.upSc.dataView page_y:0];
            [self.upSc.dataView page_height:sonChildVCHeight];
            [self.upSc.mainView page_y:CGRectGetMaxY(self.upSc.dataView.frame)];
            [self.upSc page_height:CGRectGetMaxY(self.upSc.mainView.frame)];
        }
    }else if (self.param.wMenuPosition == PageMenuPositionNavi && self.navigationController) {
        [self.upSc.mainView removeFromSuperview];
        [self.upSc.dataView page_y:0];
        [self.upSc.dataView page_height:sonChildVCHeight];
        [self.upSc page_height:CGRectGetMaxY(self.upSc.dataView.frame)];
        self.navigationItem.titleView = self.upSc.mainView;
    }else{
        [self.upSc.dataView page_y:CGRectGetMaxY(self.upSc.mainView.frame)];
        [self.upSc.dataView page_height:sonChildVCHeight];
        [self.upSc page_height:CGRectGetMaxY(self.upSc.dataView.frame)];
    }
    self.param.titleHeight = self.upSc.mainView.frame.size.height;
    self.downSc.menuTitleHeight = self.param.titleHeight;
    pageDataFrame = self.upSc.dataView.frame;
    pageUpScFrame = self.upSc.frame;
}

- (void)setUpHead{
    //头部视图
    if(self.param.wMenuHeadView&&
       self.param.wMenuPosition != PageMenuPositionNavi&&
       self.param.wMenuPosition != PageMenuPositionBottom) {
       self.headView = self.param.wMenuHeadView();
       self.headView.frame = CGRectMake(self.headView.frame.origin.x,  0, self.headView.frame.size.width, self.headView.frame.size.height);
        self.downSc.tableHeaderView = self.headView;
    }else{
        self.downSc.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake( 0, 0,self.view.frame.size.width, 0.01)];
    }
    //全景
    if (self.head_MenuView) {
        self.head_MenuView.frame = CGRectMake(0, self.headView?CGRectGetMinX(self.headView.frame):CGRectGetMinX(self.upSc.frame), self.upSc.frame.size.width, CGRectGetMaxY(self.upSc.frame)-self.upSc.dataView.frame.size.height);
        [self.downSc addSubview:self.head_MenuView];
        [self.downSc sendSubviewToBack:self.head_MenuView];
        self.upSc.mainView.backgroundColor = [UIColor clearColor];
        for (WMZPageNaviBtn *btn in self.upSc.btnArr) {
            btn.backgroundColor = [UIColor clearColor];
        }
        if (self.headView) {
            self.headView.backgroundColor = [UIColor clearColor];
        }
    }
}

//底部滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView!=self.downSc) return;
    if (![self canTopSuspension]) return;
    //偏移量
    float yOffset  = scrollView.contentOffset.y;
    //顶点
    int topOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //外部传入 修改此属性即可
    if (self.param.wTopOffset) {
        topOffset += self.param.wTopOffset;
    }
    if (yOffset<=0) {
        self.scrolToBottom = YES;
        
    }else{
        if (yOffset >= topOffset) {
            scrollView.contentOffset = CGPointMake(self.downSc.contentOffset.x, topOffset);
            self.scrolTotop = YES;
        }else{
            self.scrolTotop = NO;
        }
        self.scrolToBottom = NO;
    }
    if (self.scrolTotop) {
        self.sonCanScroll = YES;
        if (self.currentScroll.contentSize.height<=self.currentScroll.frame.size.height) {
            self.canScroll = YES;
        }else{
            self.canScroll = NO;
        }
    }else {
        if (!self.canScroll) {
            scrollView.contentOffset = CGPointMake(0, topOffset);
        }else {
             self.sonCanScroll = NO;
        }

    }
    
    CGFloat delta = scrollView.contentOffset.y/topOffset;
    if (delta>1) {
        delta = 1;
    }else if (delta < 0){
        delta = 0;
    }
    if (self.param.wNaviAlpha) {
        if (self.navigationController&&self.naviBarBackGround) {
            self.naviBarBackGround.alpha =  delta;
        }
        if (self.headView) {
            if (delta == 1) {
                self.headView.alpha = 0;
            }else{
                self.headView.alpha = 1;
            }
        }
    }
    if (self.param.wEventChildVCDidSroll) {
        self.param.wEventChildVCDidSroll(self,self.downSc.contentOffset, self.downSc.contentOffset, self.downSc);
    }
    //防止第一次加载不成功
    if (self.currentFootView&&
        self.currentFootView.frame.origin.y!=
        self.footViewOrginY) {
        [self.currentFootView page_y:self.footViewOrginY];
    }
}

//改变菜单栏高度
- (void)changeMenuFrame{
    if (!self.param.wTopChangeHeight) return;
    if (self.upSc.mainView.frame.size.height == self.param.titleHeight&&!self.sonCanScroll)return;
    CGFloat offsetHeight = self.param.wTopChangeHeight>0?MIN(self.currentScroll.contentOffset.y, self.param.wTopChangeHeight):MAX (-self.currentScroll.contentOffset.y, self.param.wTopChangeHeight);
    if (self.upSc.mainView.frame.size.height == (self.param.titleHeight-self.param.wTopChangeHeight)&&self.sonCanScroll&&offsetHeight == self.param.wTopChangeHeight)  return;
    [self.upSc.mainView page_height:self.param.titleHeight-offsetHeight];
    [self.upSc.dataView page_y:CGRectGetMaxY(self.upSc.mainView.frame)];
    [self.upSc.dataView page_height:pageDataFrame.size.height+offsetHeight];
    if (offsetHeight == 0) {
        if (self.param.wEventMenuNormalHeight) {
            self.param.wEventMenuNormalHeight(self.upSc.btnArr);
        }
    }else{
        if (self.param.wEventMenuChangeHeight) {
            self.param.wEventMenuChangeHeight(self.upSc.btnArr,self.currentScroll.contentOffset.y);
        }
    }
    //设置下划线
    [self.upSc endAninamal];
}
//设置悬浮
- (void)setUpSuspension:(UIViewController*)newVC index:(NSInteger)index end:(BOOL)end{
    if (![self canTopSuspension]) return;
    if ([newVC conformsToProtocol:@protocol(WMZPageProtocol)]) {
        UIScrollView *view = nil;
        if ([newVC respondsToSelector:@selector(getMyScrollViews)]) {
            NSArray *arr = [newVC performSelector:@selector(getMyScrollViews)];
            [arr enumerateObjectsUsingBlock:^(UIScrollView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 [self topSuspensionView:obj index:index*1000+idx+100];
            }];
            self.currentScrollArr = arr;
        }else{
            if ([newVC respondsToSelector:@selector(getMyTableView)]) {
                UIScrollView *tmpView = [newVC performSelector:@selector(getMyTableView)];
                if (tmpView&&[tmpView isKindOfClass:[UIScrollView class]]) {
                    view = tmpView;
                }
            }else if([newVC respondsToSelector:@selector(getMyScrollView)]){
                UIScrollView *tmpView = [newVC performSelector:@selector(getMyScrollView)];
                if (tmpView&&[tmpView isKindOfClass:[UIScrollView class]]) {
                    view = tmpView;
                }
            }
            [self topSuspensionView:view index:index];
        }

        if ([newVC respondsToSelector:@selector(fixFooterView)]) {
            UIView *tmpView = [newVC performSelector:@selector(fixFooterView)];
            [self.sonChildFooterViewDic setObject:view forKey:@(index)];
            self.currentFootView = tmpView;
            [self.view addSubview:self.currentFootView];
            self.currentFootView.hidden = NO;
            footerViewIndex = index;
            [self.currentFootView page_y:self.footViewOrginY];
        }else{
            if (self.currentFootView&&
                end) {
                if (!self.param.wFixFirst) {
                    self.currentFootView.hidden = YES;
                }
            }
        }
    }else{
        self.currentScroll = nil;
        self.currentFootView  = nil;
    }
}

- (void)topSuspensionView:(UIScrollView*)view index:(NSInteger)index{
    if (view&&[view isKindOfClass:[UIScrollView class]]) {
        self.currentScroll = view;
        [self.sonChildScrollerViewDic setObject:view forKey:@(index)];
        if (self.scrolToBottom) {
            [view setContentOffset:CGPointMake(view.contentOffset.x,0) animated:NO];
        }
        if (!self.sonCanScroll&&!self.scrolToBottom) {
            [view setContentOffset:CGPointZero animated:NO];
        }
        [view pageAddObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}

//底部左滑滚动
- (void)pageWithScrollView:(UIScrollView*)scrollView left:(BOOL)left{
    int offset = (int)scrollView.contentOffset.x%(int)self.upSc.frame.size.width;
    NSInteger index = floor(scrollView.contentOffset.x/self.upSc.frame.size.width);
    if (self.currentFootView) {
        int x = 0;
        CGFloat width = self.footViewSizeWidth;
        if (left) {
            if (scrollView.contentOffset.x>(self.upSc.frame.size.width*footerViewIndex)) {
                x = 0;
                width -= offset;
            }else{
                x = (int)self.upSc.frame.size.width - offset;
            }
        }else{
            if (scrollView.contentOffset.x>(self.upSc.frame.size.width*footerViewIndex)) {
               x = 0;
               width -= offset;
            }else{
               x = (int)self.upSc.frame.size.width - offset;
            }
        }
        if (offset == 0 && [self.sonChildFooterViewDic objectForKey:@(index)]) {
            x = self.footViewOrginX;
        }
        if (!self.param.wFixFirst) {
            [self.currentFootView page_x: x];
            [self.currentFootView page_width:width];
        }
    }
}


//选中按钮
- (void)selectBtnWithIndex:(NSInteger)index{
    if (self.currentFootView) {
        if (!self.param.wFixFirst) {
            [self.currentFootView page_x:self.footViewOrginX];
        }
    }
}

//监听子控制器中的滚动视图
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (![self canTopSuspension]) return;
        if (hadWillDisappeal) return;
        if (self.currentScroll!=object){
            self.currentScroll = object;
        };
        CGPoint newH = [[change objectForKey:@"new"] CGPointValue];
        CGPoint newOld = [[change objectForKey:@"old"] CGPointValue];
        if (newH.y==newOld.y)  return;
        if (!self.sonCanScroll&&!self.scrolToBottom) {
            self.currentScroll.contentOffset = CGPointZero;
            self.downSc.showsVerticalScrollIndicator = NO;
            self.currentScroll.showsVerticalScrollIndicator = NO;
        }else{
            self.downSc.showsVerticalScrollIndicator = NO;
            self.currentScroll.showsVerticalScrollIndicator = NO;
        }
        [self changeMenuFrame];
        if ((int)newH.y<=0) {
            self.canScroll = YES;
            if (self.param.wBounces) {
                self.currentScroll.contentOffset = CGPointZero;
            }
        }
    }
}

- (BOOL)canTopSuspension{
    if (!self.param.wTopSuspension
       ||self.param.wMenuPosition == PageMenuPositionBottom
       ||self.param.wMenuPosition == PageMenuPositionNavi){
          return NO;
    }
    return YES;
}

/*
*手动调用菜单到第index个
*/
- (void)selectMenuWithIndex:(NSInteger)index{
    [self.upSc.btnArr enumerateObjectsUsingBlock:^(WMZPageNaviBtn*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            [obj sendActionsForControlEvents:UIControlEventTouchUpInside];
            *stop = YES;
        }
    }];
}
- (NSMutableDictionary *)sonChildScrollerViewDic{
    if (!_sonChildScrollerViewDic) {
        _sonChildScrollerViewDic = [NSMutableDictionary new];
    }
    return _sonChildScrollerViewDic;
}

- (NSMutableDictionary *)sonChildFooterViewDic{
    if (!_sonChildFooterViewDic) {
        _sonChildFooterViewDic = [NSMutableDictionary new];
    }
    return _sonChildFooterViewDic;
}

- (WMZPageScroller *)downSc{
    if (!_downSc) {
        _downSc = [[WMZPageScroller alloc]initWithFrame:CGRectMake(0, 0, PageVCWidth, PageVCHeight) style:UITableViewStyleGrouped];
    }
    return _downSc;
}

- (CGFloat)footViewOrginY{
    if (!_footViewOrginY) {
        _footViewOrginY = CGRectGetMaxY(self.downSc.frame)-self.currentFootView.frame.size.height;
    }
    return _footViewOrginY;
}

- (CGFloat)headHeight{
    _headHeight = self.headView.frame.size.height;
    return _headHeight;
}

- (CGFloat)footViewSizeWidth{
    if (!_footViewSizeWidth) {
        _footViewSizeWidth = self.upSc.frame.size.width;
    }
    return _footViewSizeWidth;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [self.cache removeAllObjects];
    [self.sonChildScrollerViewDic removeAllObjects];
}

- (void)dealloc{
    [self.sonChildScrollerViewDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj removeAllObserverdKeyPath:self withKey:@"contentOffset"];
    }];
}
@end
