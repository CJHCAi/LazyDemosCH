//
//  NFMenuViewController.m
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/19.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import "NFMenuViewController.h"
#import "YCCollectViewController.h"
#import "NFMenuTableViewCell.h"
#import "NFMenuHeaderView.h"
#import "NFDisclaimerVC.h"

typedef NS_ENUM(NSInteger, NFMenuType)
{
    kNFMenuType_Declaration,
    kNFMenuType_Clear,
    kNFMenuType_Judge,
    kNFMenuType_Love
};
@interface NFMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
static NSString *const kNFMenuCellIdentifier = @"myCellIdentifier";
@implementation NFMenuViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
        _myTableView.rowHeight = 55;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = YC_Base_BgGrayColor;
        _myTableView.separatorColor = YC_Base_LineColor;
        [_myTableView registerClass:[NFMenuTableViewCell class] forCellReuseIdentifier:kNFMenuCellIdentifier];
        _myTableView.tableHeaderView = [[NFMenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 180)];
        _myTableView.tableFooterView = [[UIView alloc] init];
    }
    return _myTableView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTableView];
    [self initItemMenu];
}
- (void)initItemMenu
{
    NSMutableArray *section = [[NSMutableArray alloc] init];
    NSNumber *number = [NSNumber numberWithInteger:kNFMenuType_Love];
    [section addObject:number];
    number = [NSNumber numberWithInteger:kNFMenuType_Judge];
    [section addObject:number];
    number = [NSNumber numberWithInteger:kNFMenuType_Declaration];
    [section addObject:number];
    [self.dataSource addObject:section];
    
    section = [[NSMutableArray alloc] init];
    number = [NSNumber numberWithInteger:kNFMenuType_Clear];
    [section addObject:number];
    [self.dataSource addObject:section];
}
#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNFMenuCellIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFMenuTableViewCell *myCell = (NFMenuTableViewCell *)cell;
    myCell.titleLabel.textColor = YC_Base_TitleColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    myCell.cacheLabel.hidden = YES;
    NSArray *items = self.dataSource[indexPath.section];
    NSInteger item = [items[indexPath.row] integerValue];
    switch (item) {
        case kNFMenuType_Clear: {
            myCell.accessoryType = UITableViewCellAccessoryNone;
            myCell.iconView.image = [UIImage imageNamed:@"nf_menu_clear"];
            myCell.titleLabel.text = @"清除缓存";
            myCell.titleLabel.textColor = RGB(255, 47, 57);
            myCell.cacheLabel.hidden = NO;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString *str = [NSString stringWithFormat:@"%.02fM",[[SDImageCache sharedImageCache] getSize]/1024.f/1024];
                dispatch_async(dispatch_get_main_queue(), ^{
                    myCell.cacheLabel.text = str;
                });
            });
        }
            break;
        case kNFMenuType_Judge:
            myCell.iconView.image = [UIImage imageNamed:@"nf_menu_support"];
            myCell.titleLabel.text = @"给我们支持";
            break;
        case kNFMenuType_Declaration:
            myCell.iconView.image = [UIImage imageNamed:@"nf_menu_declare"];
            myCell.titleLabel.text = @"免责声明";
            break;
        case kNFMenuType_Love:
            myCell.iconView.image = [UIImage imageNamed:@"nf_menu_collect"];
            myCell.titleLabel.text = @"我的收藏";
            break;
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *items = self.dataSource[indexPath.section];
    NSInteger item = [items[indexPath.row] integerValue];
    switch (item) {
        case kNFMenuType_Clear:
            [self clearCachesAtIndexPath:indexPath];
            break;
        case kNFMenuType_Judge:
            [self doJudge];
            break;
        case kNFMenuType_Declaration:
            [self showDeclaration];
            break;
        case kNFMenuType_Love:
            [self gotoCollectVC];
        default:
            break;
    }
}
#pragma mark - private action
// 免责声明
- (void)showDeclaration
{
    NFDisclaimerVC *disVC = [[NFDisclaimerVC alloc] init];
    disVC.navTitle = @"免责声明";
    disVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:disVC animated:YES];
}
// 清楚缓存
- (void)clearCachesAtIndexPath:(NSIndexPath *)indexpath
{
    [[SDImageCache sharedImageCache] clearDisk];
    NFMenuTableViewCell *myCell = [self.myTableView cellForRowAtIndexPath:indexpath];
    myCell.cacheLabel.text = @"0.00M";
    [YCHudManager showMessage:@"清除成功" InView:self.view];
}
// 给好评
- (void)doJudge
{
    NSURL *commentUrl = [NSURL URLWithString:kAppUrl];
    [[UIApplication sharedApplication] openURL:commentUrl];
    NSString *version = [YCToolManager currentVerson];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kYCVersionCommentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// 我的收藏
- (void)gotoCollectVC
{
    YCCollectViewController *collectVC = [[YCCollectViewController alloc] init];
    collectVC.navTitle = @"我的收藏";
    collectVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectVC animated:YES];
}
@end
