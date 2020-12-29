//
//  LJObjectsViewController.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJObjectsViewController : UIViewController

@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, assign) LJObjectsViewControllerType viewControllerType;

@property (nonatomic, assign) BOOL isFromClassify;

@property (nonatomic, assign) BOOL isFromSearch;

@property (nonatomic, assign) BOOL isBackObjc;

@property (nonatomic, copy) NSString *titleN;
@end
