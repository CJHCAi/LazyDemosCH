//
//  VerticalLabel.h
//  VerticalLabel
//
//  Created by horry on 15/8/18.
//  Copyright (c) 2015年 ___horryBear___. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, VerticalTextAligment) {
	VerticalTextAligmentRight,		//右对齐
	VerticalTextAligmentCenter,		//居中
	VerticalTextAligmentLeft		//左对齐
};

@interface VerticalLabel : UIView

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic) VerticalTextAligment aligment;

@end
