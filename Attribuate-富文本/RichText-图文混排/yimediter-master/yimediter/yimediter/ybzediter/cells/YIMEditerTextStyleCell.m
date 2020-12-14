//
//  YIMEditerTextStyleCell.m
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerTextStyleCell.h"
#import "UIImage+YIMEditerImageExtend.h"
#import "YIMEditerSetting.h"

@interface YIMEditerTextStyleCell()
@property(nonatomic,strong)UIButton *boldButton;
@property(nonatomic,strong)UIButton *italicButton;
@property(nonatomic,strong)UIButton *underlineButton;
@end

@implementation YIMEditerTextStyleCell
-(void)setup{
    [super setup];
    UIButton *boldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [boldButton addTarget:self action:@selector(clickBold:) forControlEvents:UIControlEventTouchUpInside];
    [boldButton setImage:[UIImage imageNamed:@"yimediter.bundle/bold"] forState:UIControlStateNormal];
    [boldButton setImage:[[UIImage imageNamed:@"yimediter.bundle/bold"]YIMImageWithTintColor:self.setting.tintColor] forState:UIControlStateSelected];
    [self.contentView addSubview:boldButton];
    
    UIButton *italicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [italicButton addTarget:self action:@selector(clickItalic:) forControlEvents:UIControlEventTouchUpInside];
    [italicButton setImage:[UIImage imageNamed:@"yimediter.bundle/italic"] forState:UIControlStateNormal];
    [italicButton setImage:[[UIImage imageNamed:@"yimediter.bundle/italic"]YIMImageWithTintColor:self.setting.tintColor] forState:UIControlStateSelected];
    [self.contentView addSubview:italicButton];
    
    UIButton *underlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [underlineButton addTarget:self action:@selector(clickUnderline:) forControlEvents:UIControlEventTouchUpInside];
    [underlineButton setImage:[UIImage imageNamed:@"yimediter.bundle/underline"] forState:UIControlStateNormal];
    [underlineButton setImage:[[UIImage imageNamed:@"yimediter.bundle/underline"]YIMImageWithTintColor:self.setting.tintColor] forState:UIControlStateSelected];
    [self.contentView addSubview:underlineButton];
    
    self.boldButton = boldButton;
    self.italicButton = italicButton;
    self.underlineButton = underlineButton;
}
-(CGFloat)needHeight{
    return 54;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutButtons:@[self.boldButton,self.italicButton,self.underlineButton]];
}

#pragma -mark get set
-(BOOL)isBold{
    return self.boldButton.isSelected;
}
-(void)setIsBold:(BOOL)isBold{
    [self.boldButton setSelected:isBold];
}
-(BOOL)isItalic{
    return self.italicButton.isSelected;
}
-(void)setIsItalic:(BOOL)isItalic{
    [self.italicButton setSelected:isItalic];
}
-(BOOL)isUnderline{
    return self.underlineButton.selected;
}
-(void)setIsUnderline:(BOOL)isUnderline{
    [self.underlineButton setSelected:isUnderline];
}

#pragma -mark events
-(void)clickBold:(UIButton*)sender{
    [sender setSelected:!sender.selected];
    if(self.boldChangeBlock){
        self.boldChangeBlock(sender.isSelected);
    }
}
-(void)clickItalic:(UIButton*)sender{
    [sender setSelected:!sender.selected];
    if(self.italicChangeBlock){
        self.italicChangeBlock(sender.isSelected);
    }
}
-(void)clickUnderline:(UIButton*)sender{
    [sender setSelected:!sender.selected];
    if(self.underlineChangeBlock){
        self.underlineChangeBlock(sender.isSelected);
    }
}


#pragma -mark private methods
/**布局按钮*/
-(void)layoutButtons:(NSArray<UIButton*>*)buttons{
    CGFloat height = [self buttonHeight];
    CGFloat width = [self buttonWidth];
    
    CGFloat startXPoint = (CGRectGetWidth(self.frame) - width*buttons.count)/2;
    CGFloat yPoint = (CGRectGetHeight(self.frame) - height)/2;
    
    for (NSInteger i = 0; i < buttons.count; i++) {
        buttons[i].frame = CGRectMake(startXPoint + i * width, yPoint , width, height);
    }
}
-(CGFloat)buttonHeight{
    return CGRectGetHeight(self.frame);
}
-(CGFloat)buttonWidth{
    return 56;
}

@end
