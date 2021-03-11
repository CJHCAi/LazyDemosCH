//
//  homePageViewController.m
//  DrivingLicense
//
//  Created by #incloud on 17/2/11.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "homePageViewController.h"
#import "SCRScrollMenuController.h"
#import "subjectOneViewController.h"

@interface homePageViewController ()

@property (nonatomic, strong) SCRScrollMenuController *scrollMenuController;

@end

@implementation homePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1.0];
    UIView *titileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, self.navigationController.navigationBar.frame.size.height )];
    titileView.backgroundColor = [UIColor clearColor];
    UIImageView *titleImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, titileView.frame.size.width, titileView.frame.size.height)];
    titleImg.image = [UIImage imageNamed:@"titileImage"];
    [titileView addSubview:titleImg];
    self.navigationItem.titleView = titileView;
    
    [self initScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initScrollView {
    self.scrollMenuController = [[SCRScrollMenuController alloc] init];
    self.scrollMenuController.scrollMenuHeight = 45;
    self.scrollMenuController.scrollMenuBackgroundColor = [UIColor whiteColor];
    self.scrollMenuController.scrollMenuIndicatorColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1.0];
    self.scrollMenuController.scrollMenuIndicatorHeight = 2;
    self.scrollMenuController.scrollMenuButtonPadding = 15;
    self.scrollMenuController.normalTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                        NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    self.scrollMenuController.selectedTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                          NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1.0]};
    [self addChildViewController:self.scrollMenuController];
    self.scrollMenuController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.scrollMenuController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.scrollMenuController.view];
    [self.scrollMenuController didMoveToParentViewController:self];
    
    // 设置导航标题内容
    NSArray *titles = @[@"科目一", @"科目二", @"科目三", @"科目四"];
    // 设置导航视图控制器集合容器大小
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:[titles count]];
    // 设置导航栏标题内容集合容器大小
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:[titles count]];
    
    subjectOneViewController *VC0 = [[subjectOneViewController alloc] init];
    [viewControllers addObject:VC0];
    SCRScrollMenuItem *item0 = [[SCRScrollMenuItem alloc] init];
    item0.title = [titles objectAtIndex:0];
    [items addObject:item0];
    
    UIViewController *VC1 = [[UIViewController alloc] init];
    UILabel *tempLabel =[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, SCREEM_HEIGHT * 0.3, 100, 30)];
    tempLabel.text = @"该模块暂未开放";
    tempLabel.font = [UIFont systemFontOfSize:14];
    tempLabel.textColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1.0];
    [VC1.view addSubview:tempLabel];
    [viewControllers addObject:VC1];
    VC1.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    SCRScrollMenuItem *item1 = [[SCRScrollMenuItem alloc] init];
    item1.title = [titles objectAtIndex:1];
    [items addObject:item1];
    
    UIViewController *VC2 = [[UIViewController alloc] init];
    [viewControllers addObject:VC2];
    UILabel *tempLabel2 =[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, SCREEM_HEIGHT * 0.3, 100, 30)];
    tempLabel2.text = @"该模块暂未开放";
    tempLabel2.font = [UIFont systemFontOfSize:14];
    tempLabel2.textColor = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1.0];
    [VC2.view addSubview:tempLabel2];
    VC2.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    SCRScrollMenuItem *item2 = [[SCRScrollMenuItem alloc] init];
    item2.title = [titles objectAtIndex:2];
    [items addObject:item2];
    
    subjectOneViewController *VC3 = [[subjectOneViewController alloc] init];
    [viewControllers addObject:VC3];
    SCRScrollMenuItem *item3 = [[SCRScrollMenuItem alloc] init];
    item3.title = [titles objectAtIndex:3];
    [items addObject:item3];

    
    [self.scrollMenuController setViewControllers:viewControllers withItems:items];
    
    [self.view addSubview:self.scrollMenuController.view];
}

@end
