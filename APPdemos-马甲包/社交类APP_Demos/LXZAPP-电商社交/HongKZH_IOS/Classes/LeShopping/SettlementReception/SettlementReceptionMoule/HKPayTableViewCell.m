//
//  HKPayTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPayTableViewCell.h"
#import "UIImage+YY.h"
@interface HKPayTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation HKPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage*image = [[UIImage createImageWithColor:[UIColor colorFromHexString:@"EF593C "] size:CGSizeMake(kScreenWidth-60, 45)]zsyy_imageByRoundCornerRadius:5];
    [self.btn setBackgroundImage:image forState:0];
}

@end
