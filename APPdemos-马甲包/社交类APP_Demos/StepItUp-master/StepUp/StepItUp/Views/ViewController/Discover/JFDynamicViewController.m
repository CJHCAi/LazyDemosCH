//
//  JFDynamicViewController.m
//  StepUp
//
//  Created by syfll on 15/6/14.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "JFDynamicViewController.h"
#import "UIViewController+ScrollingNavbar.h"

@interface JFDynamicViewController ()<UITableViewDataSource , UITableViewDelegate,UIScrollViewDelegate,AMScrollingNavbarDelegate>
{
    BOOL isDynamicPage;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) NSArray* data;
@property (strong, nonatomic) UITableView *DynamicTableView;
@property (strong, nonatomic) UITableView *ScheduleTabeleView;
@property (weak, nonatomic) IBOutlet UILabel *greenLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageBtnHeight;

@end

@implementation JFDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isDynamicPage = true;
    
    self.data = @[@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc",@"aaaa",@"bbbb",@"cccc"];
    
    _DynamicTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _pageBtnHeight.constant -44)];
    _ScheduleTabeleView = [[UITableView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _pageBtnHeight.constant - 44)];
    
    
    _DynamicTableView.delegate = self;
    _DynamicTableView.dataSource = self;
    _ScheduleTabeleView.dataSource = self;
    _ScheduleTabeleView.delegate = self;
    [self.scrollView addSubview:_DynamicTableView];
    [self.scrollView addSubview:_ScheduleTabeleView];
   
    [self updatePageView];
    [self setUseSuperview:YES];
    //这句代码可以使上方tabbar也隐藏
    //[self setScrollableViewConstraint:self.topConstraint withOffset:49];
    [self setShouldScrollWhenContentFits:NO];
    
    [self setScrollingNavbarDelegate:self];
    
    [self followScrollView:self.DynamicTableView usingTopConstraint:self.topConstraint withDelay:60];
    
    //设置scrollView的内容Frame（设定只允许左右滑动）
    [self.scrollView setContentSize:CGSizeMake(_DynamicTableView.frame.size.width *2, [UIScreen mainScreen].bounds.size.height - _pageBtnHeight.constant - 44)];
}

- (void)updatePageView{
    if (isDynamicPage) {
        [self followScrollView:self.DynamicTableView withDelay:60];
    }else{
        [self followScrollView:self.ScheduleTabeleView withDelay:60];
    }
}


#pragma mark - 标题栏移动

- (void)navigationBarDidChangeToExpanded:(BOOL)expanded {
    if (expanded) {
        NSLog(@"Nav changed to expanded");
    }
}

- (void)navigationBarDidChangeToCollapsed:(BOOL)collapsed {
    if (collapsed) {
        NSLog(@"Nav changed to collapsed");
    }
}

#pragma mark 停止标题上下移动
- (void)stopScroll {
    [self setScrollingEnabled:NO];
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    // This enables the user to scroll down the navbar by tapping the status bar.
    [self showNavbar];
    
    return YES;
}


#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
    }
    
    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

#pragma mark - other
- (void)dealloc {
    [self stopFollowingScrollView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showNavBarAnimated:animated];
}

@end
