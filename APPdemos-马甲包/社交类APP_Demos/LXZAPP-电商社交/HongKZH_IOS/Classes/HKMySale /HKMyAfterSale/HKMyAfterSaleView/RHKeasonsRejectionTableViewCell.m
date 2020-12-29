//
//  RHKeasonsRejectionTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "RHKeasonsRejectionTableViewCell.h"
@interface RHKeasonsRejectionTableViewCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *explain;

@end

@implementation RHKeasonsRejectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
}
-(void)textViewDidChange:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(isSubmission:)]) {
        [self.delegate isSubmission:textView.text];
    }
    if (textView.text.length>0) {
        self.explain.hidden = YES;
    }else{
        self.explain.hidden = NO;
    }
}
+(instancetype)keasonsRejectionTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"RHKeasonsRejectionTableViewCell";
    
    RHKeasonsRejectionTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"RHKeasonsRejectionTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setStaue:(AfterSaleViewStatue)staue{
    _staue = staue;
    if (staue == AfterSaleViewStatue_RefuseReturn) {
        self.explain.text = @"请添加拒绝原因，字数控制在10-800字";
    }else if (staue == AfterSaleViewStatue_ProofOfBuyerseller){
        self.explain.text = @"请填写举证内容，字数控制在10-800字";
    }
}
@end
