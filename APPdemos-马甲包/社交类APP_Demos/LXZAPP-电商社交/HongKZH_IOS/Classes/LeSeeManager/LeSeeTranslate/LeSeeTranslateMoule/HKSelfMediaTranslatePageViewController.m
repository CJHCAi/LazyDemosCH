//
//  HKSelfMediaTranslatePageViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMediaTranslatePageViewController.h"
#import "HKSelfMediaTranslateCategory.h"
#import "HKLeSeeViewModel.h"
#import "HKMainAllCategoryListRespone.h"
#import "HKMainAllCategoryListRespone.h"
#import "HKSelfMediaTranslateViewController.h"
@interface HKSelfMediaTranslatePageViewController ()<HJTabViewControllerDataSource,HKSelfMediaTranslateCategoryDelegate>
@property (nonatomic, strong)HKSelfMediaTranslateCategory *categoryView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic, strong)NSMutableArray *vcArray;

@property(nonatomic, assign) NSInteger selectIndex;
@end

@implementation HKSelfMediaTranslatePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabDataSource = self;
    self.title = @"自媒体筛选";
    [self loadData];
}
- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController{
    return self.vcArray.count;
}
-(void)itemClick:(NSInteger)item{
    self.selectIndex = item;
    self.categoryView.selectIndex = item;
    [self scrollToIndex:item animated:YES];
}
-(void)loadData{
    [HKLeSeeViewModel getMainAllCategoryList:@{} success:^(HKMainAllCategoryListRespone *responde) {
        if (responde.responeSuc) {
            MainAllCategoryListData*alllistData = [[MainAllCategoryListData alloc]init];
            alllistData.name = @"全部";
            [self.questionArray addObject:alllistData];
            self.categoryView.selectIndex = self.selectIndex;
            self.categoryView.dataArray = self.questionArray;
             HKSelfMediaTranslateViewController*vc = [[HKSelfMediaTranslateViewController alloc]init];
            vc.categoryId = @"";
            [self.vcArray addObject:vc];
            for (MainAllCategoryListData*listData in responde.data) {
                [self.questionArray addObject:listData];
                HKSelfMediaTranslateViewController*vc = [[HKSelfMediaTranslateViewController alloc]init];
                vc.categoryId = listData.categoryId;
                [self.vcArray addObject:vc];
            }
            
            [self reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络请求异常，请稍后再试"];
        }
    }];
}
- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index{
    HKSelfMediaTranslateViewController*vc = self.vcArray[index];
    vc.categoryId = [[self.questionArray[index] categoryId] length]>0?[self.questionArray[index] categoryId]:@"";
    return vc;
}
- (UIView *)tabHeaderViewForTabViewController:(HJTabViewController *)tabViewController{
    return self.categoryView;
}

-(HKSelfMediaTranslateCategory *)categoryView{
    if (!_categoryView) {
        _categoryView = [[HKSelfMediaTranslateCategory alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _categoryView.delegate = self;
    }
    return _categoryView;
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
      
    }
    return _questionArray;
}
-(NSMutableArray *)vcArray{
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
       
    }
    return _vcArray;
}
@end
