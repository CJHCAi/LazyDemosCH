//
//  HKIconAndTitleCenterView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKIconAndTitleCenterView.h"
#import "UIView+Xib.h"
@interface HKIconAndTitleCenterView()
@property (nonatomic,weak) IBOutlet UIImageView *backIcon;
@property (nonatomic,weak) IBOutlet UIImageView *Icon;
@property (nonatomic,weak) IBOutlet UILabel *title;

@end

@implementation HKIconAndTitleCenterView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    if (self.titleString) {
        self.titleString = self.titleString;
    }
    if (self.backColor) {
        self.backColor = self.backColor;
    }
    
    if (self.font) {
         self.font = self.font;
    }
    if (self.color) {
        self.color = self.color;
    }
    
    if (self.imageName) {
         self.imageName = self.imageName;
    }
   
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // TODO:init
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
-(void)setTitleColor:(UIColor*)color titleFont:(UIFont*)font imageName:(NSString*)imageName backColor:(UIColor*)backColor title:(NSString*)title{
    self.title.text = title;
    self.backColor = backColor;
    self.font = font;
    self.color = color;
    
    self.imageName = imageName;
}
- (instancetype)initTitleCenterViewWithTitle:(NSString*)title imageName:(NSString*)name backColor:(UIColor*)color click:(BtnClick)click
{
    self = [super init];
    if (self) {
        self.click = click;
        self.titleString = title;
        self.backColor = color;
        self.imageName = name;
    }
    return self;
}
+(instancetype)iconAndTitleCenterViewWithTitle:(NSString*)title imageName:(NSString*)name backColor:(UIColor*)color click:(BtnClick)click{
    return [[HKIconAndTitleCenterView alloc]initTitleCenterViewWithTitle:title imageName:name backColor:color click:click];
}
-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.Icon.image = [UIImage imageNamed:imageName];
}
-(void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.title.text = titleString;
}
-(void)setBackColor:(UIColor *)backColor{
    _backColor = backColor;
     self.backIcon.image = [UIImage imageWithColor:backColor];
}
-(IBAction)clickBtn{
    if (self.click) {
        self.click(self);
    }
}
-(void)setColor:(UIColor *)color{
    _color = color;
    self.title.textColor = color;
}
-(void)setFont:(UIFont *)font{
    _font = font;
      self.title.font = font;
}
@end
