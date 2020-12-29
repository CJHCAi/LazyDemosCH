//
//  HKCategoryTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCategoryTableViewCell.h"
#import "HKCategoryClicleModel.h"
@interface HKCategoryTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;

@end

@implementation HKCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
+(instancetype)categoryTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKCategoryTableViewCell";
    
    HKCategoryTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setSelectRow:(BOOL)selectRow{
    _selectRow = selectRow;
    if (_selectRow) {
        self.nameBtn.selected = YES;
        self.leftView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:146.0/255.0 blue:255.0/255.0 alpha:1];
    }else{
        self.nameBtn.selected = NO;
        self.leftView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    }
}
-(void)setModel:(HKCategoryClicleModel *)model{
    _model = model;
    [self.nameBtn setTitle:model.categoryName forState:0];
}
@end
