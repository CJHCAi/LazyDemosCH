//
//  HKCollageInfoToolBar.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^ToolBlock)(NSInteger sender);
@protocol HKCollageInfoToolBarDelegate <NSObject>

@optional
-(void)toolBlock:(NSInteger)sender;
@end
@interface HKCollageInfoToolBar : UIView

//@property (nonatomic, copy)ToolBlock block;
@property (nonatomic,weak) id<HKCollageInfoToolBarDelegate> delegate;
-(void)RefreshToolBarUI;

-(void)setCountLabelWithNumber:(NSInteger)number;

@end
