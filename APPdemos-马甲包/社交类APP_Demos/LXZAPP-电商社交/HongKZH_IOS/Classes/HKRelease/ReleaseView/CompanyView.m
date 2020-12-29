//
//  CompanyView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "CompanyView.h"
#import "UIView+Xib.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
@interface CompanyView()
@property (nonatomic,weak)IBOutlet  ZSUserHeadBtn*headBtn;
@property (nonatomic,weak)IBOutlet  UILabel*name;
@property (nonatomic,weak)IBOutlet  UILabel*desc;
@end

@implementation CompanyView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
}
-(void)setName:(NSString*)name desc:(NSString*)desc headImage:(NSString*)headImage{
    self.name.text = name;
    self.desc.text = desc;
    [self.headBtn hk_setBackgroundImageWithURL:headImage forState:0 placeholder:kPlaceholderImage];
}
@end
