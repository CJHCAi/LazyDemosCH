//
//  HKSubmissionView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKSubmissionViewDeleegate <NSObject>

@optional
-(void)submissionViewData;

@end
@interface HKSubmissionView : UIView
@property (nonatomic,assign) BOOL btnuserInteractionEnabled;
@property (nonatomic,weak) id<HKSubmissionViewDeleegate> delegate;
@end
