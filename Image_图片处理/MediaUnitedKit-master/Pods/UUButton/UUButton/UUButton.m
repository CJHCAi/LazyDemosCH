//
//  UUButton.m
//  UUButton
//
//  Created by LEA on 2017/12/8.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "UUButton.h"

@implementation UUButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.spacing = 5.0;
    }
    return self;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self setupContentAlignment];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self setupContentAlignment];
}

- (void)setContentAlignment:(UUContentAlignment)contentAlignment
{
    _contentAlignment = contentAlignment;
    [self setupContentAlignment];
}

- (void)setupContentAlignment
{
    // 获取图文size
    CGFloat image_w = self.imageView.bounds.size.width;
    CGFloat image_h = self.imageView.bounds.size.height;
    CGFloat title_w = self.titleLabel.bounds.size.width;
    CGFloat title_h = self.titleLabel.bounds.size.height;
    
    UIEdgeInsets imageEdgeInset = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInset = UIEdgeInsetsZero;
    // 执行switch
    switch (self.contentAlignment)
    {
        case UUContentAlignmentNormal:
        {
            imageEdgeInset = UIEdgeInsetsMake(0, 0, 0, self.spacing);
            titleEdgeInset = UIEdgeInsetsMake(0, self.spacing, 0, 0);
            break;
        }
        case UUContentAlignmentCenterImageRight:
        {
            imageEdgeInset = UIEdgeInsetsMake(0, title_w + self.spacing, 0, -title_w);
            titleEdgeInset = UIEdgeInsetsMake(0, -image_w - self.spacing, 0, image_w);
            break;
        }
        case UUContentAlignmentCenterImageTop:
        {
            imageEdgeInset = UIEdgeInsetsMake(-title_h - self.spacing, 0, 0, -title_w);
            titleEdgeInset = UIEdgeInsetsMake(0, -image_w, -image_h - self.spacing, 0);
            break;
        }
        case UUContentAlignmentCenterImageBottom:
        {
            imageEdgeInset = UIEdgeInsetsMake(0, 0, -title_h - self.spacing, -title_w);
            titleEdgeInset = UIEdgeInsetsMake(-image_h - self.spacing, -image_w, 0, 0);
            break;
        }
        case UUContentAlignmentLeftImageLeft:
        {
            imageEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
            titleEdgeInset = UIEdgeInsetsMake(0, self.spacing, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        }
        case UUContentAlignmentLeftImageRight:
        {
            imageEdgeInset = UIEdgeInsetsMake(0, title_w + self.spacing, 0, 0);
            titleEdgeInset = UIEdgeInsetsMake(0, -image_w, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        }
        case UUContentAlignmentRightImageLeft:
        {
            imageEdgeInset = UIEdgeInsetsMake(0, 0, 0, self.spacing);
            titleEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            break;
        }
        case UUContentAlignmentRightImageRight:
        {
            imageEdgeInset = UIEdgeInsetsMake(0, 0, 0, -title_w);
            titleEdgeInset = UIEdgeInsetsMake(0, 0, 0, image_w + self.spacing);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            break;
        }
        default:
            break;
    }
    
    // 赋值edgeInset
    self.imageEdgeInsets = imageEdgeInset;
    self.titleEdgeInsets = titleEdgeInset;
}

@end
