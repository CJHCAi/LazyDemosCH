//
//  FamilyButton.m
//  drawDrawFamilyTree
//
//  Created by Nicole on 2018/3/16.
//  Copyright © 2018年 Nicole. All rights reserved.
//

#import "FamilyButton.h"

@interface FamilyButton () {
    UIColor *_maleBorderColor;
    UIColor *_femaleBorderColor;
}
@end

@implementation FamilyButton
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.imageEdgeInsets = UIEdgeInsetsMake(-25, 0, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -60, -60, 0);
        [self addTarget:self action:@selector(buttonDidClickItem) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    
    [self setTitle:titleName forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12 weight:10];
    [self setTitleColor:[UIColor colorWithRed:45/255.0 green:45/255.0 blue:47/255.0 alpha:1.0] forState:UIControlStateNormal];
    
}

- (void)setAvatarString:(NSString *)avatarString {
    
    _avatarString = avatarString;
    UIImage *avatar;
    if ([self isNilString:avatarString]) {
        avatar = [UIImage imageNamed:@"fx_default_useravatar"];
        avatar = [self scaleToSize:avatar size:CGSizeMake(60, 60)];
    }else if(avatarString.length == 0 || [avatarString isEqualToString:@"false"]){
        avatar = [UIImage imageNamed:@"fx_default_useravatar"];
        avatar = [self scaleToSize:avatar size:CGSizeMake(60, 60)];
    }else{
        avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarString]]];
        avatar = [self scaleToSize:avatar size:CGSizeMake(60, 60)];
    }
    [self setImage:avatar forState:UIControlStateNormal];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)setModel:(FamilyModel *)model {
    _model = model;
    self.titleName = model.appellation;
    self.avatarString = model.avatar;
    
    if (model.gender == male) {
        self.layer.borderColor = self.maleBorderColor.CGColor;
    }
    else{
        self.layer.borderColor = self.femaleBorderColor.CGColor;
    }
}

- (UIColor *)maleBorderColor {
    if (_maleBorderColor != nil) {
        return _maleBorderColor;
    }
    return [UIColor colorWithRed:131/255.0 green:166/255.0 blue:192/255.0 alpha:1.0];
}

- (UIColor *)femaleBorderColor {
    if (_femaleBorderColor != nil) {
        return _femaleBorderColor;
    }
    return [UIColor colorWithRed:240/255.0 green:140/255.0 blue:154/255.0 alpha:1.0];
}

- (void)setMaleBorderColor:(UIColor *)color {
    _maleBorderColor = color;
    [self refreshBorderColor];
}

- (void)setFemaleBorderColor:(UIColor *)color {
    _femaleBorderColor = color;
    [self refreshBorderColor];
}

#pragma mark - Private Functions
- (void)refreshBorderColor {
    if (_model.gender == male) {
        self.layer.borderColor = self.maleBorderColor.CGColor;
    }
    else{
        self.layer.borderColor = self.femaleBorderColor.CGColor;
    }
}

- (void)buttonDidClickItem{
    if ([self.delegate respondsToSelector:@selector(buttonDidClickItemAtFamilyModel:)]) {
        [self.delegate buttonDidClickItemAtFamilyModel:_model];
    }
}

- (BOOL)isNilString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    return NO;
}
@end
