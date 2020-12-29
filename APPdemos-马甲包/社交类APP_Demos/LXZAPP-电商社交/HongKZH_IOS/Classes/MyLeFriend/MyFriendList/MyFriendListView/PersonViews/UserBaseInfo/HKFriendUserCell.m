//
//  HKFriendUserCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFriendUserCell.h"

@interface HKFriendUserCell ()

@end

@implementation HKFriendUserCell

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        [self addSubview:self.icon];
        [self addSubview:self.nameLabel];
    }
    return self;
}
-(UIImageView *)icon {
    if (!_icon) {
        _icon =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,48,48)];
        _icon.layer.cornerRadius =24;
        _icon.layer.masksToBounds =YES;
        _icon.image =[UIImage imageNamed:@"back3.jpg"];
    }
    return _icon;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.icon.frame)+7,CGRectGetWidth(self.icon.frame),12)];
        [AppUtils getConfigueLabel:_nameLabel font:PingFangSCRegular12 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@"Jo白琪"];
    }
    return _nameLabel;
}
@end
