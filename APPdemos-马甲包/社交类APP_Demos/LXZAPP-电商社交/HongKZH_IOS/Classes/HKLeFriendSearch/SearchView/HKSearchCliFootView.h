//
//  HKSearchCliFootView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKSearchCliFootViewDelegate <NSObject>

@optional
-(void)footerClick;
@end
@interface HKSearchCliFootView : UIView
@property (nonatomic, copy)NSString *searchText;
@property (nonatomic,weak) id<HKSearchCliFootViewDelegate> delegate;
@end
