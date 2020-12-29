//
//  HKSearchTipsTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchTipsTableViewCell.h"
@interface HKSearchTipsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation HKSearchTipsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setEndTitle:(NSString*)title name:(NSString*)name{
     NSRange range;
    NSMutableAttributedString*titleA = [[NSMutableAttributedString alloc]initWithString:name];
    if([name rangeOfString:title].location !=NSNotFound){
        
        range = [name rangeOfString:title];
        
        [titleA addAttribute:NSForegroundColorAttributeName  value:[UIColor colorFromHexString:@"EF593c"]range:NSMakeRange(range.location, range.length)];
        
    }
    [titleA addAttribute:NSFontAttributeName  value:PingFangSCMedium15 range:NSMakeRange(0, titleA.length)];
    self.label.attributedText = titleA;
    
}
@end
