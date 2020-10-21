//
//  YLPhotoBrowserViewController.h
//  SportChina
//
//  Created by 杨磊 on 2018/3/20.
//  Copyright © 2018年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface YLPhotoBrowserViewController : UIViewController
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIView *customNav;
@property (nonatomic, strong) NSMutableArray *dataAry;
@end
