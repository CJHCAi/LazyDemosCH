//
//  FTQuestionOptionCell.m
//  FaceTraningForManager
//
//  Created by caixiang on 2017/6/29.
//  Copyright © 2017年 aopeng. All rights reserved.
//


// import start by tools :)
#import "FTQuestionOptionCell.h"
#import "UIImage+Additional.h"
// import end by tools :(


// 为了去除Pch，如果页面不需要可手动删除部分
@interface FTQuestionOptionCell ()

@property (weak, nonatomic) IBOutlet UILabel *optionTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *dragImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation FTQuestionOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 10;
    frame.size.height -= 5;
    frame.size.width = ([UIScreen mainScreen].bounds).size.width - 10 * 2;
    [super setFrame:frame];
}

- (void)fillCellWithObject:(id)objct {
    [self resetDrawdragCell];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"img_sort_option_orange"] forState:UIControlStateNormal];
    [self.selectButton setTitle:[NSString stringWithFormat:@"%zd",self.indexPath.row + 1] forState:UIControlStateNormal];
    if (self.indexPath.row == 0) {
        self.optionTextLabel.text = [NSString stringWithFormat:@"不可拖拽的cell,也不可被排序 高度为%@",objct];
    } else {
        self.optionTextLabel.text = [NSString stringWithFormat:@"拖拽的cell %zd 高度为%@",self.indexPath.row + 1,objct];
    }
}

- (void)drawdragCell {
    UIImage *naviBackImage = [UIImage imageWithColors:@[UIColorFromRGBA(0xFF9E23,1),UIColorFromRGBA(0xFF6F29,1)] size:CGSizeMake(([UIScreen mainScreen].bounds).size.width, 40) leftToRight:YES];
    self.backgroundImageView.image = naviBackImage;
    self.dragImageView.image = [UIImage imageNamed:@"icon_drag_set"];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"img_sort_option_set"] forState:UIControlStateNormal];
    [self.selectButton setTitleColor:UIColorFromRGB(0xFF7E00) forState:UIControlStateNormal];
    self.optionTextLabel.textColor = UIColorFromRGB(0xFFFFFF);
}

- (void)resetDrawdragCell {
    [self.selectButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    self.optionTextLabel.textColor = UIColorFromRGB(0x666666);
    self.backgroundImageView.image = [UIImage new];
    self.dragImageView.image = [UIImage imageNamed:@"icon_drag_nor"];
}


UIKIT_STATIC_INLINE UIColor *UIColorFromRGB(uint32_t rgbValue) {
    return UIColorFromRGBA(rgbValue,1.0f);
}

UIKIT_STATIC_INLINE UIColor *UIColorFromRGBA(uint32_t rgbValue, CGFloat a) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0f
                            blue:((float)(rgbValue & 0xFF))/255.0f
                           alpha:a];
}

@end
