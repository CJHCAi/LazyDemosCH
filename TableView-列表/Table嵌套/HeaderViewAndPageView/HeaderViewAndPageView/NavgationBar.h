//
//  NavgationBar.h
//  CanPlay
//
//  Created by yangpan on 2016/12/15.
//  Copyright © 2016年 ZJW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavgationBar : UIView

@property (nonatomic,strong)UILabel *title_label;

-(void)creatNavgationgBarWithTextColor :(UIColor *)color withTitleText :(NSString *)title;
@end
