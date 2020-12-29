//
//  HKCateortyRowTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCateortyRowTableViewCell.h"
@interface HKCateortyRowTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UIView *leftView;

@end

@implementation HKCateortyRowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSelectRow:(BOOL)selectRow{
    _selectRow = selectRow;
    if (selectRow) {
//        self.titleBtn.selected = YES;
        self.leftView.hidden = NO
        ;
    }else{
//        self.titleBtn.selected = NO;
        self.leftView.hidden = YES
        ;
    }
}
-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    [self.titleBtn setTitle:titleText forState:0];
    [self.titleBtn setTitle:titleText forState:UIControlStateSelected];
}
@end
