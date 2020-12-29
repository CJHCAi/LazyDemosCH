//
//  HKMyDeliveryViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyDeliveryViewController.h"
#import "HKMyDeliveryCell.h"
#import "CBSegmentView.h"
#import "HK_MyApplyTool.h"
@interface HKMyDeliveryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) CBSegmentView *segment;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) NSMutableArray *myDeliveryArray;
@property (nonatomic, strong) NSMutableArray *flags;
@property (nonatomic, assign) NSInteger state;
@end

@implementation HKMyDeliveryViewController

- (NSMutableArray *)myDeliveryArray {
    if (!_myDeliveryArray) {
        _myDeliveryArray = [NSMutableArray array];
    }
    return _myDeliveryArray;
}

- (NSMutableArray *)flags {
    if (!_flags) {
        _flags = [NSMutableArray array];
    }
    return _flags;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        //下拉刷新
//        @weakify(self);
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            @strongify(self);
            self.curPage = 1;
            [self requestMyDelivery];
        }];
        //上拉刷新
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            @strongify(self);
            self.curPage++;
            [self requestMyDelivery];
        }];
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"HKMyFansCell" bundle:nil] forCellReuseIdentifier:@"HKMyFansCell"];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(41);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (CBSegmentView *)segment {
    if (!_segment) {
        _segment = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        [_segment setTitleArray:@[@"全部",@"被查看",@"不符合"] titleFont:15 titleColor:UICOLOR_HEX(0x7c7c7c) titleSelectedColor:UICOLOR_HEX(0x0092ff) withStyle:CBSegmentStyleSlider];
        @weakify(self);
        _segment.titleChooseReturn = ^(NSInteger x) {
            @strongify(self);
            if (x == 0) {
                self.state = 0;
            } else if (x == 1) {
                self.state = 2;
            } else if (x == 2) {
                self.state = 3;
            }
            self.curPage = 1;
            [self requestMyDelivery];
        };
    }
    return _segment;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

//我的投递
- (void)requestMyDelivery {
    [HK_MyApplyTool getMyDeliverWithState:self.state andPageNumbers:self.curPage SuccessBlock:^(HKMyDelivery *deliver) {
        HKMyDeliveryData *myDelivery = deliver.data;
        if (self.curPage == 1) {
            [self.myDeliveryArray removeAllObjects];
            [self.flags removeAllObjects];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
            if (self.curPage == myDelivery.totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            if (self.curPage == myDelivery.totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        for (HKMyDeliveryList *list in myDelivery.list) {
            for (int i = 0; i < [list.logs count]; i++) {
                HKMyDeliveryLogs *logs = [list.logs objectAtIndex:i];
                if (i == 0) {
                    logs.lineStyle = 1;
                } else if (i == [list.logs count]-1) {
                    logs.lineStyle = 3;
                } else {
                    logs.lineStyle = 2;
                }
            }
        }
        [self.myDeliveryArray addObjectsFromArray:myDelivery.list];
        for (int i = 0; i < [self.myDeliveryArray count]; i++) {
            [self.flags addObject:[NSNumber numberWithBool:NO]];
        }
            [self.tableView reloadData];
    
    } andFial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    self.title = @"我的投递";
    self.curPage = 1;
    self.state = 0;
    [self.view addSubview:self.segment];
    [self requestMyDelivery];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.myDeliveryArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSNumber *value = [self.flags objectAtIndex:section];
    if (value.boolValue) {
        HKMyDeliveryList *list = [self.myDeliveryArray objectAtIndex:section];
        return [list.logs count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyDeliveryCell"];
    if (!cell) {
        cell = [[HKMyDeliveryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKMyDeliveryCell"];
    }
    HKMyDeliveryList *list = [self.myDeliveryArray objectAtIndex:indexPath.section];
    HKMyDeliveryLogs *data = [list.logs objectAtIndex:indexPath.row];
    cell.data = data;
    return cell;
}

//header点击事件,隐藏cell
- (void)headerViewClick:(UIControl *)bgView {
    NSInteger section = bgView.tag;
    NSNumber *flag = self.flags[section];
    NSNumber *newFlag = [NSNumber numberWithBool:!flag.boolValue];
    [self.flags replaceObjectAtIndex:section withObject:newFlag];
    //刷新列表
    NSIndexSet *index = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIControl *bgView = [[UIControl alloc] init];
    [bgView addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    bgView.tag = section;
    bgView.backgroundColor = [UIColor whiteColor];
    
    HKMyDeliveryList *list = [self.myDeliveryArray objectAtIndex:section];
    //icon
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView sd_setImageWithURL:[NSURL URLWithString:list.headImg]];
    [bgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(15);
        make.top.equalTo(bgView).offset(20);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    iconView.layer.cornerRadius = 24;
    iconView.layer.masksToBounds = YES;
    //职位
    UILabel *titleLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                   textColor:UICOLOR_HEX(0x333333)
                                               textAlignment:NSTextAlignmentLeft
                                                        font:PingFangSCMedium16
                                                        text:list.title
                                                  supperView:bgView];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(14);
        make.top.equalTo(iconView);
        make.height.mas_equalTo(16);
    }];
    //公司名
    UILabel *nameLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                  textColor:UICOLOR_HEX(0x666666)
                                              textAlignment:NSTextAlignmentLeft
                                                       font:PingFangSCRegular14
                                                       text:list.name
                                                 supperView:bgView];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(14);
    }];
    //北京-国贸 | 3-5年 | 本科及以上
    UILabel *infoLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                  textColor:UICOLOR_HEX(0x999999)
                                              textAlignment:NSTextAlignmentLeft
                                                       font:PingFangSCRegular12
                                                       text:[NSString stringWithFormat:@"%@ | %@ | %@",list.areaName,list.experienceName,list.educationName]
                                                 supperView:bgView];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    //2018-07-12 19:03
    UILabel *createDateLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                  textColor:UICOLOR_HEX(0x999999)
                                              textAlignment:NSTextAlignmentLeft
                                                       font:PingFangSCRegular12
                                                       text:list.createDate
                                                 supperView:bgView];
    [createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(infoLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(12);
    }];
    //10k-15k
    UILabel *salaryLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                        textColor:UICOLOR_HEX(0xe15640)
                                                    textAlignment:NSTextAlignmentRight
                                                             font:PingFangSCMedium15
                                                             text:list.salaryName
                                                       supperView:bgView];
    [salaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-15);
        make.top.equalTo(bgView).offset(20);
        make.height.mas_equalTo(15);
    }];
    //state 1投递成功 2被查看 3不符合 4已关闭
    UILabel *stateLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                    textColor:UICOLOR_HEX(0x4090f7)
                                                textAlignment:NSTextAlignmentRight
                                                         font:PingFangSCRegular13
                                                         text:@""
                                                   supperView:bgView];
    if ([list.state integerValue] == 1) {
        stateLabel.text = @"投递成功";
    } else if ([list.state integerValue] == 2) {
        stateLabel.text = @"被查看";
    } else if ([list.state integerValue] == 3) {
        stateLabel.text = @"不符合";
    } else if ([list.state integerValue] == 4) {
        stateLabel.text = @"已关闭";
    }
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-15);
        make.bottom.equalTo(bgView).offset(-20);
        make.height.mas_equalTo(13);
    }];
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 121;
}

//footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
