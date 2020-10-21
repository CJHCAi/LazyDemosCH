//
//  BGPayViewController.m
//  WeiTuan
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 西格. All rights reserved.
//
//不足额，默认零钱+微信，  零钱+支付宝， 或者   微信、支付宝可选 二选一，  但是微信和支付宝不能同时选
//足额，零钱、微信、支付宝都可选    三选一

#import "BGPayViewController.h"
#import "BGNeedPayCell.h"

@interface BGPayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentArr;

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) BOOL isTrackIndex;

@property (nonatomic) BOOL isEnough;

@end

@implementation BGPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
     [self setupView];
    
     self.isEnough = self.isEnoughPay;
     self.isTrackIndex = YES;
}


- (void)setupView {
    
    self.tableView.rowHeight = 50;
    self.tableView.scrollEnabled = NO;
}


- (IBAction)ensurePayAction:(UIButton *)sender {
    
    
}


#pragma mark --- UITableviewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count? self.contentArr.count : 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BGNeedPayCell *cell = [BGNeedPayCell cellWithTableView:tableView];
    
    [self configCell:cell data:[self.contentArr objectAtIndex:indexPath.row] indexPath:indexPath];
    
    return cell;
}

- (void)configCell:(BGNeedPayCell *)cell data:(NSDictionary *)contentDic indexPath:(NSIndexPath *)indexPath{

    if (self.isEnough) {//足额
        cell.iconImg.image = [UIImage imageNamed:contentDic[@"icon"]];
        cell.payLabel.text = contentDic[@"content"];
        if (self.currentIndex == indexPath.row) {
            cell.payStateImg.image = [UIImage imageNamed:@"mr_pay_okselected"];
        }else{
            cell.payStateImg.image = [UIImage imageNamed:@"mr_pay_ok"];
        }
    }else {//不足额  一 + 二
        if (self.isTrackIndex) {
            cell.iconImg.image = [UIImage imageNamed:contentDic[@"icon"]];
            cell.payLabel.text = contentDic[@"content"];
            if (self.currentIndex == indexPath.row) {
                cell.payStateImg.image = [UIImage imageNamed:@"mr_pay_okselected"];
            }else{
                cell.payStateImg.image = [UIImage imageNamed:@"mr_pay_ok"];
            }
            
            if (indexPath.row == 0) {
                cell.iconImg.image = [UIImage imageNamed:contentDic[@"icon"]];
                cell.payLabel.text = contentDic[@"content"];
                cell.payStateImg.image = [UIImage imageNamed:@"mr_pay_okselected"];
            }
        }else {//不足额  二 选 一
            cell.iconImg.image = [UIImage imageNamed:contentDic[@"icon"]];
            cell.payLabel.text = contentDic[@"content"];
            if (self.currentIndex == indexPath.row) {
                cell.payStateImg.image = [UIImage imageNamed:@"mr_pay_okselected"];
            }else{
                cell.payStateImg.image = [UIImage imageNamed:@"mr_pay_ok"];
            }
            
            if (indexPath.row == 0) {
                cell.iconImg.image = [UIImage imageNamed:contentDic[@"icon"]];
                cell.payLabel.text = contentDic[@"content"];
                cell.payStateImg.image = [UIImage imageNamed:@"mr_pay_ok"];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentIndex = indexPath.row;
    if (indexPath.row == 0) {
        self.isTrackIndex = !self.isTrackIndex;
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark --- Lazy loading

- (NSMutableArray *)contentArr {
    if (!_contentArr) {
        self.contentArr = @[].mutableCopy;
        [self.contentArr addObject:@{@"icon":@"mr_change", @"content":@"剩余支付", @"state":@"mr_pay_okselected", @"type":@"change"}];
        [self.contentArr addObject:@{@"icon":@"mr_pay_wechatselected", @"content":@"微信支付", @"state":@"mr_pay_ok", @"type":@"wechatpay"}];
        [self.contentArr addObject:@{@"icon":@"mr_pay_alipayselected", @"content":@"支付宝支付", @"state":@"mr_pay_ok", @"type":@"alipay"}];
    }
    return _contentArr;
}

@end
