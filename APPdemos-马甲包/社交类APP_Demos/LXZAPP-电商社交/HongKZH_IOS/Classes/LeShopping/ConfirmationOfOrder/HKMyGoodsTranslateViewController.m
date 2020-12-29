//
//  HKMyGoodsTranslateViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyGoodsTranslateViewController.h"
#import "HKConfirmationOfOrderViewModel.h"
#import "HKMyGoodsTranslateTableViewCell.h"
#import "HKCouponResponse.h"
@interface HKMyGoodsTranslateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
@property (nonatomic, strong)NSArray *dataArray;
@end

@implementation HKMyGoodsTranslateViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self =[[HKMyGoodsTranslateViewController alloc]initWithNibName:@"HKMyGoodsTranslateViewController" bundle:nil];
    }
    return self;
}
+(void)showMyGoodsTranslateViewControllerWithSuperVc:(HKBaseViewController*)superVc productId:(getCartListDataProducts*)productId{
    HKMyGoodsTranslateViewController*vc = [[HKMyGoodsTranslateViewController alloc]init];
    vc.productId = productId;
    vc.delegate = superVc;
    [HKBaseViewController showPreWithsuperVc:superVc subVc:vc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableVIew.delegate = self;
    self.tableVIew.dataSource = self;
    [self loadData];
}
-(void)loadData{
    [HKConfirmationOfOrderViewModel getMyCouponsByProductId:@{@"productId":self.productId.productId,@"loginUid":HKUSERLOGINID} success:^(NSArray *dataArray, BOOL isSuc) {
        if (isSuc) {
            self.dataArray = dataArray;
            [self.tableVIew reloadData];
        }
    }];
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyGoodsTranslateTableViewCell*cell = [HKMyGoodsTranslateTableViewCell baseCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCounList*countM = self.dataArray[indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(selected:getCartListDataProducts:)]) {
        [self.delegate selected:countM.couponId getCartListDataProducts:self.productId];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
