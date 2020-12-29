//
//  HKEditGoodsModelIdTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditGoodsModelIdTableViewCell.h"
@interface HKEditGoodsModelIdTableViewCell()
@property (weak, nonatomic) IBOutlet UITextField *modelId;
@property (weak, nonatomic) IBOutlet UITextField *preceText;
@property (weak, nonatomic) IBOutlet UITextField *numText;

@end

@implementation HKEditGoodsModelIdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [self.modelId addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
     [self.preceText addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
     [self.numText addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIImage *image =[UIImage imageNamed:@"bkms_lb"];
    UIImageView * leftView =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,image.size.width,image.size.height)];
    leftView.image = image;
    self.preceText.leftView = leftView;
    self.preceText.leftViewMode =UITextFieldViewModeAlways;
}
-(void)passConTextChange:(UITextField*)textField{
    if (textField.tag == 1) {
        self.model.price =  [textField.text integerValue];
    }else if(textField.tag == 2){
        self.model.num = [textField.text integerValue];
    }else if (textField.tag == 0){
        self.model.model = textField.text;
    }
}
+(instancetype)ditGoodsModelIdTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKEditGoodsModelIdTableViewCell";
    
    HKEditGoodsModelIdTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKEditGoodsModelIdTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setModel:(SkusModel *)model{
    _model = model;
    self.preceText.text = [NSString stringWithFormat:@"%ld",model.price];
    self.numText.text = [NSString stringWithFormat:@"%ld",model.num];
    self.modelId.text = model.model;
}
- (IBAction)deleteSku:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteSkusWithModel:)]) {
        [self.delegate deleteSkusWithModel:self.model];
    }
}
@end
