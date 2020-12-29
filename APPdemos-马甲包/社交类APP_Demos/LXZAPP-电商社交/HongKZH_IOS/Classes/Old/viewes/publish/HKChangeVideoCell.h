//
//  HKChangeVideoCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeVideoBlock)(void);
@protocol HKChangeVideoCellDelegate <NSObject>

@optional
-(void)changeVideoBlock;
@end
@interface HKChangeVideoCell : UITableViewCell
@property (nonatomic, strong) id data;
@property (nonatomic,weak) id<HKChangeVideoCellDelegate> delegate;
@end
