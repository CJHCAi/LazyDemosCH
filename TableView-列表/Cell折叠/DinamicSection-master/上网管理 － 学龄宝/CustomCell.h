//
//  CustomCellTableViewCell.h
//  上网管理 － 学龄宝
//
//  Created by MAC on 15/2/4.
//  Copyright (c) 2015年 SaiHello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseInfo.h"

@class BrowseInfo;

@interface CustomCell : UITableViewCell

@property (strong, nonatomic) BrowseInfo *browseInfo;

@property (strong, nonatomic) IBOutlet UILabel *titleLable;
- (IBAction)OnClick:(id)sender;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
