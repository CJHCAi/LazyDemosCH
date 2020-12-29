//
//  HKLEIOperationCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLEIOperationCell.h"
#import "HKLEIOperationModel.h"
#import "HKMyDataRespone.h"
@interface HKLEIOperationCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *iconView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation HKLEIOperationCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)lEIOperationCellWithTableView:(UITableView*)tableView{
    HKLEIOperationCell*cell = [tableView dequeueReusableCellWithIdentifier:@"HKLEIOperationCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HKLEIOperationCell" owner:self options:nil].lastObject;
    }
    return cell;
}
-(void)setDataModel:(HKLEIOperationModel *)dataModel{
    _dataModel = dataModel;
    self.titleLabel.text = dataModel.title;
    [self.iconView setImage:[UIImage imageNamed:dataModel.icon] forState:UIControlStateNormal];
}
-(void)configueRecuitCell {
    if ([LoginUserData sharedInstance].isEnterpriserecRuited==2) {
        self.titleLabel.text =@"企业招聘";
    }else {
        self.titleLabel.text =@"我的应聘";
    }
}
-(void)setRespone:(HKMyDataRespone *)respone{
    _respone = respone;
    if ([self.dataModel.title isEqualToString:@"购物车"]) {
        if (respone.data.carts) {
            self.numLabel.text = [NSString stringWithFormat:@"%ld",respone.data.carts] ;
            self.numLabel.textColor = keyColor;
        }else {
            self.numLabel.text= @"";
        }
    }else if ([self.dataModel.title isEqualToString:@"我的订单"]){
        if (respone.data.orders) {
            self.numLabel.text = [NSString stringWithFormat:@"%ld",respone.data.orders];
            self.numLabel.textColor = keyColor;
        }else {
            self.numLabel.text = @"";
        }
        
    }else if ([self.dataModel.title isEqualToString:@"退换/售后"]){
        if (respone.data.afterService) {
            self.numLabel.text = [NSString stringWithFormat:@"%ld",respone.data.afterService];
            self.numLabel.textColor =[UIColor colorFromHexString:@"333333"];
        }else {
            self.numLabel.text = @"";
        }
    }else if ([self.dataModel.title isEqualToString:@"我的售卖"]){
        if (respone.data.sells) {
             self.numLabel.text = [NSString stringWithFormat:@"+%ld",respone.data.sells];
             self.numLabel.textColor = keyColor;
        }else {
            self.numLabel.text = @"";
        }
    }else if ([self.dataModel.title isEqualToString:@"我的应聘"]){
        self.numLabel.text = [NSString stringWithFormat:@"%ld",respone.data.jobs];
    }else if ([self.dataModel.title isEqualToString:@",每日任务"]){
        self.numLabel.text = [NSString stringWithFormat:@"%ld",respone.data.task];
    }else{
        self.numLabel.text = @"";
    }
    
    
}
@end
