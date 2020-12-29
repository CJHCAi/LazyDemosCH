//
//  HKExpressableTViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKExpressableTViewCell.h"
@interface HKExpressableTViewCell()
@property (weak, nonatomic) IBOutlet UIButton *expressName;

@end

@implementation HKExpressableTViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)expressableTViewCellWithTableView:(UITableView*)tableView{
    
    NSString*ID = @"HKExpressableTViewCell";
    
    HKExpressableTViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKExpressableTViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(HKExpresModel *)model{
    _model = model;
    [self.expressName setTitle:model.name forState:0];
}
@end
