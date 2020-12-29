//
//  HKSelfMediaSearchsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMediaSearchsViewController.h"
#import "SelfMediaSearchsViewModel.h"
#import "SearchGoodsRespone.h"
#import "HKSelfMediaSearchListViewController.h"
@interface HKSelfMediaSearchsViewController ()

@end

@implementation HKSelfMediaSearchsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = SearchType_SeleMeadia;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
-(void)loadData{
    [SelfMediaSearchsViewModel selfMediaSearchs:@{@"loginUid":HKUSERLOGINID}type:self.type  success:^(SearchGoodsRespone *respone) {
        if (respone.responeSuc) {
            self.locArray = respone.data.historys;
            self.hotArray = respone.data.hosts;
            [self.collection reloadData];
        }
    }];
}

-(void)textFieldChange:(UITextField *)textField{
    [SelfMediaSearchsViewModel searcPVideo:@{@"loginUid":HKUSERLOGINID,@"name":textField.text} type:self.type success:^(NSMutableArray *dataArray) {
        self.dataArray = dataArray;
        [self.tableView reloadData];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HKSelfMediaSearchListViewController*vc = [[HKSelfMediaSearchListViewController alloc]init];
    vc.mediaType = self.mediatype;
    vc.titleStr = [self.dataArray[indexPath.row]title];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        HKSelfMediaSearchListViewController*vc = [[HKSelfMediaSearchListViewController alloc]init];
        vc.mediaType = self.mediatype;
        vc.titleStr = [self.locArray[indexPath.row]name];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HKSelfMediaSearchListViewController*vc = [[HKSelfMediaSearchListViewController alloc]init];
        vc.mediaType = self.mediatype;
        vc.titleStr = [self.hotArray[indexPath.row]name];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
