//
//  UIImageView+LLExtension.m
//  Andy_Category
//
//  Created by 933 on 15/12/30.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import "UIImageView+LLExtension.h"

@interface LLExtensionImageView : UIImageView

@property(nonatomic,copy)ImageViewButtonClickBlock action;

@end

@implementation LLExtensionImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [b addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];

    }
    return self;
}
-(void)buttonClick:(UIButton *)button
{
    if (self.action)
    {
        self.action(button);
    }
}
@end

@implementation UIImageView (LLExtension)

//创建普通的imageView
+(instancetype)LL_createImageViewWithFrame:(CGRect)frame
                               imageString:(NSString *)imageString
{
    UIImageView *img = [[UIImageView alloc]initWithFrame:frame];
    img.image = [UIImage imageNamed:imageString];
    return img;
}
//创建带点击方法的imageView
+(instancetype)LL_createImageViewWithFrame:(CGRect)frame
                               imageString:(NSString *)imageString
                                 actionSel:(ImageViewButtonClickBlock)action
{
    LLExtensionImageView *img = [[LLExtensionImageView alloc]initWithFrame:frame];
    img.image = [UIImage imageNamed:imageString];
    img.action = action;
    img.userInteractionEnabled = YES;
    return img;
}
@end
