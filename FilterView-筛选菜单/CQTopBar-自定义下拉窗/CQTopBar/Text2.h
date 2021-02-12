//
//  Text2.h
//  CQTopBar
//
//  Created by yto on 2018/1/22.
//  Copyright © 2018年 CQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Text2;
@protocol Text2Delegate <NSObject>
@optional
- (void)didSelect;
@end

@interface Text2 : UIViewController
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, weak) id<Text2Delegate>delegate;
@end
