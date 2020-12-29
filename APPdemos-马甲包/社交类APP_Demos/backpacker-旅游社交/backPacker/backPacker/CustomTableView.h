//
//  CustomTableView.h
//  backPacker
//
//  Created by 聂 亚杰 on 13-6-6.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchTableViewDelegate <NSObject>

@optional
-(void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface CustomTableView : UITableView
@property (nonatomic,assign)id<TouchTableViewDelegate>touchDelegate;
@end
