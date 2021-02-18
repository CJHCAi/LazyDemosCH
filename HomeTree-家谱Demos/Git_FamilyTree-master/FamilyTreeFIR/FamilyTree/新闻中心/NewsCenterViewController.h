//
//  NewsCenterViewController.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/7.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "BaseViewController.h"
#import "HundredNamesView.h"
@interface NewsCenterViewController : BaseViewController
@property (nonatomic,strong) UIScrollView *bacScrollView; /*背景滚动图*/
@property (nonatomic,strong) HundredNamesView *hundredVies; /*百家姓*/

@end
