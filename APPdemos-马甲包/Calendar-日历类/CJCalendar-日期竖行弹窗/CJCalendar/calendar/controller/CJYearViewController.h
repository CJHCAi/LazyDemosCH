//
//  CJYearViewController.h
//  CJCalendar
//
//  Created by chjsun on 16/5/24.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YearViewControllerDelegate <NSObject>

@optional
-(void)yearTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath cellText:(NSString *)cellText;

@end

@interface CJYearViewController : UITableViewController

/** 选中状态的color */
@property (nonatomic, strong) UIColor *selectColor;

// 根据时间更新tableview
-(void) refreshControlWithCellText: (NSString *)year;

/** 代理 */
@property (nonatomic, assign) id<YearViewControllerDelegate> delegate;

@end
