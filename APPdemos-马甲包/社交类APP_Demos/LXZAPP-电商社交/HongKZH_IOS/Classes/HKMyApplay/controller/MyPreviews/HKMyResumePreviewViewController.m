//
//  HKMyResumePreviewViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyResumePreviewViewController.h"
#import "HKMyResumePreviewHeadCell.h"
#import "HKMyResumePreviewBasicInfoCell.h"
#import "HKMyResumePreviewCareerIntentionCell.h"
#import "HKMyResumePreviewEducationCell.h"
#import "HKMyResumePreviewExperienceCell.h"
#import "HKMyResumePreviewContentCell.h"
#import "HKImageAnnexViewController.h"
#import "HK_MyApplyTool.h"
#import "HK_RecruitTool.h"
@interface HKMyResumePreviewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) HKMyResumePreviewData *myResumePreviewData;
@property (nonatomic, weak) UIButton *collectionButton;
@property (nonatomic, weak) UIButton *matchButton;

@property (nonatomic, assign) BOOL collectionState;
@property (nonatomic, assign) BOOL recruitState;
@end

@implementation HKMyResumePreviewViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        //自动估算行高
        tableView.estimatedRowHeight = 100.f;
        tableView.rowHeight = UITableViewAutomaticDimension;
        [tableView registerNib:[UINib nibWithNibName:@"HKMyResumePreviewHeadCell" bundle:nil] forCellReuseIdentifier:@"HKMyResumePreviewHeadCell"];
        [tableView registerClass:[HKMyResumePreviewBasicInfoCell class] forCellReuseIdentifier:@"HKMyResumePreviewBasicInfoCell"];
        [tableView registerClass:[HKMyResumePreviewCareerIntentionCell class] forCellReuseIdentifier:@"HKMyResumePreviewCareerIntentionCell"];
        [tableView registerClass:[HKMyResumePreviewEducationCell class] forCellReuseIdentifier:@"HKMyResumePreviewEducationCell"];
        [self.view addSubview:tableView];
        [tableView registerClass:[HKMyResumePreviewExperienceCell class] forCellReuseIdentifier:@"HKMyResumePreviewExperienceCell"];
        [tableView registerClass:[HKMyResumePreviewContentCell class] forCellReuseIdentifier:@"HKMyResumePreviewContentCell"];
        _tableView = tableView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.source == 1) {
                make.edges.equalTo(self.view);
            } else if(self.source == 2 || self.source == 3){
                make.top.left.right.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-50);
            }
        }];
    }
    return _tableView;
}

