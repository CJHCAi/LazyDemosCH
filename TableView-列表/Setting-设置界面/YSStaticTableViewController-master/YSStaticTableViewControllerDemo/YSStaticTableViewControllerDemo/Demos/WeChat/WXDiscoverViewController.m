//
//  WXDiscoverViewController.m
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/19.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "WXDiscoverViewController.h"
#import "WXUserCenterViewController.h"

@interface WXDiscoverViewController ()

@end

@implementation WXDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    
    [self configureNav];
    [self prepareData];
    
    [self networkRequest];
}

- (void)networkRequest {
    //模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //请求成功
        NSDictionary *responseDict = @{@"title_info":@"新游戏上架啦",
                                       @"title_icon":@"game_1",
                                       @"game_info":@"一起来玩斗地主呀！",
                                       @"game_icon":@"doudizhu"
                                       };
        //将要刷新cell的indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:3];
        
        //获取cell对应的viewModel
        YSStaticDefaultModel *cellModel = [self cellModelAtIndexPath:indexPath];
        
        if (cellModel) {
            //更新viewModel
            cellModel.title = responseDict[@"title_info"];
            cellModel.titleImageName = responseDict[@"title_icon"];
            cellModel.indicatorImageName = responseDict[@"game_icon"];
            cellModel.indicatorTitle = responseDict[@"game_info"];
            
            //刷新tableview
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadData];
        }
    });
}

- (void)prepareData {
    __weak typeof(self) weakSelf = self;
    YSStaticDefaultModel *model0 = [[YSStaticDefaultModel alloc] init];
    model0.title = @"朋友圈";
    model0.titleImageName = @"ff_IconShowAlbum";
    model0.indicatorImageName = @"avatar";
    
    YSStaticSectionModel *sm0 = [YSStaticSectionModel sectionWithItemArray:@[model0]];
    
    YSStaticDefaultModel *model1 = [[YSStaticDefaultModel alloc] init];
    model1.title = @"扫一扫";
    model1.titleImageName = @"ff_IconQRCode";
    
    YSStaticDefaultModel *model2 = [[YSStaticDefaultModel alloc] init];
    model2.title = @"摇一摇";
    model2.titleImageName = @"ff_IconShake";
    
    YSStaticSectionModel *sm1 = [YSStaticSectionModel sectionWithItemArray:@[model1, model2]];
    
    YSStaticDefaultModel *model3 = [[YSStaticDefaultModel alloc] init];
    model3.title = @"附近的人";
    model3.titleImageName = @"ff_IconLocationService";
    
    YSStaticDefaultModel *model4 = [[YSStaticDefaultModel alloc] init];
    model4.title = @"漂流瓶";
    model4.titleImageName = @"ff_IconBottle";
    
    YSStaticSectionModel *sm2 = [YSStaticSectionModel sectionWithItemArray:@[model3, model4]];
    
    YSStaticDefaultModel *model5 = [[YSStaticDefaultModel alloc] init];
    model5.title = @"购物";
    model5.titleImageName = @"CreditCard_ShoppingBag";
    
    YSStaticDefaultModel *model6 = [[YSStaticDefaultModel alloc] init];
    model6.title = @"游戏";
    model6.titleImageName = @"MoreGame";
    model6.indicatorImageName = @"wzry";
    model6.indicatorTitle = @"一起来玩王者荣耀呀!";
    
    YSStaticDefaultModel *model7 = [[YSStaticDefaultModel alloc] init];
    model7.title = @"游戏2";
    model7.titleImageName = @"MoreGame";
    model7.indicatorImageName = @"wzry";
    model7.indicatorTitle = @"一起来玩王者荣耀呀!";
    model7.isIndicatorImageLeft = YES;
    
    YSStaticSectionModel *sm3 = [YSStaticSectionModel sectionWithItemArray:@[model5, model6, model7]];
    
    YSStaticDefaultModel *model8 = [[YSStaticDefaultModel alloc] init];
    model8.title = @"我";
    model8.titleImageName = @"tabbar_meHL";
    model8.indicatorTitle = @"微信的个人中心界面";
    model8.indicatorTitleColor = [UIColor redColor];
    model8.didSelectCellBlock = ^(YSStaticCellModel *cellModel, NSIndexPath *indexPath) {
        __strong typeof(self) strongSelf = weakSelf;
        WXUserCenterViewController *userCenter = [[WXUserCenterViewController alloc] init];
        [strongSelf.navigationController pushViewController:userCenter animated:YES];
    };
    
    YSStaticSectionModel *sm4 = [YSStaticSectionModel sectionWithItemArray:@[model8]];
    
    self.sectionModelArray = @[sm0, sm1, sm2, sm3, sm4];
}

- (void)configureNav {
    self.automaticallyAdjustsScrollViewInsets = NO;
    //修改导航条背景色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:18/255.0 alpha:1];

    //修改导航条标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];

    //修改导航条添加的按钮
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

@end
