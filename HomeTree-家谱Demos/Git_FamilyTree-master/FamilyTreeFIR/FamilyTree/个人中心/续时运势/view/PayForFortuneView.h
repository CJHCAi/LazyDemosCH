//
//  PayForFortuneView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PayForFortuneView;

@protocol PayForFortuneViewDelegate <NSObject>

-(void)toPayForForeverFortuneView;

@end

@interface PayForFortuneView : UIView
/** 代理人*/
@property (nonatomic, weak) id<PayForFortuneViewDelegate> delegate;
@end
