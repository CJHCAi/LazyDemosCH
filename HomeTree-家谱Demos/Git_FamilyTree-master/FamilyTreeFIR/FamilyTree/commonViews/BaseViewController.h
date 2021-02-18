//
//  BaseViewController.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/31.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic,strong) CommonNavigationViews *comNavi; /*导航栏*/

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;

-(instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithShopTitle:(NSString *)title image:(UIImage *)image;

@end
