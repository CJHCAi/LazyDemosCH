//
//  HKCommitSelfMeadioTool.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKCommitSelfMeadioToolDelegate <NSObject>

@optional
-(void)commitWithText:(NSString*)text;
-(void)commitCommentWithText:(NSString*)text;
@end
@interface HKCommitSelfMeadioTool : UIView
@property (nonatomic,weak) id<HKCommitSelfMeadioToolDelegate> delegate;

@property (nonatomic,assign) int type;
@end
