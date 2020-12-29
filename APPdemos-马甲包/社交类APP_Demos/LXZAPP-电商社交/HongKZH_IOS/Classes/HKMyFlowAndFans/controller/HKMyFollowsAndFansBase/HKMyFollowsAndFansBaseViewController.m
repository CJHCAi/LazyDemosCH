//
//  HKMyFollowsAndFansBaseViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyFollowsAndFansBaseViewController.h"
#import "HK_FollowFansResponse.h"
@interface HKMyFollowsAndFansBaseViewController ()

@end

@implementation HKMyFollowsAndFansBaseViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = RGB(241, 241, 241);
        tableView.delegate = self;
        tableView.dataSource = self;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.showsVerticalScrollIndicator =NO;
        //下拉刷新
//        @weakify(self);
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            @strongify(self);
            self.curPage = 1;
            [self requestMyFollowsAndFans];
        }];
        //上拉刷新
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            @strongify(self);
            self.curPage++;
            [self requestMyFollowsAndFans];
        }];
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"HKMyFansCell" bundle:nil] forCellReuseIdentifier:@"HKMyFansCell"];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)myFollowAndFansArray {
    if (!_myFollowAndFansArray) {
        _myFollowAndFansArray = [NSMutableArray array];
    }
    return _myFollowAndFansArray;
}

