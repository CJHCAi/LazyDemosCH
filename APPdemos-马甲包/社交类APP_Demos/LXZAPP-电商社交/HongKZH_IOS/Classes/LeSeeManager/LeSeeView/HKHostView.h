//
//  HKHostView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKHostViewDelegate <NSObject>

@optional
-(void)toCellHot:(NSInteger)tag;
@end
@interface HKHostView : UIView
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic,weak) id<HKHostViewDelegate> delegate;
@end
