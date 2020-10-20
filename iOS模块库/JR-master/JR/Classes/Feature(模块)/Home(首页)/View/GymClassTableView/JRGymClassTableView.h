//
//  JRGymClassTableView.h
//  JR
//
//  Created by Zj on 17/8/19.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JRGymClassTableViewDelegate<NSObject>
@optional
-(void) JRGymClassTableViewdidSelectedRowWithRow:(NSInteger)row;
@end

@interface JRGymClassTableView : UITableView
@property(nonatomic,weak)id<JRGymClassTableViewDelegate> JRdelegate;

@end
