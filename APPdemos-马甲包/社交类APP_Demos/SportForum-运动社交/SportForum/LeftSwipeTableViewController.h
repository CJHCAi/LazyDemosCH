//
//  LeftSwipeTableViewController.h
//  SportForum
//
//  Created by liyuan on 14-6-24.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"

@class LeftSwipeTableViewController;

@protocol LeftSwipeTableViewDelegate <NSObject>
@required
- (NSInteger) numberOfCells:(LeftSwipeTableViewController *)leftSwipeTableViewController;
- (UITableViewCell *) leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView RowIndex:(NSIndexPath *)indexPath;

@optional
- (CGFloat)leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView didSelectRow:(NSIndexPath *)indexPath;

//Return YES - Support to delete cell function when swipe else NO.
- (BOOL)leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface LeftSwipeTableViewController : RefreshTableView <UIGestureRecognizerDelegate>

@property(nonatomic, weak) id <LeftSwipeTableViewDelegate> leftSwipeTableViewDelegate;

@end
