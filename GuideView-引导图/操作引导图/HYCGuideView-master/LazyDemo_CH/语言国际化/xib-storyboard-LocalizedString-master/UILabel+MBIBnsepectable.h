//
//  UILabel+MBIBnsepectable.h
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MBIBnsepectable)
// set text hex color
@property (assign,nonatomic) IBInspectable NSString *textHexColor;
@property (nonatomic, strong) IBInspectable NSString *localizedString;

@end
