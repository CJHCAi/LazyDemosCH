//
//  HKMyCiecleHeadView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKMyCiecleHeadViewDelegate <NSObject>

-(void)gotoSearch;
-(void)clickWithRow:(int)row;
@end
@interface HKMyCiecleHeadView : UIView
@property (nonatomic,weak) id<HKMyCiecleHeadViewDelegate> delegate;
@end
