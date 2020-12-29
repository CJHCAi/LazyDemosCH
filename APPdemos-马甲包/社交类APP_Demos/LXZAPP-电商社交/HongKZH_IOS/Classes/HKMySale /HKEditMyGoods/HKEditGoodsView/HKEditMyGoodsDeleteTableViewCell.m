//
//  HKEditMyGoodsDeleteTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditMyGoodsDeleteTableViewCell.h"
@interface HKEditMyGoodsDeleteTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *descript;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downH;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation HKEditMyGoodsDeleteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)editMyGoodsDeleteTableViewCell:(UITableView*)tableView{
    NSString*ID = @"HKEditMyGoodsDeleteTableViewCell";
    
    HKEditMyGoodsDeleteTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKEditMyGoodsDeleteTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (IBAction)deleteGoods:(id)sender {
    if ([self.delegate respondsToSelector:@selector(removeGoods)]) {
        [self.delegate removeGoods];
    }
}
- (IBAction)addGoods:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addGoodsGotoVc)]) {
        [self.delegate addGoodsGotoVc];
    }
}
- (void)setModel:(MyGoodsInfo *)model{
    _model = model;
    if (model. descript.length >0) {
        self.descript.text = @"已添加";
    }else{
        self.descript.text = @"未添加";
    }
}
-(void)setIsAdd:(BOOL)isAdd{
    _isAdd = isAdd;
    if (_isAdd) {
        self.downH.constant = 0;
        self.deleteBtn.hidden = YES;
    }else{
        self.downH.constant = 89;
        self.deleteBtn.hidden = NO;
    }
}
- (IBAction)editHtml:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(htmlEdit)]) {
        [self.delegate htmlEdit];
    }
}
@end
