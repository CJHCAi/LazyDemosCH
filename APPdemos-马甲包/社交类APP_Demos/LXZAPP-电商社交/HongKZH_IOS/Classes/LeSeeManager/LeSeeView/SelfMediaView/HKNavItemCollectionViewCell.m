//
//  HKNavItemCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKNavItemCollectionViewCell.h"
@interface HKNavItemCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *titlebtn;

@end

@implementation HKNavItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setText:(NSString *)text{
    _text = text;
    [self.titlebtn setTitle:text forState:0];
    [self.titlebtn setTitle:text forState:UIControlStateSelected];
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.titlebtn.selected = isSelect;
}
@end
