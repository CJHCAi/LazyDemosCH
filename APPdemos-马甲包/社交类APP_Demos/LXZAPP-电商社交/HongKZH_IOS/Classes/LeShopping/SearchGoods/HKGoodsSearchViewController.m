//
//  HKGoodsSearchViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKGoodsSearchViewController.h"
#import "HKShoppingViewModel.h"
#import "SearchGoodsRespone.h"
#import "HKGoodsSearchListViewController.h"
@interface HKGoodsSearchViewController ()

@end

@implementation HKGoodsSearchViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = SearchType_Goods;
}
-(void)loadData{
    [HKShoppingViewModel  shopSearchProductHistory:@{@"loginUid":HKUSERLOGINID} success:^(SearchGoodsRespone *responde) {
        if (responde.responeSuc) {
            self.hotArray = responde.data.hosts;
            self.locArray = responde.data.historys;
            [self.collection reloadData];
        }
    }];
}
-(void)textFieldChange:(UITextField *)textField{
    [HKShoppingViewModel  searchProduct:@{@"name":textField.text,@"loginUid":HKUSERLOGINID} success:^(NSMutableArray *dataArray) {
        self.dataArray = dataArray;
        [self.tableView reloadData];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HKGoodsSearchListViewController*vc = [[HKGoodsSearchListViewController alloc]init];
    vc.titleStr = [self.dataArray[indexPath.row]title];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HKGoodsSearchListViewController*vc = [[HKGoodsSearchListViewController alloc]init];
    if (indexPath.section == 1) {
        
        vc.titleStr = [self.locArray[indexPath.item]name];
    }else{
        vc.titleStr = [self.hotArray[indexPath.item]name];
    }
    
     [self.navigationController pushViewController:vc animated:YES];
}
@end
