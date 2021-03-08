//
//  ProgressHUD.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/8.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHUD : UIView
@property (nonatomic, assign) CGFloat progress;

+ (instancetype)sharedInstance;
+ (void)show;
+ (void)hide;
@end