//网络请求
- (void)requestMyResumePreview {
    [HK_MyApplyTool getMyResumePreview:self.resumeId withrecruitId:self.recruitId andsource:self.source SuccessBlock:^(HKMyResumePreview *comRes) {
        self.myResumePreviewData =comRes.data;
        if (self.source == 2 || self.source == 3) {
            if ([self.myResumePreviewData.collectionState integerValue] == 1) {//收藏
                self.collectionState = YES;
            }
            if (self.source == 3) {
                if ([self.myResumePreviewData.recruitState integerValue] == 3) { //是否不符
                    self.recruitState = YES;
                }
            }
            [self setButtonStyle];
        }
        NSInteger eduCount = [self.myResumePreviewData.educationals count];
        for (int i = 0; i < eduCount; i++) {
            HKMyResumePreviewEducationals *education = [self.myResumePreviewData.educationals objectAtIndex:i];
            if (i == 0) {
                education.lineStyle = 1;
            } else if (i == eduCount-1) {
                education.lineStyle = 3;
            } else {
                education.lineStyle = 2;
            }
        }
        NSInteger expCount = [self.myResumePreviewData.experiences count];
        for (int i = 0; i < expCount; i++) {
            HKMyResumePreviewExperiences *experience = [self.myResumePreviewData.experiences objectAtIndex:i];
            if (i == 0) {
                experience.lineStyle = 1;
            } else if (i == expCount-1) {
                experience.lineStyle = 3;
            } else {
                experience.lineStyle = 2;
            }
        }
        [self.tableView reloadData];
    } andFial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
 
}
//收藏
- (void)requestResumeCollection {
    [HK_RecruitTool getCollectionCanidateWithResumeId:self.resumeId andCollectionState:self.collectionState SuccessBlock:^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        self.collectionState = !self.collectionState;
        [self setButtonStyle];
    } fail:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}
//简历不符
- (void)requestNotGoodResume {
    [HK_RecruitTool getResumeStatesWithResumeId:self.resumeId andRecuitId:self.recruitId SuccessBlock:^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        self.recruitState = !self.recruitState;
        [self setButtonStyle];
        
    } fail:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}
- (void)setNavItem {
    UIImage *originalImg = [[UIImage imageNamed:@"selfMediaClass_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:originalImg style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
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
   // [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"简历预览";
    [self setNavItem];
    [self requestMyResumePreview];
    if(self.source == 2 || self.source == 3){
        [self setUpUI];
    }
}

- (void)setUpUI {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR_RGB_Alpha(0x666666, 0.3);
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bottomView);
        make.height.mas_equalTo(1);
    }];
    
    
    UIButton *collectionButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                              frame:CGRectZero taget:self
                                                             action:@selector(collectionButtonClick:)
                                                         supperView:bottomView];
     [collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
     collectionButton.titleLabel.font = PingFangSCRegular15;
    self.collectionButton = collectionButton;
    
    if (self.source == 3) {
        UIButton *matchButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                             frame:CGRectZero
                                                             taget:self
                                                            action:@selector(matchButtonClick:)
                                                        supperView:bottomView];
        [matchButton setTitle:@"不符" forState:UIControlStateNormal];
        matchButton.titleLabel.font = PingFangSCRegular15;
        self.matchButton = matchButton;
        
        UIView *line = [UIView new];
        line.backgroundColor = UICOLOR_RGB_Alpha(0x666666, 0.3);
        [bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(bottomView);
            make.width.mas_equalTo(1);
            make.left.equalTo(self.collectionButton.mas_right);
        }];
    }
    UIButton *chatButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                        frame:CGRectZero
                                                        taget:self
                                                       action:@selector(chatButtonClick:)
                                                   supperView:bottomView];
    chatButton.backgroundColor = UICOLOR_HEX(0x2693e5);
    [chatButton setTitle:@"在线聊天" forState:UIControlStateNormal];
    chatButton.titleLabel.font = PingFangSCRegular15;
    
    //根据状态更改button样式
    [self setButtonStyle];
    //布局
    if (self.source == 2) {
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(bottomView);
            make.top.equalTo(bottomView).offset(1);
            make.width.equalTo(bottomView).multipliedBy(0.25);
        }];
        [chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomView).offset(1);
            make.right.bottom.equalTo(bottomView);
            make.width.equalTo(bottomView).multipliedBy(0.75);
        }];
    }
    
    if (self.source == 3) {
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(bottomView);
            make.top.equalTo(bottomView).offset(1);
            make.width.equalTo(bottomView).multipliedBy(0.25);
        }];
        [self.matchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.collectionButton.mas_right);
            make.bottom.equalTo(bottomView);
            make.top.equalTo(bottomView).offset(1);
            make.width.equalTo(bottomView).multipliedBy(0.25);
        }];
        [chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(bottomView);
            make.top.equalTo(bottomView).offset(1);
            make.width.equalTo(bottomView).multipliedBy(0.5);
        }];
    }
}

