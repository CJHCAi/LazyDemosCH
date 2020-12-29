//
//  HKOrderFormMangerViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderFormMangerViewController.h"
#import "HKCategoryBarView.h"
#import "HKOrderFromListViewController.h"
#import "HKOrderFormSearchViewController.h"
@interface HKOrderFormMangerViewController ()
@property (nonatomic, strong)HKCategoryBarView *categoryView;
@end

@implementation HKOrderFormMangerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSearchUI];
    [self setUI];
}

-(void)setUI{
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
}
-(void)searchGoods{
    HKOrderFormSearchViewController*searchVc = [[HKOrderFormSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVc animated:YES];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        HKOrderFromListViewController *vc1 = [[HKOrderFromListViewController alloc]init];
        vc1.orderType = OrderFormType_Ing;
        HKOrderFromListViewController *vc2 = [[HKOrderFromListViewController alloc]init];
         vc2.orderType = OrderFormType_Finish;
        HKOrderFromListViewController *vc3 = [[HKOrderFromListViewController alloc]init];
         vc3.orderType = OrderFormType_Close;
        [self.array_VC addObject:vc1];
         [self.array_VC addObject:vc2];
         [self.array_VC addObject:vc3];
    }
    return self;
}
-(HKCategoryBarView *)categoryView{
    if (!_categoryView) {
        @weakify(self)
        _categoryView = [HKCategoryBarView categoryBarViewWithCategoryArray:@[@"进行中",@"已完成",@"已关闭"] selectCategory:^(int index) {
            @strongify(self)
            [self btnClicks:index];
        }];
    }
    return _categoryView;
}

@end
