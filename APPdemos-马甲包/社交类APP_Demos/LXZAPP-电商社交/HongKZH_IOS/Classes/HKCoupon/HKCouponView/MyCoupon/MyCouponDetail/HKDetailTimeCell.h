//
//  HKDetailTimeCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKDetailTimeCell : UITableViewCell

@property (nonatomic, copy) NSString *endStr;

-(void)setTeamNumber:(NSInteger)number;

-(void)clearText;

@end
