//
//  YIMEditerTextFontFamilyCell.m
//  yimediter
//
//  Created by ybz on 2017/11/25.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerTextFontFamilyCell.h"
#import "NSBundle+YIMBundle.h"

@interface YIMEditerTextFontFamilyCell()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *moreImageView;
@end

@implementation YIMEditerTextFontFamilyCell

-(void)setup{
    [super setup];
    UILabel *label = [[UILabel alloc]init];
    label.translatesAutoresizingMaskIntoConstraints = false;
    label.text =[[NSBundle YIMBundle]localizedStringForKey:@"字体" value:@"字体" table:nil];
    label.textColor = [UIColor colorWithRed:0x70/255.0 green:0x70/255.0 blue:0x70/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label];
    
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-16-[label]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.contentView,label)]];
    
    UIImageView *moreImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yimediter.bundle/more"]];
    moreImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:moreImageView];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:moreImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[moreImageView]-16-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.contentView,moreImageView)]];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}
-(CGFloat)needHeight{
    return 39;
}

@end
