//
//  YCMainViewController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCMainViewController.h"
#import "YCRecViewController.h"
#import "YCNewViewController.h"
#import "YCHotViewController.h"
#import "YCSearchViewController.h"

@interface YCMainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView   *mainScr;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) UIButton       *currentBtn;
@property (nonatomic, strong) UIView         *lineView;
@end

@implementation YCMainViewController

- (NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc] init];
    }
    return _btnArr;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = YC_TabBar_SeleteColor;
    }
    return _lineView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildVC];
    [self setUpTitleView];
    [self setUpRightNavItem];
}
#pragma mark - setUpChildVC
- (void)setUpChildVC
{
    _mainScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64-49)];
    _mainScr.delegate = self;
    _mainScr.pagingEnabled = YES;
    _mainScr.showsVerticalScrollIndicator = NO;
    _mainScr.showsHorizontalScrollIndicator = NO;
    _mainScr.contentSize = CGSizeMake(KSCREEN_WIDTH*3, 0);
    [self.view addSubview:_mainScr];
    
    YCRecViewController *reVC = [[YCRecViewController alloc] init];
    [self addChildViewController:reVC];
    reVC.view.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64-49);
    [_mainScr addSubview:reVC.view];
    
    YCNewViewController *newVC = [[YCNewViewController alloc] init];
    [self addChildViewController:newVC];
    newVC.view.frame = CGRectMake(KSCREEN_WIDTH, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64-49);
    [_mainScr addSubview:newVC.view];
    
    YCHotViewController *hotVC = [[YCHotViewController alloc] init];
    [self addChildViewController:hotVC];
    hotVC.view.frame = CGRectMake(KSCREEN_WIDTH*2, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64-49);
    [_mainScr addSubview:hotVC.view];
}
#pragma mark - setUpTitleView
- (void)setUpTitleView
{
    CGFloat width = KSCREEN_WIDTH-160;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10000+i;
        btn.titleLabel.font = YC_Nav_TitleFont;
        btn.frame = CGRectMake(i*(width/3), 0, width/3, 44);
        [btn setTitleColor:YC_Base_TitleColor forState:UIControlStateNormal];
        [btn setTitleColor:YC_TabBar_SeleteColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
                [btn setTitle:@"推荐" forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                btn.selected = YES;
                _currentBtn = btn;
                break;
            case 1:
                [btn setTitle:@"最新" forState:UIControlStateNormal];
                break;
            case 2:
                [btn setTitle:@"热门" forState:UIControlStateNormal];
                break;
        }
        [self.btnArr addObject:btn];
        [titleView addSubview:btn];
        self.lineView.frame = CGRectMake(0, 42, 50, 2);
        self.lineView.centerX = _currentBtn.centerX;
        [titleView addSubview:self.lineView];
    }
    self.navigationItem.titleView = titleView;
}
#pragma mark - setUpRightNav
- (void)setUpRightNavItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 54, 44);
    [btn setImage:[UIImage imageNamed:@"yc_nav_search"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    [btn addTarget:self action:@selector(rightSearchAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
#pragma mark - rightSearchAction
- (void)rightSearchAction
{
    YCSearchViewController *searchVC = [[YCSearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - btnAction
- (void)btnAction:(UIButton *)sender
{
    NSInteger index = sender.tag-10000;
    [_mainScr setContentOffset:CGPointMake(KSCREEN_WIDTH*index, 0) animated:YES];
    [self setUpCurrentBtn:sender];
}
#pragma mark - setUpSeletBtn
- (void)setUpCurrentBtn:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        
        _currentBtn.userInteractionEnabled = YES;
        _currentBtn.selected = !_currentBtn.selected;
        _currentBtn = btn;
        _currentBtn.userInteractionEnabled = NO;
        _currentBtn.selected = !_currentBtn.selected;
        _lineView.centerX = _currentBtn.centerX;
    }];
}
#pragma mark - ScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/KSCREEN_WIDTH;
    UIButton *btn = [self.btnArr objectAtIndex:index];
    [self setUpCurrentBtn:btn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
