//
//  HKShieldCompanyViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShieldCompanyViewController.h"
#import "HKAddShieldCompanyViewController.h"
#import "HKBlueBgView.h"
#import "HK_MyApplyTool.h"
@interface HKShieldCompanyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *companys;

@end

@implementation HKShieldCompanyViewController

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
    
    [self requestShieldCompany];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//左侧取消按钮
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = UICOLOR_HEX(0xf5f5f5);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)companys {
    if (!_companys) {
        _companys = [NSMutableArray array];
    }
    return _companys;
}
//网络请求
- (void)requestShieldCompany {
    [HK_MyApplyTool getUserShildCompanySuccessBlock:^(HKShieldCompany *comRes) {
       
        [self.companys removeAllObjects];
        [self.companys addObjectsFromArray:comRes.data];
        [self.tableView reloadData];
        
    } andFial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}
#pragma mark 删除屏蔽公司
- (void)requestDeleteShieldCompany:(NSString *)companyId {
    [HK_MyApplyTool deleteUserShildCompany:companyId SuccessBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        });
        //删除图片成功
        [self requestShieldCompany];
        
    } andFial:^(NSString *msg) {
          [EasyShowTextView showText:msg];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"屏蔽公司";
    [self setNavItem];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [self.companys count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"section0Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section0Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *tip = [HKComponentFactory labelWithFrame:CGRectZero
                                                    textColor:UICOLOR_HEX(0x4090f7)
                                                textAlignment:NSTextAlignmentCenter
                                                         font:PingFangSCRegular15
                                                         text:@"＋ 添加屏蔽公司" supperView:cell.contentView];
            [tip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(cell.contentView);
            }];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"section1Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section1Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *tip = [HKComponentFactory labelWithFrame:CGRectZero
                                                    textColor:UICOLOR_HEX(0x333333)
                                                textAlignment:NSTextAlignmentCenter
                                                         font:PingFangSCRegular15
                                                         text:@"" supperView:cell.contentView];
            tip.tag = indexPath.row+100;
            [tip mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(15);
            }];
        }
        HKShieldCompanyData *data = [self.companys objectAtIndex:indexPath.row];
        UILabel *label = [cell viewWithTag:indexPath.row+100];
        label.text = data.corporateName;
        return cell;
    }
}

#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        v.backgroundColor = UICOLOR_HEX(0xf5f5f5);
        return v;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKAddShieldCompanyViewController *vc = [[HKAddShieldCompanyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//左滑删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HKShieldCompanyData *data = [self.companys objectAtIndex:indexPath.row];
        [self requestDeleteShieldCompany:data.companyId];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
