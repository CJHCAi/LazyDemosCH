//
//  MainViewController.m
//  Text_QQMainView
//
//  Created by jaybin on 15/4/17.
//  Copyright (c) 2015年 jaybin. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "CommonTools.h"

#define LEFTBUTTONTAG 100;
#define RIGHTBUTTONTAG 200

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize barButtonBlock=_barButtonBlock;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 设置 navigationbar 样式
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.barTintColor = [CommonTools colorWithHexString:@"#25b6ed"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //初始化导航条的左右两个按钮
    [self initNavigationLeftbarButtonItem];
    [self initNavigationRightbarButtonItem];
    
    //初始化导航条中间的segment视图
    [self initTitleView];
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, SCREEM_WIDTH, 100)];
    textLbl.text = @"home";
    [textLbl setFont:[UIFont boldSystemFontOfSize:70]];
    [textLbl setTextAlignment:NSTextAlignmentCenter];
    [textLbl setTextColor:[UIColor yellowColor]];
    [self.view addSubview:textLbl];
}

- (void)initTitleView{
    // 设置中间 segmentView 视图
    UISegmentedControl *segmentView = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"消息", @"电话", nil]];
    segmentView.selectedSegmentIndex = 0;
    [segmentView setWidth:60 forSegmentAtIndex:0];
    [segmentView setWidth:60 forSegmentAtIndex:1];
    //[segmentView addTarget:self action:@selector(nil) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentView;
}

//初始化 LeftBarButton
- (void)initNavigationLeftbarButtonItem
{
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = CGRectMake(0, 0, 25, 25);
    [tmpButton setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    //定义点击时的响应函数
    [tmpButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc] initWithCustomView:tmpButton];
    self.navigationItem.leftBarButtonItem = leftbtn;
}

//初始化 RightBarButton
- (void)initNavigationRightbarButtonItem
{
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = CGRectMake(0, 0, 25, 25);
    [tmpButton setImage:[UIImage imageNamed:@"xingxing_yellow"] forState:UIControlStateNormal];
    //定义点击时的响应函数
    [tmpButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithCustomView:tmpButton];
    self.navigationItem.rightBarButtonItem = rightbtn;
}

//定义点击时的响应函数
- (void)leftButtonClicked:(id)sender{
    _barButtonBlock(ELeftButtonClicked);
}

//定义点击时的响应函数
- (void)rightButtonClicked:(id)sender{
    _barButtonBlock(ERightButtonClicked);
}

- (void)pushToSubView:(NSString *)desc{
    DetailViewController *detailView = [[DetailViewController alloc] init];
    detailView.text = desc;
    [detailView.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:detailView animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
