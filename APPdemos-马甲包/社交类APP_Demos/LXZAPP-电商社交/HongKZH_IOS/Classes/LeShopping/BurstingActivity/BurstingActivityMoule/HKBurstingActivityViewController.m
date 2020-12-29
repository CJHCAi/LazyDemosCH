//
//  HKBurstingActivityViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingActivityViewController.h"
#import "HKShoppingViewModel.h"
#import "HKBurstingActivityHeadView.h"
#import "HKLuckyBurstRespone.h"
#import "HKBurstingActivityListViewController.h"
@interface HKBurstingActivityViewController ()<HJTabViewControllerDataSource,HKBurstingActivityHeadViewDelegate,HKBurstingActivityListViewControllerDelegate>
@property (nonatomic, strong)NSMutableArray *tableArray;
@property (nonatomic, strong)HKBurstingActivityHeadView *headView;
@property (nonatomic, strong)HKLuckyBurstRespone *respone;
@end

@implementation HKBurstingActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabDataSource = self;
    [self setUI];
    [self loadData];
}
-(void)setUI{
    self.title = @"爆款活动";
//    [self setrightBarButtonItemWithImageName:@"class_search"];
}
-(void)rightBarButtonItemClick{
    //商品搜索..
    [AppUtils pushGoodsSearchWithCurrentVc:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)switchVc:(NSInteger)tag{
    [self scrollToIndex:tag animated:NO];
}

-(void)loadData{
    [HKShoppingViewModel getLuckyBurst:@{} success:^(HKLuckyBurstRespone *responde) {
        if (responde.responeSuc) {
            self.respone = responde;
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)updateStaue:(NSInteger)staueDate index:(NSInteger)index{
    LuckyBurstTypes*typeM = self.respone.data.types[index];
    typeM.sortDate = staueDate;
    self.headView.respone = self.respone;
}
-(void)setTableArray:(NSMutableArray *)tableArray{
    _tableArray = tableArray;
    [self reloadData];
}
- (UIView *)tabHeaderViewForTabViewController:(HJTabViewController *)tabViewController{
    return self.headView;
}
- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return self.tableArray.count;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    return self.tableArray[index];
}
-(HKBurstingActivityHeadView *)headView{
    if (!_headView) {
        _headView = [[HKBurstingActivityHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
        _headView.delegate = self;
    }
    return _headView;
}
- (HKBurstingActivityListViewController *)extracted {
    return [HKBurstingActivityListViewController alloc];
}

-(void)setRespone:(HKLuckyBurstRespone *)respone{
    _respone = respone;
    self.headView.respone = respone;
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:respone.data.types.count];
    for (int i=0;i< respone.data.types.count;i++) {
        LuckyBurstTypes*typeM  = respone.data.types[i];
        HKBurstingActivityListViewController*vc = [[self extracted]init];
        vc.model = typeM;
        vc.indexVc = i;
        vc.delegate = self;
        [array addObject:vc];
    }
    self.tableArray = array;
    
    for (int i = 0; i<respone.data.types.count; i++) {
        LuckyBurstTypes*typeM = respone.data.types[i];
        if (typeM.sortDate == 0) {
            [self scrollToIndex:i animated:NO];
            break;
        }
    }
}
@end
