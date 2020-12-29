//
//  HKSelfMediaTranslateCategoryCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMediaTranslateCategoryCollectionViewCell.h"
@interface HKSelfMediaTranslateCategoryCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@end

@implementation HKSelfMediaTranslateCategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(MainAllCategoryListData *)model{
    _model = model;
    [self.titleBtn setTitle:model.name forState:0];
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.titleBtn.selected = isSelect;
}
@end
