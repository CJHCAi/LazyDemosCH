//
//  YIMEditerParagraphAlignmentCell.m
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerParagraphAlignmentCell.h"
#import "UIImage+YIMEditerImageExtend.h"
#import "NSBundle+YIMBundle.h"

@interface YIMEditerParagraphAlignmentCell()
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UIButton *centerButton;
@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation YIMEditerParagraphAlignmentCell

-(void)setup{
    [super setup];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [[NSBundle YIMBundle]localizedStringForKey:@"对齐方式" value:@"对齐方式" table:nil];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titleLabel];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(clickLeft:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"yimediter.bundle/left"] forState:UIControlStateNormal];
    [leftButton setImage:[[UIImage imageNamed:@"yimediter.bundle/left"]YIMImageWithTintColor:self.setting.tintColor] forState:UIControlStateSelected];
    [self.contentView addSubview:leftButton];
    
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerButton addTarget:self action:@selector(clickCenter:) forControlEvents:UIControlEventTouchUpInside];
    [centerButton setImage:[UIImage imageNamed:@"yimediter.bundle/center"] forState:UIControlStateNormal];
    [centerButton setImage:[[UIImage imageNamed:@"yimediter.bundle/center"]YIMImageWithTintColor:self.setting.tintColor] forState:UIControlStateSelected];
    [self.contentView addSubview:centerButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(clickRight:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"yimediter.bundle/right"] forState:UIControlStateNormal];
    [rightButton setImage:[[UIImage imageNamed:@"yimediter.bundle/right"]YIMImageWithTintColor:self.setting.tintColor] forState:UIControlStateSelected];
    [self.contentView addSubview:rightButton];
    
    self.leftButton = leftButton;
    self.centerButton = centerButton;
    self.rightButton = rightButton;
    self.titleLabel = titleLabel;
}
-(CGFloat)needHeight{
    return 44;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, self.titleLabel.attributedText.size.width, self.titleLabel.attributedText.size.height);
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.frame), self.titleLabel.attributedText.size.height/2 + 8);
    [self layoutButtons:@[self.leftButton,self.centerButton,self.rightButton]];
}

#pragma -mark events
-(void)clickLeft:(UIButton*)sender{
    [self cancelAllButtonSelected];
    [sender setSelected:true];
    [self valueChange:NSTextAlignmentLeft];
}
-(void)clickCenter:(UIButton*)sender{
    [self cancelAllButtonSelected];
    [sender setSelected:true];
    [self valueChange:NSTextAlignmentCenter];
}
-(void)clickRight:(UIButton*)sender{
    [self cancelAllButtonSelected];
    [sender setSelected:true];
    [self valueChange:NSTextAlignmentRight];
}

#pragma -mark get set
-(NSTextAlignment)currentTextAlignment{
    if (self.leftButton.isSelected) {
        return NSTextAlignmentLeft;
    }
    if(self.centerButton.isSelected){
        return NSTextAlignmentCenter;
    }
    if(self.rightButton.isSelected){
        return NSTextAlignmentRight;
    }
    return NSTextAlignmentLeft;
}
-(void)setCurrentTextAlignment:(NSTextAlignment)currentTextAlignment{
    [self cancelAllButtonSelected];
    switch (currentTextAlignment) {
        case NSTextAlignmentRight:{
            [self.rightButton setSelected:true];
            break;
        }
        case NSTextAlignmentCenter:{
            [self.centerButton setSelected:true];
            break;
        }
        case NSTextAlignmentLeft:{
            [self.leftButton setSelected:true];
            break;
        }
        default:
            break;
    }
}

#pragma -mark private methods
/**布局按钮*/
-(void)layoutButtons:(NSArray<UIButton*>*)buttons{
    CGFloat height = [self buttonHeight];
    CGFloat width = [self buttonWidth];
    
    CGFloat startXPoint = (CGRectGetWidth(self.frame) - width*buttons.count)/2;
    CGFloat yPoint = (CGRectGetHeight(self.frame) - CGRectGetMaxY(self.titleLabel.frame) - 4 - height)/2 + CGRectGetMaxY(self.titleLabel.frame) + 4;
    
    for (NSInteger i = 0; i < buttons.count; i++) {
        buttons[i].frame = CGRectMake(startXPoint + i * width, yPoint , width, height);
    }
}
-(void)cancelAllButtonSelected{
    [self.leftButton setSelected:false];
    [self.rightButton setSelected:false];
    [self.centerButton setSelected:false];
}
-(void)valueChange:(NSTextAlignment)alignment{
    if (self.alignmentChangeBlock) {
        self.alignmentChangeBlock(alignment);
    }
}
-(CGFloat)buttonHeight{
    return CGRectGetHeight(self.frame) - CGRectGetMaxY(self.titleLabel.frame) - 4;
}
-(CGFloat)buttonWidth{
    return 56;
}
@end
