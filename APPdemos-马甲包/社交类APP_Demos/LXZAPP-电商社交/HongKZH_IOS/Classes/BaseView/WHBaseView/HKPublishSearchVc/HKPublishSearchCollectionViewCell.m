//
//  HKPublishSearchCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPublishSearchCollectionViewCell.h"
#import "HKSearchModels.h"
@interface HKPublishSearchCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation HKPublishSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization codeF5F5F5
    self.iconView.layer.cornerRadius = 10;
    self.iconView.layer.masksToBounds = YES;
}
-(void)setModel:(HKSearchModels *)model{
    _model = model;
    self.titleView.text = model.name;
}
@end
