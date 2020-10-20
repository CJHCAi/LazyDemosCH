//
//  RootTabBarViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/24.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "Tools.h"
#import "YHomeViewController.h"
#import "FamilServiceViewController.h"

#define TabBarBtn_tag 10

@interface RootTabBarViewController ()
{
    NSArray *_viewControllersTitles;
    NSArray *_barImageArr;
    NSArray *_barSelectedImageArr;
}

//-(void)configTabBarViewController;  /**< 配置标签控制器 */
//-(void)initTabBarItem;/*自定义标签栏item*/
-(void)initData;/*初始化数据*/
@end

@implementation RootTabBarViewController

#pragma mark *** 生命周期 ***
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self configTabBarViewController];

    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)clickToTab:(UIButton *)sender{
    self.selectedIndex = sender.tag;
    sender.selected = !sender.selected;
}

#pragma mark *** 初始化数据 ***
-(void)initData{
    //标题、图片和选择图片
    _viewControllersTitles = @[kStringWithHomeVcTitle,kStringWithFamilyTreeVcTitle,kStringWithServiceVcTitle,kStringWithPersonalCenterVcTitle];
    _barImageArr = @[kImageWithHomeVc,kImageWithFamilyTreeVc,kImageWithServiceVc,kImageWithPersonalCenterVc];
    _barSelectedImageArr = @[kSelectedImageWithHomeVc,kSelectedImageWithFamilyTreeVc,kSelectedImageWithServiceVc,kSelectedImageWithPersonalCenterVc];
}


- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


#pragma mark *** 配置标签控制器 ***

-(void)configTabBarViewController{
    //初始化控制器
    YHomeViewController *homeVc = [[YHomeViewController alloc]init];
    FamilyTreeViewController *familyVc = [[FamilyTreeViewController alloc] init];
    FamilServiceViewController *serviceVC = [[FamilServiceViewController alloc]init];
    PersonalCenterViewController *personCen = [[PersonalCenterViewController alloc] init];
    //控制器数组
    NSArray *viewControllers = @[homeVc,familyVc,serviceVC,personCen];
    
    //配置全部viewControllers的导航控制器
    NSMutableArray *navs = [@[] mutableCopy];
    
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *title = _viewControllersTitles[idx];
        
        vc.title = title;
        
        //初始化导航控制器
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        //nav.navigationBar.barTintColor = [UIColor colorWithRed:75/255.0 green:88/255.0 blue:91/255.0 alpha:1];
        //nav.navigationBar.tintColor = [UIColor redColor];
        nav.navigationBar.translucent = YES;
        //隐藏导航栏
//        nav.navigationController.toolbarHidden = YES;
        
        //配置标签栏item
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
        tabBarItem.title = _viewControllersTitles[idx];
        
        UIImage *image = [self scaleToSize:MImage(_barImageArr[idx]) size:CGSizeMake(20, 20)];
        
        tabBarItem.image = image;
        
        UIImage *selectedImage = [self scaleToSize:MImage(_barSelectedImageArr[idx]) size:CGSizeMake(20, 20)];
        
        tabBarItem.selectedImage = selectedImage;
        
        
        vc.tabBarItem = tabBarItem;
        
        [navs addObject:nav];
    }];
    
    //设置标签控制器的导航控制器
    self.viewControllers = navs;
    //配置标签栏颜色
    self.selectedIndex = 0;
    self.tabBar.tintColor = LH_RGBCOLOR(34, 163, 182);
    //设置标签栏背景图
    [self.tabBar setBackgroundImage:MImage(@"sy_tabbg")];
    self.tabBar.contentMode = UIViewContentModeScaleAspectFit;
    self.tabBar.translucent = NO;
    UISwipeGestureRecognizer *swipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSwipGes:)];
    swipGes.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tabBar addGestureRecognizer:swipGes];
    
    for (UIBarItem *item in self.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0], NSFontAttributeName, nil]
                            forState:UIControlStateNormal];
        
    }
    
}
-(void)respondsToSwipGes:(UISwipeGestureRecognizer *)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.selectedIndex+1>3) {
            self.selectedIndex = 0;
        }else{
            self.selectedIndex+=1;
        }
    }
    

}

#pragma mark *** BtnEvents ***

-(void)respondsToItemBtn:(UIButton *)sender{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.selectedIndex = sender.tag-TabBarBtn_tag;
    //sender.selected = !sender.selected;
}

@end