- (void)setButtonStyle {
    //样式
    if (self.collectionState) {
        [self.collectionButton setTitleColor:UICOLOR_HEX(0x4090f7) forState:UIControlStateNormal];
        [self.collectionButton setImage:[UIImage imageNamed:@"yshc_5742"] forState:UIControlStateNormal];
    } else {
        [self.collectionButton setTitleColor:UICOLOR_HEX(0x666666) forState:UIControlStateNormal];
        [self.collectionButton setImage:[UIImage imageNamed:@"wshc_5741"] forState:UIControlStateNormal];
    }
    if (self.source == 3) {
        if (self.recruitState) {
            [self.matchButton setTitleColor:UICOLOR_HEX(0x4090f7) forState:UIControlStateNormal];
            [self.matchButton setImage:[UIImage imageNamed:@"bf2_5742"] forState:UIControlStateNormal];
        } else {
            [self.matchButton setTitleColor:UICOLOR_HEX(0x666666) forState:UIControlStateNormal];
            [self.matchButton setImage:[UIImage imageNamed:@"bf_5742"] forState:UIControlStateNormal];
        }
    }
}

//收藏
- (void)collectionButtonClick:(UIButton *)button {
    DLog(@"收藏");
    [self requestResumeCollection];
}

//不符合
- (void)matchButtonClick:(UIButton *)button {
    DLog(@"不符合");
    [self requestNotGoodResume];
}

//聊天
- (void)chatButtonClick:(UIButton *)button {
    DLog(@"聊天");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return [self.myResumePreviewData.educationals count];
    } else if (section == 4) {
        return [self.myResumePreviewData.experiences count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            HKMyResumePreviewHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyResumePreviewHeadCell"];
            cell.myResumePreviewData = self.myResumePreviewData;
//            @weakify(self);
            cell.watchVideoBlock = ^{
                DLog(@"查看视频");
            };
            cell.watchAnnexBlcok = ^{
//                @strongify(self);
                if (!self.myResumePreviewData.imgs.count) {
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showInfoWithStatus:@"没有附件"];
                    return ;
                }
                HKImageAnnexViewController *vc = [[HKImageAnnexViewController alloc] init];
                vc.imgs = self.myResumePreviewData.imgs;
                [self.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
            break;
        case 1:
        {
            HKMyResumePreviewCareerIntentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyResumePreviewCareerIntentionCell"];
            cell.myResumePreviewData = self.myResumePreviewData;
            return cell;
        }
            break;
        case 2:
        {
            HKMyResumePreviewBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyResumePreviewBasicInfoCell"];
            cell.myResumePreviewData = self.myResumePreviewData;
            return cell;
        }
            break;
        case 3:
        {
            HKMyResumePreviewEducationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyResumePreviewEducationCell"];
            cell.data = [self.myResumePreviewData.educationals objectAtIndex:indexPath.row];
            return cell;
        }
            break;
        case 4:
        {
            HKMyResumePreviewExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyResumePreviewExperienceCell"];
            cell.data = [self.myResumePreviewData.experiences objectAtIndex:indexPath.row];
            return cell;
        }
            break;
        case 5:
        {
            HKMyResumePreviewContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyResumePreviewContentCell"];
            cell.userContent = self.myResumePreviewData.content;
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 259;
            break;
        case 1:
            return 129;
            break;
        case 2:
            return 230;
            break;
        case 3:
            return 73;
            break;
        case 4:
            return 120;
            break;
        case 5:
            return UITableViewAutomaticDimension;
            break;
            
        default:
            return 0;
            break;
    }
}
//header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 36;
}

- (UIView *)sectionHeaderViewWithTitle:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                   textColor:UICOLOR_HEX(0x4090f7)
                                               textAlignment:NSTextAlignmentLeft
                                                        font:PingFangSCMedium15
                                                        text:title
                                                  supperView:view];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.top.equalTo(view).offset(21);
        make.height.mas_equalTo(15);
    }];
    
    return view;
}

//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    NSString *title;
    switch (section) {
        case 1:
        {
            title = @"职业意向";
        }
            break;
        case 2:
        {
            title = @"基本信息";
        }
            break;
        case 3:
        {
            title = @"教育经历";
        }
            break;
        case 4:
        {
            title = @"工作经历";
        }
            break;
        case 5:
        {
            title = @"自我描述";
        }
            break;
            
        default:
            return nil;
            break;
    }
    return [self sectionHeaderViewWithTitle:title];
}

//footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UICOLOR_HEX(0xe2e2e2);
    return view;
}

//footer 高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else {
        return 1;
    }
}


@end
