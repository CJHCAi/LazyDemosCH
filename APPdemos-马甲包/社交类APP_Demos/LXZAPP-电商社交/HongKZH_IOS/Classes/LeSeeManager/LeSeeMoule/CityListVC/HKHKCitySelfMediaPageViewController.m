//
//  HKHKCitySelfMediaPageViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHKCitySelfMediaPageViewController.h"
#import "HKLeSeeViewModel.h"
#import "HKAdvertisementCityInfo.h"
#import "HKCitySelfMediaViewController.h"
#import "HKCategoryBarView.h"

@interface HKHKCitySelfMediaPageViewController ()
@property (nonatomic, strong)HKCategoryBarView *categoryView;
@end

@implementation HKHKCitySelfMediaPageViewController

- (void)viewDidLoad {
    HKCitySelfMediaViewController*vc = [[HKCitySelfMediaViewController alloc]init];
    vc.cityId = self.cityId;
    vc.categoryId = @"";
    [self.array_VC addObject:vc];
    [super viewDidLoad];
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
      
    }
    return self;
}
-(void)loadData{
    [HKLeSeeViewModel getCityInfoById:@{@"cityId":self.cityId} success:^(HKAdvertisementCityInfo *responde) {
        if (responde.responeSuc) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:@"全部"];
            for (AdvertisementsCategorys*cateM in responde.data.categorys) {
                HKCitySelfMediaViewController*vc = [[HKCitySelfMediaViewController alloc]init];
                vc.categoryId = cateM.categoryId;
                vc.cityId = self.cityId;
                [self.array_VC addObject:vc];
                [array addObject:cateM.categoryName];
            }
            self.categoryView.category = array;
            [self btnClicks:0];
            
        }
    }];
}
-(HKCategoryBarView *)categoryView{
    if (!_categoryView) {
           @weakify(self)
        _categoryView = [HKCategoryBarView categoryBarViewWithCategoryArray:@[@"全部"] selectCategory:^(int index) {
            @strongify(self)
            [self btnClicks:index];
        }];
    }
    return _categoryView;
}
@end
