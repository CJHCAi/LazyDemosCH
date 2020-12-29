//
//  HKEditExpressTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditExpressTableViewCell.h"
@interface HKEditExpressTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *expressName;
@property (weak, nonatomic) IBOutlet UIButton *select;
@property (weak, nonatomic) IBOutlet UITextField *expressNum;

@end

@implementation HKEditExpressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.expressNum addTarget:self action:@selector(textChangeDid:) forControlEvents:UIControlEventEditingChanged];
}
+(instancetype)editExpressTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKEditExpressTableViewCell";
    
    HKEditExpressTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKEditExpressTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.select addTarget:cell action:@selector(selectExpress) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
-(void)textChangeDid:(UITextField*)textField{
    self.model.expresNum = textField.text;
}
-(void)selectExpress{
    if ([self.delegate respondsToSelector:@selector(toVcselectExpress)]) {
        [self.delegate toVcselectExpress];
    }
}
-(void)setModel:(HKExpresModel *)model{
    _model = model;
    if (model.name.length>1) {
        self.expressName.text  = model.name;
    }
    self.expressNum.text = model.expresNum;
    
}
@end
