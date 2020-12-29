//
//  MyVideoViewController.h
//  IStone
//
//  Created by 胡传业 on 14-7-20.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "REFrostedViewController.h"

<<<<<<< HEAD
@interface MyVideoViewController : UIViewController<UITabBarDelegate,UITableViewDataSource>

=======
@interface MyVideoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray                                 *filesname;//文件名字数组
    NSString                                *path;//文件路径
}
>>>>>>> 刘任驰“分支
-(IBAction)showMenu;

@end
