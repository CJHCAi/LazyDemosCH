//
//  UITextCell.h
//  TextFulldemo
//
//  Created by 刘昊 on 17/10/17.
//  Copyright © 2017年 刘昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextCell : UITableViewCell
@property (nonatomic, assign) BOOL isFill;
- (void)reloadData:(NSString *)data;
@end
