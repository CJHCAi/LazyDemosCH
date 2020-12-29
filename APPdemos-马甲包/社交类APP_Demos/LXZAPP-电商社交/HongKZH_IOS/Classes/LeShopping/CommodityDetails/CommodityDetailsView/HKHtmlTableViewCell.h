//
//  HKHtmlTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@protocol HKHtmlTableViewCellDeleagte <NSObject>

@optional
-(void)htmlScroll:(CGFloat)y;

@end
@interface HKHtmlTableViewCell : BaseTableViewCell
@property (nonatomic, copy)NSString *htmlStr;
@property (nonatomic,weak) id<HKHtmlTableViewCellDeleagte> delegate;
@end
