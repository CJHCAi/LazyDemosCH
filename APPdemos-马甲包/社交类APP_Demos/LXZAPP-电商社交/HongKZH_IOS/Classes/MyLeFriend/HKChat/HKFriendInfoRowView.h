//
//  HKFriendInfoRowView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKFriendInfoRowViewDelegate <NSObject>
@optional
-(void)goToInfo;

@end
@interface HKFriendInfoRowView : UIView
-(void)settingInfoWithName:(NSString*)name sex:(NSInteger)sex desc:(NSString*)desc headImage:(NSString*)headImage;
@property (nonatomic,weak) id<HKFriendInfoRowViewDelegate> delegate;
@end
