//
//  CXDragViewController.h
//  CXDragTableView_Example
//
//  Created by caixiang on 2019/9/11.
//  Copyright © 2019 616704162@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXDragViewController : UIViewController

typedef NS_ENUM(NSUInteger,CXDragViewType) {
    CXDragViewTypeNone = 0,
    CXDragViewTypeGroup = 1,
    CXDragViewTypeNoneGroup = 2,
    CXDragViewTypeAppoint = 3
};

@property (assign, nonatomic) CXDragViewType dragViewType;
@end
