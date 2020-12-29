//
//  HKVideoTagViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKVideoTagViewController.h"
#import "HKVideoTagCell.h"
#import "HKHistoryTagCell.h"
#import "HKSearchTagController.h"
#import "HK_VideoConfogueTool.h"
#import "HK_AllTags.h"
@interface HKVideoTagViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *groups;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *headerTitles;

@property (nonatomic, strong) NSArray *historyTags;


@end

@implementation HKVideoTagViewController

#pragma mark Nav 设置
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //设置不透明导航栏
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

//数据源
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (NSArray *)headerTitles {
    if (!_headerTitles) {
        _headerTitles = @[@"推荐标签",@"推荐圈子"];
    }
    return _headerTitles;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = RGBA(238, 238, 238, 0.5);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView registerNib:[UINib nibWithNibName:@"HKVideoTagCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKVideoTagCell class])];
        [tableView registerNib:[UINib nibWithNibName:@"HKHistoryTagCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKHistoryTagCell class])];
        _tableView = tableView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

#pragma mark 请求
- (void)requestAllTags {
    [HK_VideoConfogueTool getAllTagssuccessBlock:^(HK_AllTags *response) {
        HK_AllTags *allTags = response;
        self.historyTags = allTags.data.his;
        if ([self.historyTags count] > 0) {
            self.headerTitles =  @[@"历史标签",@"推荐标签",@"推荐圈子"];
            [self.groups addObject:self.historyTags];
        }
        [self.groups addObject:allTags.data.circles];
        [self.groups addObject:allTags.data.recommends];
        [self.tableView reloadData];
        
        
    } fial:^(NSString *fials) {
        [EasyShowTextView showText:fials];
    }];
}
-(void)initNav {
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame= CGRectMake(0,0,260,30);
    [btn setImage:[UIImage imageNamed:@"class_search"] forState:UIControlStateNormal];
    [btn setTitle:@"搜索标签,好友或圈子" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    btn.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    btn.titleLabel.font =PingFangSCRegular13;
    btn.layer.cornerRadius =15;
    btn.layer.masksToBounds =YES;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 水平左对齐
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;// 垂直居中对齐
    [btn addTarget:self action:@selector(searchTagClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [AppUtils addBarButton:self title:@"取消" action:@selector(pushSearchVc) position:PositionTypeRight];
}
-(void)searchTagClick {
    
    HKSearchTagController * seag =[[HKSearchTagController alloc] init];
    [self.navigationController pushViewController:seag animated:YES];
}
-(void)pushSearchVc {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self requestAllTags];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.groups.count == 3) {
        if (section == 0) {
            return 1;
        }
    }
    NSArray *array = [self.groups objectAtIndex:section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.groups.count == 3) {
        if (indexPath.section == 0) {
            HKHistoryTagCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKHistoryTagCell class])];
            cell.tagItems = [self.groups objectAtIndex:indexPath.section];
//            @weakify(self);
            cell.block = ^(HK_AllTagsHis *tagHis) { //选择了标签
//                @strongify(self);
                if ([self.delegate respondsToSelector:@selector(tagClickBlock:)]) {
                    [self.delegate tagClickBlock:tagHis];
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            return cell;
        }
    }
    HKVideoTagCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVideoTagCell class])];
    NSObject *value = [[self.groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.itemValue = value;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.groups.count == 3) {
        if (indexPath.section == 0) {
            return;
        }
    }
    NSObject *value = [[self.groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(tagClickBlock:)]) {
        [self.delegate tagClickBlock:value];
    }
     [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.groups.count == 3) {
        if (indexPath.section == 0) {
            return 40;
        }
    }
    return 71;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *text = self.headerTitles[section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [HKComponentFactory labelWithFrame:CGRectMake(16, 21, 300, 14) textColor:RGB(102, 102, 102) textAlignment:NSTextAlignmentLeft font:PingFangSCRegular14 text:text supperView:nil];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
