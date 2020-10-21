//
//  CYTabBarController.m
//  蚁巢
//
//  Created by 张春雨 on 2016/11/17.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CYTabBarController.h"
#if  __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
#import "UITabBarItem+BadgeColor.h"
#endif
#import <objc/runtime.h>

@interface CYTabBarController ()<UIGestureRecognizerDelegate>
// center button of place ( -1:none center button >=0:contain center button)
@property(assign , nonatomic) NSInteger centerPlace;
// Whether center button to bulge
@property(assign , nonatomic,getter=is_bulge) BOOL bulge;
// items
@property (nonatomic,strong) NSMutableArray <UITabBarItem *>*items;
@end

@implementation CYTabBarController {
    int _tabBarItemTag;
    int _lifecycleCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centerPlace = -1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_lifecycleCount == 0) {
        _lifecycleCount = 1;
        //  Initialize selected
        NSInteger index = [CYTabBarConfig shared].selectIndex;
        if (index < 0) {
            self.selectedIndex = (self.centerPlace != -1 && self.items[self.centerPlace].tag != -1)
            ? self.centerPlace
            : 0;
        } else if (index >= self.viewControllers.count){
            self.selectedIndex = self.viewControllers.count-1;
        }
        else {
            self.selectedIndex = index;
        }
        self.tabbar.backgroundColor = [CYTabBarConfig shared].backgroundColor;
        
        // add tabBar
        [self.tabBar addSubview:self.tabbar];
        self.tabbar.frame = self.tabBar.bounds;
        [self.view addSubview:self.contentView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSInteger version = [[[UIDevice currentDevice] systemVersion]integerValue];
    for (UIView *loop in self.tabBar.subviews) {
        if (version < 10 && loop.frame.size.height > 1.f) {
            loop.hidden = YES;
        }
        if (version >= 10 && !CGPointEqualToPoint(CGPointZero, loop.frame.origin)) {
            loop.hidden = YES;
        }
    }
}

/**
 *  Add other button for child’s controller
 */
- (void)addChildController:(id)Controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    UIViewController *vc = [self findViewControllerWithobject:Controller];
    vc.tabBarItem.title = title;
    
    if (imageName) {
        vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    if (selectedImageName) {
        vc.tabBarItem.selectedImage =  [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[[CYTabBarConfig shared] textColor] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[[CYTabBarConfig shared] selectedTextColor] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    vc.tabBarItem.tag = _tabBarItemTag++;
    [self.items addObject:vc.tabBarItem];
    [self addChildViewController:Controller];
}

/**
 *  Add center button
 */
- (void)addCenterController:(id)Controller bulge:(BOOL)bulge title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    _bulge = bulge;
    if (Controller) {
        [self addChildController:Controller title:title imageName:imageName selectedImageName:selectedImageName];
        self.centerPlace = _tabBarItemTag-1;
    }else{
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title
                                                          image:[UIImage imageNamed:imageName]
                                                  selectedImage:[UIImage imageNamed:selectedImageName]];
        item.tag = -1;
        [self.items addObject:item];
        self.centerPlace = _tabBarItemTag;
    }
}

/**
 *  getter
 */
- (CYTabBar *)tabbar{
    if (self.items.count && !_tabbar) {
        _tabbar = [[CYTabBar alloc]initWithFrame:self.tabBar.bounds];
        [_tabbar setValue:self forKey:@"controller"];
        [_tabbar setValue:[NSNumber numberWithBool:self.bulge] forKey:@"bulge"];
        [_tabbar setValue:[NSNumber numberWithInteger:self.centerPlace] forKey:@"centerPlace"];
        _tabbar.items = self.items;
    }
    return _tabbar;
}

- (ContentView *)contentView{
    if (!_contentView) {
        CGRect rect = self.tabBar.frame;
        rect.origin.y -= [CYTabBarConfig shared].bulgeHeight+10.f;
        rect.size.height += [CYTabBarConfig shared].bulgeHeight+10.f;
        _contentView = [[ContentView alloc]initWithFrame:rect];
        _contentView.controller = self;
    }
    return _contentView;
}

- (NSMutableArray <UITabBarItem *>*)items{
    if(!_items){
        _items = [NSMutableArray array];
    }
    return _items;
}

/**
 *  Update current select controller
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    if (selectedIndex >= self.viewControllers.count){
        @throw [NSException exceptionWithName:@"selectedTabbarError"
                                       reason:@"No controller can be used,Because of index beyond the viewControllers,Please check the configuration of tabbar."
                                     userInfo:nil];
    }
    [super setSelectedIndex:selectedIndex];
    [self.tabbar setValue:[NSNumber numberWithInteger:selectedIndex] forKeyPath:@"selectButtoIndex"];
}

/**
 *  Catch viewController
 */
- (UIViewController *)findViewControllerWithobject:(id)object{
    while ([object isKindOfClass:[UITabBarController class]] || [object isKindOfClass:[UINavigationController class]]){
        object = ((UITabBarController *)object).viewControllers.firstObject;
    }
    return object;
}

/**
 *  hidden tabbar and do animated
 */
- (void)setTabBarHidden:(id)hidden {
    NSTimeInterval time = 0.6;
    if ([hidden boolValue]) {
        CGFloat h = self.tabBar.frame.size.height*2;
        [UIView animateWithDuration:time-0.1 animations:^{
            self.tabBar.transform = CGAffineTransformMakeTranslation(0,h);
        }completion:^(BOOL finished) {
            self.tabBar.hidden = YES;
        }];
    } else {
        self.tabBar.hidden = NO;
        [UIView animateWithDuration:time animations:^{
            self.tabBar.transform = CGAffineTransformIdentity;
        }];
    }
}
@end
