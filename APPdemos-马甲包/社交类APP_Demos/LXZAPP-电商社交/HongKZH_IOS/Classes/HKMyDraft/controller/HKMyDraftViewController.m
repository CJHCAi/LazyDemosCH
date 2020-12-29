//
//  HKMyDraftViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyDraftViewController.h"
#import "HKReleaseVideoSaveDraft.h"
#import "HKMyDraftCell.h"
#import "HKReleaseVideoSaveDraftDao.h"
#import "HKEnterpriseRecruitViewController.h"
#import "HKReleaseResumeViewController.h"
#import "HKPublishCommonModuleViewController.h"
#import "HKReleaseMarryViewController.h"
#import "HKReleasePhotographyViewController.h"
#import "HKReleaseResumeViewController.h"

@interface HKMyDraftViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray<HKReleaseVideoSaveDraft *> *draftList;

@property (nonatomic, strong) HKReleaseVideoSaveDraftDao *draftDao;

@end

@implementation HKMyDraftViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableView];
        _tableView = tableView;
        [_tableView registerNib:[UINib nibWithNibName:@"HKMyDraftCell" bundle:nil] forCellReuseIdentifier:@"HKMyDraftCell"];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (NSArray<HKReleaseVideoSaveDraft *> *)draftList {
    if (!_draftList) {
        _draftList = [NSMutableArray array];
    }
    return _draftList;
}

- (HKReleaseVideoSaveDraftDao *)draftDao {
    if (!_draftDao) {
        _draftDao = [HKReleaseVideoSaveDraftDao saveDraftDao];
    }
    return _draftDao;
}

- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AppUtils setPopHidenNavBarForFirstPageVc:self];
    
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

//从数据库读取数据
- (void)loadData {
    self.draftList = [self.draftDao searchAll];
    
    
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的草稿";
    [self setNavItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.draftList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyDraftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyDraftCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.draft = [self.draftList objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}
//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKReleaseVideoSaveDraft *draft = [self.draftList objectAtIndex:indexPath.row];
    switch (draft.publishType) {
        case ENUM_PublishTypePublic:    //发布公共模块
        {
            HKPublishCommonModuleViewController *vc = [[HKPublishCommonModuleViewController alloc] init];
            vc.source = 1;
            vc.saveDraft = draft;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case ENUM_PublishTypeRecruit:   //发布企业招聘
        {
            //认证成功跳转到发布页面
            HKEnterpriseRecruitViewController *vc1 = [[HKEnterpriseRecruitViewController alloc] init];
            vc1.enterpriseId = draft.userEnterpriseId;
            vc1.source = 1;
            vc1.saveDraft = draft;
            [self.navigationController pushViewController:vc1 animated:YES];
        }
            break;
        case ENUM_PublishTypeResume:    //发布个人简历
        {
            HKReleaseResumeViewController *vc = [[HKReleaseResumeViewController alloc] init];
            vc.source = 1;
            vc.saveDraft = draft;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case ENUM_PublishTypePhotography:   //发布摄影
        {
            HKReleasePhotographyViewController *vc = [[HKReleasePhotographyViewController alloc] init];
            vc.source = 1;
            vc.saveDraft = draft;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case ENUM_PublishTypeMarry: //发布征婚交友
        {
            HKReleaseMarryViewController *vc = [[HKReleaseMarryViewController alloc] init];
            vc.source = 1;
            vc.saveDraft = draft;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//左滑删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HKReleaseVideoSaveDraft *draft = [self.draftList objectAtIndex:indexPath.row];
        [self.draftDao delDraft:draft];
        [self loadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
