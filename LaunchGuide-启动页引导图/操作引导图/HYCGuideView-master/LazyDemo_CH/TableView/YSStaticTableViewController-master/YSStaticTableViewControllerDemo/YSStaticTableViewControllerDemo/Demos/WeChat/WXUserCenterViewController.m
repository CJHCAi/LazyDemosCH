//
//  WXUserCenterViewController.m
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/19.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "WXUserCenterViewController.h"
#import "YSAvatarModel.h"
#import "YSAvatorCell.h"
#import "WXInfoViewController.h"

@interface WXUserCenterViewController ()

@end

@implementation WXUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我";
    
    [self prepareData];
}

- (void)prepareData {
    __weak typeof(self) weakSelf = self;

    // ========== section 0
    YSAvatarModel *vm0 = [[YSAvatarModel alloc] init];
    vm0.cellIdentifier = @"avatarCell";
    
    // 请使用这种方法设置classname，不要使用字符串，防止类没加载
    // 导致调用 NSClassFromstring 时 为 nil 报错
    vm0.cellClassName = NSStringFromClass([YSAvatorCell class]);
//    vm0.cellClassName = @"YSAvatorCell";
    vm0.cellHeight = 80;
    vm0.cellType = YSStaticCellTypeCustom;

    vm0.avatarImage = [UIImage imageNamed:@"avatar"];
    vm0.userName = @"kyson";
    vm0.userID = @"微信号：xxxxxx";
    vm0.codeImage = [UIImage imageNamed:@"qrcode"];
    vm0.didSelectCellBlock = ^(YSStaticCellModel *cellModel, NSIndexPath *indexPath) {
        __strong typeof(self) strongSelf = weakSelf;
        WXInfoViewController *info = [[WXInfoViewController alloc] init];
        [strongSelf.navigationController pushViewController:info animated:YES];
    };
    
    YSStaticSectionModel *sm0 = [YSStaticSectionModel sectionWithItemArray:@[vm0]];

    // ========== section 1
    YSAvatarModel *vm1 = [[YSAvatarModel alloc] init];
    // 重写init 将这些默认值写入，此处无需再写
//    vm0.cellIdentifier = @"avatarCell";
//    vm0.cellClassName = @"YSAvatarCell";
//    vm0.cellHeight = 80;
//    vm0.cellType = YSStaticCellTypeCustom;
    
    vm1.avatarImage = [UIImage imageNamed:@"avatar"];
    vm1.userName = @"kyson";
    vm1.userID = @"微信号：xxxxxx";
    vm1.codeImage = [UIImage imageNamed:@"qrcode"];
    vm1.didSelectCellBlock = ^(YSStaticCellModel *cellModel, NSIndexPath *indexPath) {
        __strong typeof(self) strongSelf = weakSelf;
        WXInfoViewController *info = [[WXInfoViewController alloc] init];
        [strongSelf.navigationController pushViewController:info animated:YES];
    };
    
    YSStaticSectionModel *sm1 = [YSStaticSectionModel sectionWithItemArray:@[vm1]];
    // ========== section 2
    YSStaticDefaultModel *vm2 = [[YSStaticDefaultModel alloc] init];
    vm2.titleImageName = @"MoreMyAlbum";
    vm2.title = @"相册";
    
    YSStaticDefaultModel *vm3 = [[YSStaticDefaultModel alloc] init];
    vm3.titleImageName = @"MoreMyFavorites";
    vm3.title = @"收藏";
    
    YSStaticDefaultModel *vm4 = [[YSStaticDefaultModel alloc] init];
    vm4.titleImageName = @"MoreMyBankCard";
    vm4.title = @"钱包";
    
    YSStaticDefaultModel *vm5 = [[YSStaticDefaultModel alloc] init];
    vm5.titleImageName = @"MyCardPackageIcon";
    vm5.title = @"卡包";
    
    YSStaticSectionModel *sm2 = [YSStaticSectionModel sectionWithItemArray:@[vm2,vm3,vm4,vm5]];
    
    // ========== section 3
    YSStaticDefaultModel *vm6 = [[YSStaticDefaultModel alloc] init];
    vm6.titleImageName = @"emoticon";
    vm6.title = @"表情";
    
    YSStaticSectionModel *sm3 = [YSStaticSectionModel sectionWithItemArray:@[vm5]];
    
    // ========== section 4
    YSStaticDefaultModel *vm7 = [[YSStaticDefaultModel alloc] init];
    vm7.titleImageName = @"MoreSetting";
    vm7.title = @"设置";
    // 设置就不写了，在info里面集成一些没有出现的
    
    YSStaticSectionModel *sm4 = [YSStaticSectionModel sectionWithItemArray:@[vm7]];
    
    self.sectionModelArray = @[sm0, sm1, sm2, sm3, sm4];
}

@end