#pragma mark 请求
//数据列表
- (void)requestMyFollowsAndFans {
    
    [HK_FollowFansResponse  getFansFollowListWith:self.type CurentPage:self.curPage successBlock:^(id object) {
        switch (self.type) {
            case FollowsFan_Fans:
            case FollowsFans_MyFollow:
            {
                 HKMyFollowAndFans *response =[HKMyFollowAndFans mj_objectWithKeyValues:object];
                HKMyFollowAndFansData *myFollowAndFansData =response.data;
                if (self.curPage == 1) {
                    [self.myFollowAndFansArray removeAllObjects];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer resetNoMoreData];
                    if (self.curPage == myFollowAndFansData.totalPage) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                } else {
                    if (self.curPage == myFollowAndFansData.totalPage) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [self.tableView.mj_footer endRefreshing];
                        [self.tableView.mj_footer resetNoMoreData];
                    }
                }
                [self.myFollowAndFansArray addObjectsFromArray:myFollowAndFansData.list];
                //设置关注状态
                if(self.type == FollowsFans_MyFollow){
                    for (HKMyFollowAndFansList *list in self.myFollowAndFansArray) {
                        list.attention = YES;
                    }
            }
         }
                break;

           case  FollowsFans_EnterPriseFollow:
            {
                HKMyFollowsEnterprise *response =[HKMyFollowsEnterprise mj_objectWithKeyValues:object];
                HKMyFollowsEnterpriseData *myFollowsEnterpriseData =response.data;
                
                if (self.curPage == 1) {
                    [self.myFollowAndFansArray removeAllObjects];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer resetNoMoreData];
                    if (self.curPage == myFollowsEnterpriseData.totalPage) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                } else {
                    if (self.curPage == myFollowsEnterpriseData.totalPage) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [self.tableView.mj_footer endRefreshing];
                        [self.tableView.mj_footer resetNoMoreData];
                    }
                }
                [self.myFollowAndFansArray addObjectsFromArray:myFollowsEnterpriseData.list];
                for (HKMyFollowsEnterpriseList *list in self.myFollowAndFansArray) {
                    list.attention = YES;
                }
            }
                break;
            default:
                break;
        }
           [self.tableView reloadData];
 
    } failed:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
    
}
//关注
- (void)requestFollowAdd {
    NSString *followUserId = @"";
    if ([self.selectedCellValue isKindOfClass:[HKMyFollowAndFansList class]]) {
        HKMyFollowAndFansList *value = (HKMyFollowAndFansList *)self.selectedCellValue;
        followUserId = value.uid;
    } else if ([self.selectedCellValue isKindOfClass:[HKMyFollowsEnterpriseList class]]) {
        HKMyFollowsEnterpriseList *value = (HKMyFollowsEnterpriseList *)self.selectedCellValue;
        followUserId = value.enterpriseId;
    }
    if (self.type ==FollowsFan_Fans) {
      //我的粉丝关注掉增加好友接口...
        [HK_FollowFansResponse addFriendWithUid:followUserId successBlock:^(id object) {
            [EasyShowTextView showText:@"关注成功"];
            [self.myFollowAndFansArray removeObjectAtIndex:self.selectedIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
            
        } failed:^(NSString *error) {
            [EasyShowTextView showText:error];
            
        }];
    }else {
        [HK_FollowFansResponse followSomeOneByIdString:followUserId andType:self.type successBlock:^(id object) {
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            //成功
            [SVProgressHUD showInfoWithStatus:@"关注成功"];
            if ([self.selectedCellValue isKindOfClass:[HKMyFollowAndFansList class]]) {
                HKMyFollowAndFansList *value = (HKMyFollowAndFansList *)self.selectedCellValue;
                value.attention = YES;
            } else if ([self.selectedCellValue isKindOfClass:[HKMyFollowsEnterpriseList class]]) {
                HKMyFollowsEnterpriseList *value = (HKMyFollowsEnterpriseList *)self.selectedCellValue;
                value.attention = YES;
            }
            //刷新数据
            [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } failed:^(NSString *error) {
            
            [EasyShowTextView showText:error];
        }];
    }
}

#pragma mark 取消关注
- (void)requestFollowDelete {
    NSString *followUserId = @"";
    if ([self.selectedCellValue isKindOfClass:[HKMyFollowAndFansList class]]) {
        HKMyFollowAndFansList *value = (HKMyFollowAndFansList *)self.selectedCellValue;
        followUserId = value.uid;
 
    } else if ([self.selectedCellValue isKindOfClass:[HKMyFollowsEnterpriseList class]]) {
        HKMyFollowsEnterpriseList *value = (HKMyFollowsEnterpriseList *)self.selectedCellValue;
        followUserId = value.enterpriseId;
    }
    [HK_FollowFansResponse CanCelSomeOneByIdString:followUserId andType:self.type successBlock:^(id object) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        //成功
        [SVProgressHUD showInfoWithStatus:@"取消关注"];
        if ([self.selectedCellValue isKindOfClass:[HKMyFollowAndFansList class]]) {
            HKMyFollowAndFansList *value = (HKMyFollowAndFansList *)self.selectedCellValue;
            value.attention = NO;
            [self.myFollowAndFansArray removeObject:value];
            //刷新数据
            [self.tableView reloadData];
        } else if ([self.selectedCellValue isKindOfClass:[HKMyFollowsEnterpriseList class]]) {
            HKMyFollowsEnterpriseList *value = (HKMyFollowsEnterpriseList *)self.selectedCellValue;
            value.attention = NO;
            [self.myFollowAndFansArray removeObject:value];
            //刷新数据
            [self.tableView reloadData];
        }
    } failed:^(NSString *error) {
        
        [EasyShowTextView showText:error];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.curPage = 1;
    [self requestMyFollowsAndFans];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.myFollowAndFansArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKMyFansCell"];
    HKMyFollowAndFansList *list = [self.myFollowAndFansArray objectAtIndex:indexPath.row];
    cell.cellValue = list;
//    @weakify(self);
    cell.attentionButtonClickBlock = ^(id cellValue, UITableViewCell *cell) {
//        @strongify(self);
        self.selectedCellValue = cellValue;
        self.selectedIndexPath = [tableView indexPathForCell:cell];
        if ([self.selectedCellValue isKindOfClass:[HKMyFollowAndFansList class]]) {
            HKMyFollowAndFansList *value = (HKMyFollowAndFansList *)self.selectedCellValue;
            if (value.isAttention) {
                
                [self requestFollowDelete];
            } else {
                [self requestFollowAdd];
            }
        } else if ([self.selectedCellValue isKindOfClass:[HKMyFollowsEnterpriseList class]]) {
            HKMyFollowsEnterpriseList *value = (HKMyFollowsEnterpriseList *)self.selectedCellValue;
            if (value.isAttention) {
                [self requestFollowDelete];
            } else {
                [self requestFollowAdd];
            }
        }
    };
    return cell;
}
#pragma mark UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type ==FollowsFans_MyFollow || self.type ==FollowsFan_Fans) {
       HKMyFollowAndFansList *list = [self.myFollowAndFansArray objectAtIndex:indexPath.row];
        [AppUtils pushUserDetailInfoVcWithModel:list andCurrentVc:self];
    }
}
@end
