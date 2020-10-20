//
//  MMTabBar.m
//  MediaUnitedKit
//
//  Created by LEA on 2017/9/21.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMTabBar.h"

@implementation MMTabBar

- (MMTabBar *)initWithFrame:(CGRect)frame titles:(NSArray *)titles images:(NSArray *)images selectdColor:(UIColor *)selectdColor selectedImages:(NSArray *)selectedImages;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [RGBColor(190, 193, 195, 1.0) CGColor];
        layer.frame = CGRectMake(0, 0, self.width, 0.7);
        [self.layer addSublayer:layer];
        
        if (!selectdColor) {
            selectdColor = RGBColor(11, 136, 255, 1);
        }
        
        NSInteger itemNum = [images count];
        
        //设置UI
        CGFloat w = self.width/itemNum;
        CGFloat h = 50;
        UIImage *image = [images objectAtIndex:0];
        UIFont *font = [UIFont systemFontOfSize:10.0];
        CGFloat imageW = image.size.width;
        CGFloat imageH = image.size.height;
        CGFloat textWidth = 0, top = 0, left = 0;
        NSString *title = nil;
        UIButton *item = nil;
        for (NSInteger i = 0; i < itemNum; i ++)
        {
            title = [titles objectAtIndex:i];
            textWidth = [title sizeWithFont:font maxSize:CGSizeMake(kWidth, 17)].width;
            top = (h-imageH-17)/2+3;
            left = (w-imageW)/2;
            
            item = [[UIButton alloc] initWithFrame:CGRectMake(w * i, 0, w, h)];
            item.backgroundColor = [UIColor clearColor];
            item.selected = NO;
            item.tag = 100+i;
            item.titleLabel.font = font;
            item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [item setTitle:title forState:UIControlStateNormal];
            [item setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [item setTitleColor:selectdColor forState:UIControlStateHighlighted];
            [item setImage:[images objectAtIndex:i] forState:UIControlStateNormal];
            [item setImage:[selectedImages objectAtIndex:i] forState:UIControlStateHighlighted];
            [item setImageEdgeInsets:UIEdgeInsetsMake(top, left, h-imageH-top, left)];
            [item setTitleEdgeInsets:UIEdgeInsetsMake(top+imageH, left-(imageW+textWidth)/2, h-(top+imageH+17), 0)];
            [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
        }
    }
    return self;
}

#pragma mark - 点击
- (void)itemClicked:(UIButton *)item
{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectAtIndex:)]) {
        [self.delegate tabBar:self didSelectAtIndex:item.tag-100];
    }
}

@end

