//
//  HKUploadVoucherTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUploadVoucherTableViewCell.h"
#import "HKEditImageView.h"
@interface HKUploadVoucherTableViewCell()<HKEditImageViewDelegate>
@property (weak, nonatomic) IBOutlet HKEditImageView *editImageView;
@property (weak, nonatomic) IBOutlet UILabel *proofLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proofH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;

@end

@implementation HKUploadVoucherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.editImageView.delegate = self;
    self.editImageView.maxNum = 5;
}
-(void)imageUpdateWithIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(dataUpdatedWithIndex:)]) {
        [self.delegate dataUpdatedWithIndex:index];
    }
}
+(instancetype)uploadVoucherTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKUploadVoucherTableViewCell";
    
    HKUploadVoucherTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKUploadVoucherTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    self.editImageView.imageArray = imageArray;
    self.editImageView.type = 1;
}
-(void)setStaue:(AfterSaleViewStatue)staue{
    _staue = staue;
    if (_staue == AfterSaleViewStatue_ProofOfBuyerseller) {
        self.proofLabel.hidden = NO;
        self.proofLabel.text = @"举证内容包括但不限于商品实物凭证、沟通凭证、物流凭证等";
        self.topH.constant = 8;
    }else{
        self.proofLabel.hidden = YES;
        self.proofLabel.text = @"";
        self.topH.constant = 5;
        
    }
}
@end
