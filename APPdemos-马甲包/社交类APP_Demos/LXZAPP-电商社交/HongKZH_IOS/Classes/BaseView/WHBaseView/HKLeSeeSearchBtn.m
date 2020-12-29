//
//  HKLeSeeSearchBtn.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeSeeSearchBtn.h"
#import "UIView+Xib.h"
#import "UIImage+YY.h"
@interface HKLeSeeSearchBtn()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;

@end

@implementation HKLeSeeSearchBtn

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    UIImage*image = [UIImage createImageWithColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1] size:CGSizeMake(kScreenWidth-110, 30)];
    image = [image zsyy_imageByRoundCornerRadius:15];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 15;
    self.iconView.image = image;
}
-(void)setTitle:(NSString*)title isCenter:(BOOL)isCenter backColor:(UIColor*)color cornerRadius:(CGFloat)radius width:(CGFloat)width{
    self.titleText.text = title;
    if (isCenter) {
        self.left.constant = self.width*0.5-7.5;
    }
    UIImage*image = [UIImage createImageWithColor:color size:CGSizeMake(self.width, 30)];
    image = [image zsyy_imageByRoundCornerRadius:radius];
    self.iconView.layer.masksToBounds =YES;
    self.iconView.image = image;
}
- (IBAction)btnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoSearch)]) {
        [self.delegate gotoSearch];
    }
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    UIImage*image;
    if (isSelect) {
       image  = [UIImage createImageWithColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1] size:CGSizeMake(kScreenWidth-110, 30)];
        image = [image zsyy_imageByRoundCornerRadius:15];
        
    }else{
        image  = [UIImage createImageWithColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1] size:CGSizeMake(kScreenWidth-110, 30)];
        image = [image zsyy_imageByRoundCornerRadius:15];
    }
    self.iconView.image = image;
}
@end
