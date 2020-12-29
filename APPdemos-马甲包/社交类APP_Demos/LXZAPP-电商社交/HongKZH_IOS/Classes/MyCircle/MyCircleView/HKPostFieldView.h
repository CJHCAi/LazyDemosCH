//
//  HKPostFieldView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommitBottomDelegete <NSObject>


-(void)publishCommitWith:(NSString *)Content;

@end
@interface HKPostFieldView : UIView

@property (nonatomic, weak)id <CommitBottomDelegete>delegete;

-(void)becomeFirstRespond;

@end
