//
//  ProgressView.h
//  ProgressViewDome
//
//  Created by Rainy on 2017/12/28.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,assign)CGFloat progress;
-(void)addAccountIMG:(UIImage *)imageNew;
-(void)addColorNew:(UIColor *)color selcolorNew:(UIColor *)selcolor;
@end
