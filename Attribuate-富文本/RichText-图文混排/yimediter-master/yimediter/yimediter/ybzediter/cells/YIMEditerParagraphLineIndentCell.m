//
//  YIMEditerParagraphLineIndentCell.m
//  yimediter
//
//  Created by ybz on 2017/12/2.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerParagraphLineIndentCell.h"
#import "UIImage+YIMEditerImageExtend.h"

@interface YIMEditerParagraphLineIndentCell()
@property(nonatomic,strong)UIButton *leftTabButton;
@property(nonatomic,strong)UIButton *rightTabButton;
@end

@implementation YIMEditerParagraphLineIndentCell

-(void)setup{
    [super setup];
    UIButton *leftTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftTabButton addTarget:self action:@selector(clickLeft:) forControlEvents:UIControlEventTouchUpInside];
    [leftTabButton setImage:[UIImage imageNamed:@"yimediter.bundle/left_tab"] forState:UIControlStateNormal];
    [leftTabButton setImage:[[UIImage imageNamed:@"yimediter.bundle/left_tab"]YIMImageWithTintColor:self.setting.tintColor] forState:UIControlStateSelected];
    [self.contentView addSubview:leftTabButton];
    
    UIButton *rightTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightTabButton setImage:[UIImage imageNamed:@"yimediter.bundle/right_tab"] forState:UIControlStateNormal];
    [rightTabButton setImage:[[UIImage imageNamed:@"yimediter.bundle/right_tab"]YIMImageWithTintColor:self.setting.tintColor] forState:UIControlStateSelected];
    [rightTabButton addTarget:self action:@selector(clickRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:rightTabButton];
    self.leftTabButton = leftTabButton;
    self.rightTabButton = rightTabButton;
}
-(CGFloat)needHeight{
    return 54;
}
-(void)layoutSubviews{
    CGFloat buttonWidth = 60;
    self.leftTabButton.frame = CGRectMake(CGRectGetMidX(self.frame) - buttonWidth, 0, buttonWidth, CGRectGetHeight(self.frame));
    self.rightTabButton.frame = CGRectMake(CGRectGetMidX(self.frame), 0, buttonWidth, CGRectGetHeight(self.frame));
}
-(void)setIsRightTab:(BOOL)isRightTab{
    _isRightTab = isRightTab;
    [self.rightTabButton setSelected:false];
    [self.leftTabButton setSelected:false];
    if (isRightTab) {
        [self.rightTabButton setSelected:true];
    }else{
        [self.leftTabButton setSelected:true];
    }
}
-(void)clickLeft:(UIButton*)sender{
    [self.rightTabButton setSelected:false];
    [self.leftTabButton setSelected:true];
    if(self.lineIndentChange)
        self.lineIndentChange(false);
}
-(void)clickRight:(UIButton*)sender{
    [self.rightTabButton setSelected:true];
    [self.leftTabButton setSelected:false];
    if(self.lineIndentChange)
        self.lineIndentChange(true);
}

@end
