//
//  historyTableViewCell.h
//  Calculator1
//
//  Created by ruru on 16/4/22.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMResultSet.h"


@interface historyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *yearLable;
@property (weak, nonatomic) IBOutlet UILabel *monthLable;
@property (weak, nonatomic) IBOutlet UILabel *infoLable;
@property (weak, nonatomic) IBOutlet UILabel *mathResultLable;

-(id)initWithData:(NSDictionary *)info tableView:tableView;
@end
