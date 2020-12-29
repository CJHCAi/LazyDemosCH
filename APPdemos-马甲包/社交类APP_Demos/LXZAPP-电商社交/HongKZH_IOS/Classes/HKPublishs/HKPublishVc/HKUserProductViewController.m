//
//  HKUserProductViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUserProductViewController.h"
#import "HKUserProductCell.h"
#import "HKProductsModel.h"
#import "HKPublishViewModel.h"
@interface HKUserProductViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray<HKUserProduct *> *produtList;

@end

@implementation HKUserProductViewController

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
        [_tableView registerNib:[UINib nibWithNibName:@"HKUserProductCell" bundle:nil] forCellReuseIdentifier:@"HKUserProductCell"];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

#pragma mark 请求

- (void)requestUserProductList {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:HKUSERLOGINID forKey:@"loginUid"];
    [HKPublishViewModel getProductList:dic success:^(HK_UserProductList *responde) {
        self.produtList = responde.data;for (HKUserProduct *product in self.produtList) {
                 product.isShow = NO;
                   for (HKUserProduct *selectProduct in self.selectItems) {
                            if ([product.productId isEqualToString:selectProduct.productId]) {
                                product.isShow = YES;
                                break;
                            }
                        }
                    }
                    [self.tableView reloadData];
    }];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的商品";
    self.showCustomerLeftItem =YES;
    [self requestUserProductList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.produtList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKUserProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKUserProductCell"];
    cell.userProduct = [self.produtList objectAtIndex:indexPath.row];
//    @weakify(self);
    cell.block = ^(HKUserProduct *product, BOOL isShow) {
//        @strongify(self);
        if (self.isCicle) {
            
            if (self.delegete && [self.delegete respondsToSelector:@selector(selectProduct:)]) {
                [self.delegete selectProduct:product];
                [self.navigationController popViewControllerAnimated:YES];
                return ;
            }
        }
        if (isShow) {
    
            if (self.boothCount > [self.selectItems count]) {
                [self.selectItems addObject:product];
                if (self.block) {
                    self.block();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                
                [SVProgressHUD showInfoWithStatus:@"请购买展位"];
            }
        } else {
//            if (self.delegete && [self.delegete respondsToSelector:@selector(selectProduct:withCancleOrNot:)]) {
//                [self.delegete selectProduct:product withCancleOrNot:NO];
//                [self.navigationController popViewControllerAnimated:YES];
//                return ;
//            }

            for (HKUserProduct *pro in self.selectItems) {
                if ([pro.productId isEqualToString:product.productId]) {
                    [self.selectItems removeObject:pro];
                    break;
                }
            }
            if (self.block) {
                self.block();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    return cell;
}



#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 168;
}

////header 高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.01;
//}
//
////header
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}
//
////footer
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = RGB(241, 241, 241);
//    return view;
//}
//
////footer 高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01.f;
//}

//cell 选中处理
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}


@end
