//
//  HKBaseRowTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseRowTableViewCell.h"
@interface HKBaseRowTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation HKBaseRowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}
@end
