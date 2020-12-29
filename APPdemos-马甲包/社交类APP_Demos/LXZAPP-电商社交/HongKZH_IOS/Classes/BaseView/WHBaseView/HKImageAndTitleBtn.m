//
//  HKImageAndTitleBtn.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKImageAndTitleBtn.h"
#import "UIView+Xib.h"
#import "UIImage+YY.h"
@interface HKImageAndTitleBtn()
@property (nonatomic,weak) IBOutlet UIImageView*iconvIew;
@property (nonatomic,weak) IBOutlet UIImageView *leftIcon;
@property (nonatomic,weak) IBOutlet UILabel*label;
@end

@implementation HKImageAndTitleBtn
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    
    [self.iconvIew addGestureRecognizer:tap];
}
-(void)click{
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:self];
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSelfNameXibOnSelf];
        self.frame = frame;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSelfNameXibOnSelf];
    }
    return self;
}
-(void)setBackColor:(UIColor*)color icon:(NSString*)imageName title:(NSString*)title{
    UIImage*image = [UIImage createImageWithColor:color size:self.bounds.size];
    image = [image zsyy_imageByRoundCornerRadius:self.bounds.size.height*0.5];
    self.iconvIew.image = image;
    self.leftIcon.image = [UIImage imageNamed:imageName];
    self.label.text = title;
}
-(void)setBackColorNoYJ:(UIColor*)color icon:(NSString*)imageName title:(NSString*)title{
    UIImage*image = [UIImage imageWithColor:color];
    self.iconvIew.image = image;
    self.leftIcon.image = [UIImage imageNamed:imageName];
    self.label.text = title;
}
@end
