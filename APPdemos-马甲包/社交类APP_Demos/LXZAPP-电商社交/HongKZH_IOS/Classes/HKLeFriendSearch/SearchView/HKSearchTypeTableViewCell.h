//
//  HKSearchTypeTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKLESearchBaseModel;
@interface HKSearchTypeTableViewCell : UITableViewCell
+(instancetype)searchTypeCellWithTableView:(UITableView*)tableView;
-(void)setModelWithType:(int)type andModel:(NSObject*)Model;
@property (nonatomic, strong)RCMessage *messageM;
@end
