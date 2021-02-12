
//
//  WXInfoViewController.m
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/19.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "WXInfoViewController.h"

@interface WXInfoViewController ()

@end

@implementation WXInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    [self prepareData];
}

- (void)prepareData {
    YSStaticDefaultModel *model0 = [[YSStaticDefaultModel alloc] init];
    model0.cellHeight = 80;
    model0.title = @"头像";
    model0.indicatorImageName = @"avatar";
    model0.indicatorImageUrl = @"https://img3.duitang.com/uploads/item/201508/07/20150807082213_AcdWu.jpeg";
    model0.indicatorImageSize = CGSizeMake(60, 60);
    
    YSStaticDefaultModel *model1 = [[YSStaticDefaultModel alloc] init];
    model1.title = @"名字";
    model1.indicatorTitle = @"kyson";
    model1.indicatorImageUrl = @"https://img3.duitang.com/uploads/item/201508/07/20150807082213_AcdWu.jpeg";
    
    YSStaticDefaultModel *model2 = [[YSStaticDefaultModel alloc] init];
    model2.title = @"微信号";
    model2.indicatorTitle = @"kyson123456";
    model2.cellType = YSStaticCellTypeAccessoryNone;
    
    YSStaticDefaultModel *model3 = [[YSStaticDefaultModel alloc] init];
    model3.title = @"我的二维码";
    model3.indicatorImageName = @"qrcode";
    model3.indicatorImageSize = CGSizeMake(20, 20);
    
    YSStaticDefaultModel *model4 = [[YSStaticDefaultModel alloc] init];
    model4.title = @"更多";
    
    YSStaticSectionModel *sm0 = [YSStaticSectionModel sectionWithItemArray:@[model0, model1, model2, model3, model4]];
    
    YSStaticDefaultModel *model5 = [[YSStaticDefaultModel alloc] init];
    model5.titleImageName = @"CreditCard_ShoppingBag";
    
    YSStaticDefaultModel *model6 = [[YSStaticDefaultModel alloc] init];
    model6.title = @"我的发票抬头";
    
    YSStaticSectionModel *sm1 = [YSStaticSectionModel sectionWithItemArray:@[model5, model6]];
    
    YSStaticDefaultModel *model7 = [[YSStaticDefaultModel alloc] init];
    model7.title = @"左侧标题";
    model7.titleImageName = @"CreditCard_ShoppingBag";
    model7.isTitleImageRight = YES;
    model7.titleImageSize = CGSizeMake(15, 15);
    
    YSStaticDefaultModel *model8 = [[YSStaticDefaultModel alloc] init];
    model8.title = @"我的发票抬头";
    model8.cellType = YSStaticCellTypeAccessorySwitch;
    model8.switchValueDidChangeBlock = ^(BOOL isOn) {
        NSLog(@"switch: %@", isOn ? @"打开" : @"关闭");
    };
    
    YSStaticSectionModel *sm2 = [YSStaticSectionModel sectionWithItemArray:@[model7, model8]];
    
    YSStaticDefaultModel *model9 = [[YSStaticDefaultModel alloc] init];
    model9.title = @"我要退出";
    model9.cellType = YSStaticCellTypeButton;
    
    YSStaticSectionModel *sm3 = [YSStaticSectionModel sectionWithItemArray:@[model9]];
    
    self.sectionModelArray = @[sm0, sm1, sm2, sm3];
}


@end
