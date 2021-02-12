//
//  ViewController.m
//  老淘宝详情
//
//  Created by Kobe24 on 2018/3/5.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import "ViewController.h"
#import "ToolHeader.h"
#import "MyTableView.h"
#import "IgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) IgnoreHeaderTouchAndRecognizeSimultaneousTableView * tableView;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) BOOL isTopCanNotMoveTableView;
@property (nonatomic, assign) BOOL isTopCanNotMoveTableViewPre;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    
}

- (void)initUI{
    
    _tableView = [[IgnoreHeaderTouchAndRecognizeSimultaneousTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame) - KBottomBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 250)];
    headView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = headView;
    
    [self initTopBarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMes:) name:TABLELEAVETOP object:nil];
    
}

- (void)initTopBarView{
    UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), KTopBarHeight)];
    [self.view addSubview:topBarView];
    topBarView.backgroundColor = [UIColor redColor];
}

//titleView
- (void)acceptMes:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    CGFloat height = 0;
    if (section == 0) {
        height = 60;
    }else if (section == 1) {
        height = 160;
    }else if (section == 2){
        height = CGRectGetHeight(self.view.frame) - KTopBarHeight - KBottomBarHeight;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section  = indexPath.section;
    
    if (section==0) {
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];
        [cell.contentView addSubview:textlabel];
        textlabel.text = @"section";
        textlabel.textAlignment = NSTextAlignmentCenter;
    }else if(section==1){
        UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
        [cell.contentView addSubview:textlabel];
        textlabel.text = @"sectionOne";
        textlabel.textAlignment = NSTextAlignmentCenter;
    }else if(section==2){
        NSArray *tabConfigArray = @[@{
                                        @"title":@"第一个",
                                        @"view":@"PicAndTextIntroduceView",
                                        @"data":@"图文介绍的数据",
                                        @"position":@0
                                        },@{
                                        @"title":@"第二个",
                                        @"view":@"ItemDetailView",
                                        @"data":@"商品详情的数据",
                                        @"position":@1
                                        },@{
                                        @"title":@"第三个",
                                        @"view":@"CommentView",
                                        @"data":@"评价的数据",
                                        @"position":@2
                                        }];
        MyTableView *tabView = [[MyTableView alloc] initWithTabConfigArray:tabConfigArray];
        [cell.contentView addSubview:tabView];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tableViewOffsetY = [_tableView rectForSection:2].origin.y - KTopBarHeight;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    _isTopCanNotMoveTableViewPre = _isTopCanNotMoveTableView;
    
    if (contentOffsetY >= tableViewOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tableViewOffsetY);
        _isTopCanNotMoveTableView = YES;
    }else{
        _isTopCanNotMoveTableView = NO;
    }
    
    if (_isTopCanNotMoveTableViewPre != _isTopCanNotMoveTableView) {
        if (_isTopCanNotMoveTableView && !_isTopCanNotMoveTableViewPre) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TABLETOP object:nil userInfo:@{@"canScroll": @"1"}];
            _canScroll = NO;
        }
        
        if (_isTopCanNotMoveTableViewPre && !_isTopCanNotMoveTableView) {//轻
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tableViewOffsetY);
            }
            
        }
        
    }
    
}


@end
