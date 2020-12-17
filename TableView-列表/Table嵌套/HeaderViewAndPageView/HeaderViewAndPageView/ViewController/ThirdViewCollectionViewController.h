//
//  ThirdViewCollectionViewController.h
//  CanPlay
//
//  Created by yangpan on 2016/12/15.
//  Copyright © 2016年 ZJW. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TitleScrollView.h"
#import "ParentClassScrollViewController.h"

@interface ThirdViewCollectionViewController : ParentClassScrollViewController
//@property(nonatomic,strong)UICollectionView *colleciont;
@property(nonatomic,strong)TitleScrollView * titleScrollView;
@end
