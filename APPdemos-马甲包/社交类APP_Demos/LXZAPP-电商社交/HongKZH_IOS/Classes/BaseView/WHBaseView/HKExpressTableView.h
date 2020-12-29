//
//  HKExpressTableView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKExpressTableViewDelegate <NSObject>

@optional
-(void)expressTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface HKExpressTableView : UIView

@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic,weak) id<HKExpressTableViewDelegate> expressDelegate;
@end
